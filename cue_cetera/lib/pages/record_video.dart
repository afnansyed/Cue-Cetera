import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:cue_cetera/pages/processing_video.dart';
import 'package:cue_cetera/services/firebase_services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



class RecordVideo extends StatefulWidget {
  const RecordVideo({super.key});
  @override
  State<RecordVideo> createState() => _RecordVideoState();
}

//class _videoRecord written using code from: https://bettercoding.dev/flutter/tutorial-video-recording-and-replay/
//code references in class _videoRecord also from:
// https://pub.dev/packages/camera/example
//https://stackoverflow.com/questions/64070044/how-to-record-a-video-with-camera-plugin-in-flutter
class _RecordVideoState extends State<RecordVideo> {
  late CameraController controllers;
  late List<CameraDescription> cameras;
  bool startRecordSetup = true;
  bool runningFirebase = false;
  bool startedRecording = false;
  bool frontCamera = true;


  @override
  void initState() {
    cameraSetup();
    super.initState();
    startedRecording = false;
  }

  cameraSetup() async {
    cameras = await availableCameras();
    controllers = CameraController(cameras[0], ResolutionPreset.max);
    await controllers.initialize();

    setState(() => startRecordSetup = false);
  }

  switchCamera() async {
    if (cameras.length > 1) {
      startRecordSetup = true;
      setState(() {});
      if (frontCamera) {
        controllers = CameraController(cameras[1], ResolutionPreset.max);
        await controllers.initialize();
        frontCamera = false;
      }
      else {
        controllers = CameraController(cameras[0], ResolutionPreset.max);
        await controllers.initialize();
        frontCamera = true;
      }
      setState(() {startRecordSetup = false;});
    }
  }

  recordVideo() async {
    if (!controllers.value.isRecordingVideo) {
      await controllers.startVideoRecording();
    }
    else {
      final file = await controllers.stopVideoRecording();
      if (context.mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProcessingVideo(file.path),
            )
        );
      }
      else {
        print("context not mounted which is bad for some reason");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (startRecordSetup) {
      return Container(
        color: const Color(0xffc9b6b9),
      );
    } else {
      return Center(
        child: Stack(
          children: [
            // the camera preview
            Center(
              child: CameraPreview(controllers),
            ),
            // move our row to the bottom of the screen
            Column(
              children: [
                const Expanded(child: SizedBox()),
                // contains our record and swap camera buttons
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    children: [
                      const Spacer(), // makes it so buttons are center and right
                      // the record button
                      Expanded(
                        // if we've started recording, change button to red
                        child: !startedRecording ? FloatingActionButton(
                          backgroundColor: const Color(0xffc9b6b9),
                          // if the video is recorded, disable the button
                          onPressed: () => {
                            startedRecording = true,
                            setState(() {}),
                            recordVideo(),
                          },
                          child: const Icon(Icons.circle),
                        ) :
                        FloatingActionButton(
                          backgroundColor: const Color(0xffff0000),
                          onPressed: () => {
                            recordVideo(),
                            //startedRecording = false,
                            setState(() {}),
                          },
                          child: const Icon(Icons.circle),
                        ),
                      ),
                      // the camera swap button
                      Expanded(
                        child: (!startedRecording) ? FloatingActionButton(
                          backgroundColor: const Color(0xffc9b6b9),
                          // disable the button once we've started recording
                          onPressed: () => {
                            switchCamera(),
                          },
                          child: const Icon(Icons.cameraswitch),
                        ) :
                        const SizedBox.shrink(),
                      )
                    ]
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}