import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';

Map modelOutput = Map<int, int>();

Future<Map<int, int>> runFirebase(String filePath) async {
  final userCredential = await FirebaseAuth.instance.signInAnonymously();
  print("Signed in with temporary account.");

  //send file name to db
  final user = userCredential.user!;
  final uid = user.uid;
  DatabaseReference ref = FirebaseDatabase.instance.ref("Videos");

  ref.child('paths/$uid').push().set({
    "Path": filePath,
  });

  //send video itself to storage
  final storage = FirebaseStorage.instance.ref();
  final storRef = storage.child(filePath);

  File file = File(filePath);

  try {
    await storRef.putFile(file);
  }
  on FirebaseException catch (e) {
    throw Exception('Failed to save video');
  }
  
  modelOutput.clear();

  await runBackend(user);

  Completer<Map<int, int>> completer = Completer();
  completer.complete(modelOutput as FutureOr<Map<int, int>>?);
  return completer.future;
}

Future<void> runBackend(User user) async {
  try {
    final result = await FirebaseFunctions.instance
        .httpsCallable('vid_to_imgs')
        .call('convert').whenComplete(() => runModelInference(user));
  }
  on FirebaseFunctionsException catch (error) {
    print(error.code);
    print(error.details);
    print(error.message);
  }
}

Future<void> runModelInference(User user) async {
  // Get images from Firebase
  final uid = user.uid;
  final storageRef = FirebaseStorage.instance.ref();
  Directory root = await getTemporaryDirectory();
  final image_query = await FirebaseDatabase.instance.ref("Images/Paths/$uid")
      .orderByChild('Path')
      .get();

  final images = image_query.value as Map<dynamic, dynamic>;

  //Load model
  Tflite.close();

  try {
    final res = await Tflite.loadModel(
        model: "assets/model_15.tflite",
        labels: "assets/labels.txt", // labels from 0-6 for all emotions
        numThreads: 10, // defaults to 1
        isAsset: true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate: false // defaults to false, set to true to use GPU delegate
    );
  }
  catch (error){
    throw "Could not load TfLite model";
  }

  final options = FaceDetectorOptions();
  final faceDetector = FaceDetector(options: options);

  print("Starting inference run");

  for (var value in images.values) {
    final path = value.toString().substring(7, 60);
    final pathReference = storageRef.child(path);
    Uint8List? data = Uint8List(0);

    try {
      data = await pathReference.getData(1024 * 1024);
    }

    on FirebaseException catch (error){
      print(error.code);
      print(error.message);
    }

    // Write image to temp file
    final image = img.decodeImage(data!);
    final jpg = img.encodeJpg(image!);
    final file = await File('${root.path}/image.jpg').writeAsBytes(jpg);

    //Convert file path to ms
    final secondsString = value.toString().substring(51, 53);
    var secondsConv = int.parse(secondsString) * 1000;
    final msString = value.toString().substring(54, 56);
    var msConv = int.parse(msString);
    final timestamp = secondsConv + msConv;

    if (await detectFace(file, faceDetector)){
      print("Face detected");
      if (data!.isNotEmpty) {
        List? output;
        try {
          output = await Tflite.runModelOnImage(path: '${root.path}/image.jpg',
              imageMean: 127.5, // defaults to 117.0
              imageStd: 127.5, // defaults to 1.0
              numResults: 1, // defaults to 5
              threshold: 0.05, // defaults to 0.1
              asynch: true // defaults to true
          );
        }

        catch (error){
          throw 'Could not run Tflite model on image';
        }

        // Store output in map
        for (var element in output!) {
          var out = int.parse(element.values.toList()[2].toString());
          modelOutput.putIfAbsent(timestamp, () => out);
        }
      }
    }

    else{
      // Just store neutral if a face is not detected.
      print("Face not detected");
      modelOutput.putIfAbsent(timestamp, () => 5);
    }
  }

  faceDetector.close();
}

Future<bool> detectFace(File file, FaceDetector faceDetector) async {
  final inputImage = InputImage.fromFile(file);
  List<Face> faces;

  try {
    faces = await faceDetector.processImage(inputImage);
  }

  catch (error){
    throw 'Could not run face detection model.';
  }

  if(faces.isEmpty) {
    return false;
  }

  else {
    return true;
  }
}
