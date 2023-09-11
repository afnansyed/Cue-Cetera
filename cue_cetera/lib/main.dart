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
        primaryColor: Color(0xff1e133d),
      ),
      home: const Home('CUE-CETERA'),
      //home: const ResultDisplay(),
    );
  }
}

class videoRecord extends StatefulWidget {
  const videoRecord({super.key});
  @override
  State<videoRecord> createState() => _videoRecord();
}

//class _videoRecord written using code from: https://bettercoding.dev/flutter/tutorial-video-recording-and-replay/
//code references in class _videoRecord also from:
// https://pub.dev/packages/camera/example
//https://stackoverflow.com/questions/64070044/how-to-record-a-video-with-camera-plugin-in-flutter
class _videoRecord extends State<videoRecord> {
  late CameraController controllers;
  bool startRecordSetup = true;

  @override
  void initState() {
    cameraSetup();
    super.initState();
  }

  cameraSetup() async {
    final cameras = await availableCameras();
    controllers = CameraController(cameras[0], ResolutionPreset.max);
    await controllers.initialize();

    setState(() => startRecordSetup = false);
  }

  recordVideo() async {
    if (!controllers.value.isRecordingVideo) {
      await controllers.startVideoRecording();
    } else {
      final file = await controllers.stopVideoRecording();
      runFirebase(file.path);
      //Navigator.push(context, MaterialPageRoute(builder: (context) =>  Test(file.path),));
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultDisplay(file.path),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (startRecordSetup) {
      return Container(
        color: Color(0xffc9b6b9),
      );
    } else {
      return Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CameraPreview(controllers),
            FloatingActionButton(
              backgroundColor: Color(0xffc9b6b9),
              onPressed: () => recordVideo(),
              child: Icon(Icons.circle),
            ),
          ],
        ),
      );
    }
  }
}

//class _videoUpload written referrencing code from:
//https://stackoverflow.com/questions/57869422/how-to-upload-a-video-from-gallery-in-flutter
//https://pub.dev/packages/file_picker
class videoUpload extends StatelessWidget {
  const videoUpload({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 172, 158, 158),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 172, 158, 158),
        centerTitle: true,
        toolbarHeight: 100,
        elevation: 0,
        title: Text(
          'CUE-CETERA',
              style: TextStyle(
                fontFamily: 'Lusteria',
                color: Color.fromARGB(255, 66, 39, 39),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),

        ),

      ),
      body: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(50),
            ),
            color: Color.fromARGB(255, 66, 39, 39),
          ),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  'Click Below to Upload a Video\n\n\n',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                    fontFamily: 'Lusteria',
                    color: Color.fromARGB(255, 212, 195, 195),
                    fontSize: 28,
                    ),
                  ),
              ),


   Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () async {
                    var picked = await FilePicker.platform.pickFiles();

                    if (picked != null) {
                      print(picked.files.first.size / (1024 * 1024));
                      if (picked.files.first.size / (1024 * 1024) > 50) {
                        print('File size cannot exceed 50 MB');
                      } else {
                        runFirebase(picked.files.first.path!);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              //builder: (context) =>  Test(picked.files.first.path!)),
                              builder: (context) =>
                                  ResultDisplay(picked.files.first.path!)),
                        );
                      }
                    }
                  },
                  child: Center(
                    child: Text("SELECT"),
                  ),

                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 100),
                    textStyle: TextStyle(
                      fontFamily: 'OpenSans',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                    ),
                    primary: Color.fromARGB(255, 212, 195, 195),
                    onPrimary: Color.fromARGB(255, 66, 39, 39),
                    elevation: 0,
                    shadowColor: Color.fromARGB(255, 66, 39, 39),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  )),
              SizedBox(height: 80),
            ],
          ),
     ],
      ),
      ),
      ),
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
