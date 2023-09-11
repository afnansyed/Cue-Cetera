import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

void runFirebase(String filePath) async {
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

  runBackend();
}

Future<void> runBackend() async {
  try {
    final result = await FirebaseFunctions.instance.httpsCallable('pull_from_dB').call('pull');
  } on FirebaseFunctionsException catch (error) {
    print(error.code);
    print(error.details);
    print(error.message);
  }

  try {
    final result = await FirebaseFunctions.instance.httpsCallable('vid_to_imgs').call('convert');
  } on FirebaseFunctionsException catch (error) {
    print(error.code);
    print(error.details);
    print(error.message);
  }

}