import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:video_player/video_player.dart';
import 'package:camera/camera.dart';

import 'package:cue_cetera/pages/result_display.dart';
import 'package:cue_cetera/services/screen_size.dart';

import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'firebase_options.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

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
      home: MyHomePage(title: 'CUE-CETERA'),
      //home: const ResultDisplay(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
          title,
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
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  'Choose an Option',
                  style: TextStyle(
                    fontFamily: 'Lusteria',
                    color: Color.fromARGB(255, 212, 195, 195),
                    fontSize: 37,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  'Begin your exploration',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    color: Color.fromARGB(255, 172, 158, 158),
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              SizedBox(height: 60),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const videoUpload()),
                      );
                    },
                    child: Center(
                      child: Text("UPLOAD VIDEO"),
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
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const videoRecord()),
                      );
                    },
                    child: Center(
                      child: Text("USE VIDEO CAMERA"),
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
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const infoPage()),
                      );
                    },
                    child: Center(
                      child: Text("INFO"),
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(150, 50),
                      textStyle: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      primary: Color.fromARGB(255, 35, 23, 23),
                      onPrimary: Color.fromARGB(255, 158, 144, 144),
                      elevation: 0,
                      shadowColor: Color.fromARGB(255, 66, 39, 39),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class infoPage extends StatelessWidget {
  const infoPage({super.key});
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
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 30, top: 30),
                child: Text(
                  'ABOUT',
                  style: TextStyle(
                    fontFamily: 'Lusteria',
                    color: Color.fromARGB(255, 35, 23, 23),
                    fontSize: 37,
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding:
                      EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                  child: Text(
                      'Cue-Cetera is an application that can be used to detect and classify visual facial cues by the means of Machine Learning. Our goal is to have a social impact by giving access to a learning tool and hence, bringing awareness to related communities.',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        color: Color.fromARGB(255, 222, 215, 215),
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.justify),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 66, 39, 39),
                  )),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 30, top: 20),
                child: Text(
                  'How To Use',
                  style: TextStyle(
                    fontFamily: 'Lusteria',
                    color: Color.fromARGB(255, 35, 23, 23),
                    fontSize: 37,
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding:
                      EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
                  child: Text(
                    '1. Choose between '
                    'Upload Video'
                    ' or '
                    'Use Video Camera'
                    ' option on the homepage. \n2. Choose or take a video that is less that 30s long. \n3. Make sure the faces are clearly visible in the video. \n \n Results may take up to 1 minute to load. Emotions will be catogorized a POSITIVE, NEGATIVE, or NEUTRAL. Clicking on the catogorized results will show you the specific video frame.',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: Color.fromARGB(255, 222, 215, 215),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 121, 111, 111),
                  )),
            ],
          ),
        ),
      ),
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
      backgroundColor: Color(0xffc9b6b9),
      appBar: AppBar(
        backgroundColor: Color(0xff1e133d),
        toolbarHeight: 100,
        title: Center(
          child: Text("CUE-CETERA"),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25.0),
              bottomRight: Radius.circular(25.0)),
        ),
      ),
      body: Container(
          alignment: Alignment.center,
          child: Column(
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
                  child: Text("SELECT"),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 110),
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    primary: Color(0xffc9b6b9),
                    onPrimary: Color(0xff1e133d),
                    elevation: 20,
                    shadowColor: Color(0xff1e133d),
                    shape: StadiumBorder(),
                  )),
            ],
          )),
    );
  }
}

class Test extends StatefulWidget {
  String filePath;
  Test(this.filePath);

  @override
  State<Test> createState() => playVideo(filePath);
}

//class _videoUpload written referrencing code from:
//https://blog.logrocket.com/flutter-video-player/#creating-new-video-player
//https://docs.flutter.dev/cookbook/plugins/play-video
//https://pub.dev/packages/open_file/example
class playVideo extends State<Test> {
  String filePath;

  playVideo(this.filePath);
  VideoPlayerController? _videoPlayerController;
  loadVideoPlayer(File file) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Videos");

    ref.child('paths').push().set({
      "Path": filePath,
    });

    final storage = FirebaseStorage.instance.ref();

    final storRef = storage.child(filePath);

    File file = File(filePath);

    try {
      await storRef.putFile(file);
    } on FirebaseException catch (e) {
      throw Exception('Failed to save video');
    }

    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
    }

    OpenFile.open(filePath!);

    _videoPlayerController = VideoPlayerController.file(file);
    _videoPlayerController!.initialize().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffc9b6b9),
      appBar: AppBar(
        backgroundColor: Color(0xff1e133d),
        toolbarHeight: 100,
        title: Center(
          child: Text("CUE-CETERA"),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25.0),
              bottomRight: Radius.circular(25.0)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff1e133d),
        onPressed: selectVideo,
        child: Icon(
          Icons.play_circle_outline_outlined,
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            if (_videoPlayerController != null) ...[
              AspectRatio(
                aspectRatio: _videoPlayerController!.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController!),
              ),
            ]
          ],
        ),
      ),
    );
  }

  void selectVideo() async {
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

    // loadAsset();

    setState(() {
      File file = File(filePath);
      loadVideoPlayer(file);
    });
  }

  Future<void> loadAsset() async {
    var client = http.Client();
    var uri = Uri.parse("http://10.0.2.2:5000/call_db");
    var response = await client.patch(uri);

    uri = Uri.parse("http://10.0.2.2:5000/pull");
    response = await client.get(uri);

    uri = Uri.parse("http://10.0.2.2:5000/vid_to_img");
    response = await client.get(uri);

    uri = Uri.parse("http://10.0.2.2:5000/predict");
    response = await client.get(uri);
  }
}
