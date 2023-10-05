import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:chewie/chewie.dart';
import 'package:cue_cetera/classes/timestamp.dart';
import 'package:cue_cetera/widgets/timestamp_card.dart';
import 'dart:io';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:cue_cetera/pages/info_results.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ResultDisplay extends StatefulWidget {
  String filePath;
  ResultDisplay(this.filePath, {Key? key}) : super(key: key);

  @override
  State<ResultDisplay> createState() => _ResultDisplayState(filePath);
}

// TODO: make current timestamp search use binary search algorithm,

class _ResultDisplayState extends State<ResultDisplay> {

  FlutterTts flutterTts = FlutterTts();

  speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  String filePath;
  _ResultDisplayState(this.filePath);

  // there is probably a way to not define these sets twice
  List<int> positiveEmotions = [3, 5];

  List<int> negativeEmotions = [0, 1, 2, 4];

  // dont actually need this list with current implementation, but makes it clear
  List<int> neutralEmotions = [6];

  // would be best to already get our timestamp info in chronological order
  // if in chronological order, we can use binary search to find our current emotion
  List<Timestamp> timestamps = [];
  bool timestampsReady = false;
  void populateTimestamps() {
    timestamps.add(Timestamp(timeMs: 0, emotion: 0));
    timestamps.add(Timestamp(timeMs: 1000, emotion: 1));
    timestamps.add(Timestamp(timeMs: 2000, emotion: 2));
    timestamps.add(Timestamp(timeMs: 3000, emotion: 3));
    timestamps.add(Timestamp(timeMs: 5000, emotion: 4));
    timestamps.add(Timestamp(timeMs: 8000, emotion: 5));
    timestamps.add(Timestamp(timeMs: 13000, emotion: 6));
    timestamps.add(Timestamp(timeMs: 34000, emotion: 6));
    timestamps.add(Timestamp(timeMs: 55000, emotion: 3));
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {timestampsReady = true;});
    });
  }

  int currentTimestampIndex = 0;

  // video player code derived from https://www.youtube.com/watch?v=72x6N_fVN4A&ab_channel=AIwithFlutter
  // and https://pub.dev/packages/video_player
  VideoPlayerController? videoController;
  ChewieController? chewieController;

  // Chewie implementation derived from: https://www.youtube.com/watch?v=dvDTmYlJ1b0&ab_channel=eclectifyUniversity-Flutter

  videoInit() async {
    //videoController = VideoPlayerController.asset("assets/videos/circuits.mp4");
    //using the same logic as in "Test(): function in main
    File file = File(filePath);
    videoController = VideoPlayerController.file(file);
    await videoController!.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoController!,
      allowFullScreen: false,
    );

    // we can use the controller.seekTo() method to change our position in the video.
    //videoController!.seekTo(Duration(milliseconds: videoController!.value.position.inMilliseconds + 10000));

    // have to see if theres a way to get the fps of a video file. That way we can use division to advance to certain frames

    setState(() {});
  }

  setCurrentTimestampIndexLinear() {
    // O(N) linear search to find which timestamp we currently lie within
    // assumes the first timestamp will always be at 0 ms
    // ASSUMES LIST IN ASCENDING ORDER!!!
    // should rewrite this algorithm to use a binary search, O(log(n)).
    if (videoController == null) {
      currentTimestampIndex = 0;
      return;
    }
    int currentTime = videoController!.value.position.inMilliseconds;
    int searchIndex = 0;
    while (currentTime > timestamps[searchIndex].timeMs!) {
      if (searchIndex < timestamps.length - 1) {
        if (currentTime < timestamps[searchIndex + 1].timeMs!) {
          break;
        }
        searchIndex++;
      } else {
        break;
      }
    }
    currentTimestampIndex = searchIndex;
    return;
  }

  setCurrentTimestampIndexBinary() {
    // O(N) linear search to find which timestamp we currently lie within
    // assumes the first timestamp will always be at 0 ms
    // ASSUMES LIST IN ASCENDING ORDER!!!
    // should rewrite this algorithm to use a binary search, O(log(n)).
    if (videoController == null) {
      currentTimestampIndex = 0;
      return;
    }
    int currentTime = videoController!.value.position.inMilliseconds;
    int high = timestamps.length - 1;
    int low = 0;
    int middle = timestamps.length ~/ 2;
    // we are at the correct timestamp if currentTime >= timestamps[middle] && < timestamps[middle+1]
    bool searching = true;
    while (searching) {
      if (currentTime < timestamps[middle].timeMs!) {
        // search the lower half of our timestamps for the correct one
        high = middle;
        middle = (high + low) ~/ 2;
      } else {
        //currentTime >= timestamps[middle], check if currentTime < timestamps[middle+1]
        if (middle + 1 < timestamps.length) {
          // we are at the last legal index, break
          break; // shouldnt have to change searching to false;
        }
        if (currentTime < timestamps[middle + 1].timeMs!) {
          // we are at the correct index
          break;
        } else {
          // search the upper half of our timestamps
          low = middle;
          middle = (high + low) ~/ 2;
        }
      }
    }
    currentTimestampIndex = middle;
    return;
  }

  String getThumbPath(int emotion) {
    String thumbString = "";
    if (positiveEmotions.contains(emotion)) {
      thumbString = "blueThumb";
    } else if (negativeEmotions.contains(emotion)) {
      thumbString = "redThumb";
    } else {
      thumbString = "neutralThumb";
    }

    // use the three block if/else using three dictionaries
    return "assets/imgs/thumbs/$thumbString.png";
  }

  String updateAndGetThumbPath() {
    setCurrentTimestampIndexBinary();
    //currentTimestampIndex = 0;
    return getThumbPath(timestamps[currentTimestampIndex].emotion!);
  }

  jump(int time) {
    setState(() {
      videoController!.seekTo(Duration(milliseconds: time));
    });
  }

  Future<void> downloadVideo() async {
    // using https://www.youtube.com/watch?v=FpkJxg34Cng&ab_channel=DavidSerrano as reference
    String? errorMessage;
    File file = File(filePath);
    try {
      final saveFileParams = SaveFileDialogParams(sourceFilePath: filePath);
      final finalPath =
          await FlutterFileDialog.saveFile(params: saveFileParams);
    } catch (e) {
      print("Unexplained error, yipee!");
    }
  }

  @override
  void initState() {
    super.initState();
    videoInit();
    populateTimestamps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAC9E9E),
      appBar: AppBar(

        // TODO: Add a download button to download the video, PREFERABLY with the thumb burned
        backgroundColor: const Color(0xFFAC9E9E),
        toolbarHeight: 75,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "RESULTS",
          style: TextStyle(
            color: Color(0xFF422727),
            fontSize: 20,
            fontFamily: "Lusteria",
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () => speak(
                "You're on the results page. Here, you can view the analysis of your video, access information about the results, download the video to your device, or return to the home screen."
            ),
            color: const Color(0xFF422727),
            iconSize: 40,
          ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InfoResults()),
              )
            },
            color: const Color(0xFF422727),
            iconSize: 40,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => {downloadVideo()},
            color: const Color(0xFF422727),
            iconSize: 40,
          ),
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => {
              // give the user a warning before returning home
              // used these as sources for alert dialog:
              // https://www.youtube.com/watch?v=jyEoMHcjdD4&ab_channel=FlutterMapp ,
              // https://api.flutter.dev/flutter/material/AlertDialog-class.html
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                    "WAIT!",
                    style: TextStyle(
                        //perhaps some stuff here
                        ),
                  ),
                  content: const Text(
                    "Are you sure you want to return home? You will no longer have access to your"
                    " classified video within the app. Make sure you've saved your video if you"
                    " would like to access it on your device later.",
                    style: TextStyle(
                        //perhaps some stuff here
                        ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => {
                        // TODO: remove the loaded video from RAM
                        // return the page to home by popping the rest of the stack
                        Navigator.popUntil(context, (route) => route.isFirst)
                      },
                      child: const Text("Return Home"),
                    ),
                    TextButton(
                      onPressed: () => {
                        // cancel the return home request
                        Navigator.of(context).pop(),
                      },
                      child: const Text("Go Back"),
                    ),
                  ],
                ),
              ),
            },
            color: const Color(0xFF422727),
            iconSize: 40,
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFF422727),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(50),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // using expanded widgets here so our heights will be properly proportioned
          // and in bounds
          children: <Widget>[
            const Expanded(
              flex: 1,
              child: SizedBox(
                width: double.infinity,
                //height: 40.0,
                //height: screenHeight(context) * .05,
              ),
            ),
            Container(
              width: 320.0,
              height: 180.0,
              color: Colors.black,
              child: Stack(
                children: <Widget>[
                  // will show loading symbol if our chewie controller is null for whatever reason
                  chewieController != null
                      ? Chewie(controller: chewieController!)
                      : const SpinKitFadingCircle(
                          color: Colors.white, size: 50.0),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: ValueListenableBuilder(
                        valueListenable: videoController!,
                        builder: (context, value, child) {
                          return Image.asset(
                            //will have to make this asset depend on the current emotion
                            // will either be green thumb, red thumb, or no thumb (use a function to return the correct
                            // asset path
                            //"assets/imgs/thumbs/greenThumb.png",
                            updateAndGetThumbPath(),
                            scale: 6,
                            // found this trick for image opacity here: https://stackoverflow.com/questions/73490832/change-image-asset-opacity-using-opacity-parameter-in-image-widget
                            opacity: const AlwaysStoppedAnimation(.75),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              flex: 1,
              child: SizedBox(
                width: double.infinity,
                //height: 40.0,
                //height: screenHeight(context) * .05,
              ),
            ),
            Container(
              width: 320.0,
              height: 370.0,
              color: const Color(0xFFAC9E9E),
              // our child is either a loading symbol or our timestamps
              child: !timestampsReady
                  ? const SpinKitFadingCircle(
                  color: Colors.white, size: 50.0)
                  :
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: timestamps
                      .map((timestamp) => TimestampCard(
                            timestamp: timestamp,
                            jump: jump,
                          ))
                      .toList(),
                ),
              ),
            ),
            const Expanded(
              flex: 2,
              child: SizedBox(
                width: double.infinity,
                //height: 40.0,
                //height: screenHeight(context) * .05,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
