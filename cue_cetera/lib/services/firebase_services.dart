import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as img;

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
      numThreads: 1, // defaults to 1
      isAsset: true, // defaults to true, set to false to load resources outside assets
      useGpuDelegate: false // defaults to false, set to true to use GPU delegate
  );
  print("Starting inference run");

  for (var value in images.values){
    final path = value.toString().substring(7,31);
    final pathReference = storageRef.child(path);
    final Uint8List? data = await pathReference.getData(1024*1024);
    final image = img.decodeImage(data!);

    //Convert file path to ms
    final secondsString = value.toString().substring(22,24);
    var secondsConv = int.parse(secondsString) * 1000;
    final msString = value.toString().substring(25, 27);
    var msConv = int.parse(msString);
    final timestamp = secondsConv + msConv;

    if(data!.isNotEmpty) {
      // Run Tflite model
      var output = await Tflite.runModelOnBinary(
          binary: imageToByteListFloat32(image!, 224, 127.5, 127.5),
          numResults: 1,
          threshold: 0.05,
          asynch: true
      );

      // Store output in map
      output!.forEach((element) {
          var out = int.parse(element.values.toList()[2].toString());
          modelOutput.putIfAbsent(timestamp, () => out);
      });
    }
  };
}

// Convert pulled image to Float32 byte list for model processing
Uint8List imageToByteListFloat32(
    img.Image image, int inputSize, double mean, double std) {
  var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
  var buffer = Float32List.view(convertedBytes.buffer);
  int pixelIndex = 0;
  for (var i = 0; i < inputSize; i++) {
    for (var j = 0; j < inputSize; j++) {
      var pixel = image.getPixel(j, i);
      buffer[pixelIndex++] = (img.getRed(pixel) - mean) / std;
      buffer[pixelIndex++] = (img.getGreen(pixel) - mean) / std;
      buffer[pixelIndex++] = (img.getBlue(pixel) - mean) / std;
    }
  }
  return convertedBytes.buffer.asUint8List();
}
