import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:chewie/chewie.dart';
import 'package:cue_cetera/classes/timestamp.dart';
import 'package:cue_cetera/widgets/timestamp_card.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:cue_cetera/services/screen_size.dart';

class ResultDisplay extends StatefulWidget {
  String filePath;
  ResultDisplay(this.filePath, {Key? key}) : super(key: key);

  @override
  State<ResultDisplay> createState() => _ResultDisplayState(filePath);
}

// TODO: make current timestamp search use binary search algorithm,

class _ResultDisplayState extends State<ResultDisplay> {
  String filePath;
  _ResultDisplayState(this.filePath);

  // there is probably a way to not define these sets twice
  List<int> positiveEmotions = [
    0,
    3,
    5,
    11,
    12,
    13,
    16,
    18,
    19,
    24,
    25
  ];

  List<int> negativeEmotions = [
    1,
    2,
    4,
    6,
    7,
    8,
    9,
    10,
    14,
    15,
    17,
    20,
    21,
    22,
    26
  ];

  // dont actually need this list with current implementation, but makes it clear
  List<int> neutralEmotions = [
    23,
    27
  ];

  // would be best to already get our timestamp info in chronological order
  // if in chronological order, we can use binary search to find our current emotion
  List<Timestamp> timestamps = [
    Timestamp(timeMs: 0, emotion: 0),
    Timestamp(timeMs: 1000, emotion: 1),
    Timestamp(timeMs: 2000, emotion: 3),
    Timestamp(timeMs: 3000, emotion: 5),
    Timestamp(timeMs: 5000, emotion: 23),
    Timestamp(timeMs: 8000, emotion: 2),
    Timestamp(timeMs: 13000, emotion: 4),
    Timestamp(timeMs: 21000, emotion: 27),
    Timestamp(timeMs: 34000, emotion: 25),
    Timestamp(timeMs: 55000, emotion: 8),
  ];

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
      }
      else {
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
      }
      else {
        //currentTime >= timestamps[middle], check if currentTime < timestamps[middle+1]
        if (middle + 1 < timestamps.length) {
          // we are at the last legal index, break
          break; // shouldnt have to change searching to false;
        }
        if (currentTime < timestamps[middle + 1].timeMs!) {
          // we are at the correct index
          break;
        }
        else {
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
    }
    else if (negativeEmotions.contains(emotion)) {
      thumbString = "redThumb";
    }
    else {
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

  @override
  void initState() {
    super.initState();
    videoInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1e133d),
      appBar: AppBar(
        backgroundColor: const Color(0xff3c2087),
        toolbarHeight: 50,
        elevation: 0,
        title: const Center(
            child: Text(
                "CUE-CETERA",
                style: TextStyle(
                    //color: Color(0xffc9b6b9),
                    color: Color(0xffffffff),
                    fontSize: 26,
                    letterSpacing: 2.0,
                    //fontFamily: "Montserrat",
                ),
            ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // using expanded widgets here so our heights will be properly proportioned
        // and in bounds
        children: <Widget> [
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
              children: <Widget> [
                // will show loading symbol if our chewie controller is null for whatever reason
                chewieController != null ? Chewie(controller: chewieController!) : const SpinKitFadingCircle(color: Colors.white, size: 50.0),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: ValueListenableBuilder(
                      valueListenable: videoController!,
                      builder: (context, value, child) {
                        return Image.asset( //will have to make this asset depend on the current emotion
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
            color: Colors.grey[800],
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: timestamps.map((timestamp) => TimestampCard(
                  timestamp: timestamp,
                  jump: jump,
                )).toList(),
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
    );
  }
}