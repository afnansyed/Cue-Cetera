import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:video_player/video_player.dart';
import 'package:camera/camera.dart';

import 'package:cue_cetera/pages/result_display.dart';
import 'package:cue_cetera/services/screen_size.dart';
import 'package:cue_cetera/pages/home.dart';

import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'firebase_options.dart';
import 'package:cloud_functions/cloud_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CUE-CETERA',
      theme: ThemeData(
        //primaryColor: Color(0xff1e133d),
        primaryColor: const Color(0xff1e133d),
      ),
      home: const Home('CUE-CETERA'),
      //home: const ResultDisplay(),
    );
  }
}

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
