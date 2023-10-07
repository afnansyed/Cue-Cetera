import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as img;
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter/services.dart';

Map modelOutput = Map<int, int>();

Future<Map<int, int>> runFirebase(String filePath) async {
  //send file name to db
  DatabaseReference ref = FirebaseDatabase.instance.ref("Videos");

  ref.child('paths').push().set({
    "Path": filePath,
  });

  //send video itself to storage
  final storage = FirebaseStorage.instance.ref();

  final storRef = storage.child(filePath);

  File file = File(filePath);

  try {
    await storRef.putFile(file);
  } on FirebaseException catch (e) {
    throw Exception('Failed to save video');
  }

  await runBackend();

  Completer<Map<int, int>> completer = Completer();
  completer.complete(modelOutput as FutureOr<Map<int, int>>?);
  return completer.future;
}

Future<void> runBackend() async {
  try {
    final result = await FirebaseFunctions.instance
        .httpsCallable('vid_to_imgs')
        .call('convert').whenComplete(() => runModelInference());
  } on FirebaseFunctionsException catch (error) {
    print(error.code);
    print(error.details);
    print(error.message);
  }
}

Future<void> runModelInference() async {
  // Get images from Firebase
  final image_query = await FirebaseDatabase.instance.ref("Images/Paths").orderByChild('Path').get();
  final images = image_query.value as Map<dynamic, dynamic>;
  final storageRef = FirebaseStorage.instance.ref();

  //Load model
  Tflite.close();
  final res = await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
      numThreads: 10, // defaults to 1
      isAsset: true, // defaults to true, set to false to load resources outside assets
      useGpuDelegate: false // defaults to false, set to true to use GPU delegate
  );

  Directory root = await getTemporaryDirectory();
  print("Starting inference run");

  for (var value in images.values) {
    final path = value.toString().substring(7, 31);
    final pathReference = storageRef.child(path);
    final Uint8List? data = await pathReference.getData(1024 * 1024);
    final image = img.decodeImage(data!);
    final jpg = img.encodeJpg(image!);
    final file = await File(root.path + '/image.jpg').writeAsBytes(jpg);

    //Convert file path to ms
    final secondsString = value.toString().substring(22, 24);
    var secondsConv = int.parse(secondsString) * 1000;
    final msString = value.toString().substring(25, 27);
    var msConv = int.parse(msString);
    final timestamp = secondsConv + msConv;

    if (await detectFace(file)){
      print("Face detected");
      if (data!.isNotEmpty) {
        var output = await Tflite.runModelOnImage(path: root.path + '/image.jpg',
            imageMean: 127.5,   // defaults to 117.0
            imageStd: 127.5,  // defaults to 1.0
            numResults: 1,    // defaults to 5
            threshold: 0.05,   // defaults to 0.1
            asynch: true      // defaults to true
        );

        // Store output in map
        output!.forEach((element) {
          var out = int.parse(element.values.toList()[2].toString());
          modelOutput.putIfAbsent(timestamp, () => out);
        });
      }
    }

    else{
      // Just store neutral if a face is not detected.
      print("Face not detected");
      modelOutput.putIfAbsent(timestamp, () => 5);
    }
  }
}

Future<bool> detectFace(File file) async {
  final inputImage = InputImage.fromFile(file);
  final options = FaceDetectorOptions();
  final faceDetector = FaceDetector(options: options);
  final List<Face> faces = await faceDetector.processImage(inputImage);
  faceDetector.close();

  if(faces.isEmpty)
      return false;

  else
      return true;
}
