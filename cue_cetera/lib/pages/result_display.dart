import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:chewie/chewie.dart';
import 'package:cue_cetera/classes/timestamp.dart';
import 'package:cue_cetera/widgets/timestamp_card.dart';
import 'package:cue_cetera/services/screen_size.dart';

class ResultDisplay extends StatefulWidget {
  const ResultDisplay({Key? key}) : super(key: key);

  @override
  State<ResultDisplay> createState() => _ResultDisplayState();
}

// TODO: make current timestamp search use binary search algorithm,
// TODO: change emotion symbols to just be blue or red thumbs
// TODO: implement a blank emotion that indicates no emotion being displayed
//        basically just means we need a third option with our red and blue thumbs

class _ResultDisplayState extends State<ResultDisplay> {

  // would be best to already get our timestamp info in chronological order
  // if in chronological order, we can use binary search to find our current emotion
  List<Timestamp> timestamps = [
    Timestamp(timeMs: 0, emotion: 5),
    Timestamp(timeMs: 1000, emotion: 1),
    Timestamp(timeMs: 2000, emotion: 8),
    Timestamp(timeMs: 3000, emotion: 0),
    Timestamp(timeMs: 5000, emotion: 4),
    Timestamp(timeMs: 8000, emotion: 3),
    Timestamp(timeMs: 13000, emotion: 7),
    Timestamp(timeMs: 21000, emotion: 2),
    Timestamp(timeMs: 34000, emotion: 6),
  ];

  int currentTimestampIndex = 0;

  // video player code derived from https://www.youtube.com/watch?v=72x6N_fVN4A&ab_channel=AIwithFlutter
  // and https://pub.dev/packages/video_player
  VideoPlayerController? videoController;
  ChewieController? chewieController;

  // Chewie implementation derived from: https://www.youtube.com/watch?v=dvDTmYlJ1b0&ab_channel=eclectifyUniversity-Flutter

  videoInit() async {
    videoController = VideoPlayerController.asset("assets/videos/circuits.mp4");
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

  setCurrentTimestampIndex() {
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

  // EDIT: change and rename this to get thumb path
  String getEmotionImagePath(int emotion) {
    String emotionString = "";
    switch(emotion) {
      case 0:
        emotionString = "anger";
        break;
      case 1:
        emotionString = "embarrassment";
        break;
      case 2:
        emotionString = "fear";
        break;
      case 3:
        emotionString = "happiness";
        break;
      case 4:
        emotionString = "joy";
        break;
      case 5:
        emotionString = "proud";
        break;
      case 6:
        emotionString = "sadness";
        break;
      case 7:
        emotionString = "upset";
        break;
      case 8:
        emotionString = "worry";
        break;
      default: // we ideally never want this to happen
        print("Invalid emotion value");
        emotionString = "anger";
        break;
    }
    return "assets/imgs/emotions/$emotionString.png";
  }

  String updateAndGetEmotionImagePath() {
    setCurrentTimestampIndex();
    //currentTimestampIndex = 0;
    return getEmotionImagePath(timestamps[currentTimestampIndex].emotion!);
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
                          updateAndGetEmotionImagePath(),
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