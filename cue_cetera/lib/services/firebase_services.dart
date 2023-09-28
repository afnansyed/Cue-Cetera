import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as Tflite;
import 'package:image/image.dart' as img;

void runFirebase(String filePath) async {
  //send file name to db
  DatabaseReference ref = FirebaseDatabase.instance.ref("Videos");

  //send video itself to storage
  final storage = FirebaseStorage.instance.ref();

  final storRef = storage.child(filePath);

  ref.child('paths').push().set({
    "Path": filePath,
  });


  File file = File(filePath);

  try {
    await storRef.putFile(file);
  } on FirebaseException catch (e) {
    throw Exception('Failed to save video');
  }

  runBackend();
}

Future<void> runBackend() async {
  try {
    final result = await FirebaseFunctions.instance.httpsCallable('vid_to_imgs').call('convert');
  } on FirebaseFunctionsException catch (error) {
    print(error.code);
    print(error.details);
    print(error.message);
  }
}