import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:cue_cetera/pages/processing_video.dart';
import 'package:cue_cetera/services/user_settings.dart';
import 'package:cue_cetera/services/firebase_services.dart';



class StreamVideo extends StatefulWidget {
  const StreamVideo({super.key});
  @override
  State<StreamVideo> createState() => _StreamVideoState();
}

//class _videoRecord written using code from: https://bettercoding.dev/flutter/tutorial-video-recording-and-replay/
//code references in class _videoRecord also from:
// https://pub.dev/packages/camera/example
//https://stackoverflow.com/questions/64070044/how-to-record-a-video-with-camera-plugin-in-flutter
class _StreamVideoState extends State<StreamVideo> {
  late CameraController controllers;
  late List<CameraDescription> cameras;
  bool startRecordSetup = true;
  bool frontCamera = true;

  // there is probably a way to not define these sets three times
  List<int> positiveEmotions = [2, 4];

  List<int> negativeEmotions = [0, 1, 3];

  // dont actually need this list with current implementation, but makes it clear
  List<int> neutralEmotions = [5];

  @override
  void initState() {
    cameraSetup();
    super.initState();
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

  String getThumbPath(int emotion) {
    String thumbString = "";
    if (positiveEmotions.contains(emotion)) {
      thumbString = "greenThumb";
      if(UserSettings.colorBlind){
        thumbString = "blueThumb";
      }
    } else if (negativeEmotions.contains(emotion)) {
      thumbString = "redThumb";
    } else {
      thumbString = "neutralThumb";
    }

    // use the three block if/else using three dictionaries
    return "assets/imgs/thumbs/$thumbString.png";
  }

  // Convert emotion index to its string representation
  String emotionFromIndex(int index) {
    List<String> emotions = [
      "Angry",
      "Fearful",
      "Happy",
      "Sad",
      "Surprised",
      "Neutral"
    ];
    return emotions[index];
  }

  @override
  Widget build(BuildContext context) {
    if (startRecordSetup) {
      return Container(
        color: const Color(0xffc9b6b9),
      );
    } else {
      return Stack(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    //will have to make this asset depend on the current emotion
                    // will either be green thumb, red thumb, or no thumb (use a function to return the correct
                    // asset path
                    //"assets/imgs/thumbs/greenThumb.png",
                    getThumbPath(0),
                    scale: 6,
                    // found this trick for image opacity here: https://stackoverflow.com/questions/73490832/change-image-asset-opacity-using-opacity-parameter-in-image-widget
                    opacity: const AlwaysStoppedAnimation(.75),
                  ), // makes it so buttons are center and right
                  const Text("Emotion"),
                  // the camera swap button
                  FloatingActionButton(
                    backgroundColor: const Color(0xffc9b6b9),
                    // disable the button once we've started recording
                    onPressed: () => {
                      switchCamera(),
                    },
                    child: const Icon(Icons.cameraswitch),
                  )
                ]
              ),
              const SizedBox(height: 30),
            ],
          ),
        ],
      );
    }
  }
}