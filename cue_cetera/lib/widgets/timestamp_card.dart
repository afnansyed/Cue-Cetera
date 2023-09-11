import 'package:flutter/material.dart';
import 'package:cue_cetera/classes/timestamp.dart';

class TimestampCard extends StatelessWidget {

  final Timestamp timestamp;
  final Function jump;

  // there is probably a way to not define these sets twice
  List<int> positiveEmotions = [
    3,
    5
  ];

  List<int> negativeEmotions = [
    0,
    1,
    2,
    4
  ];

  // dont actually need this list with current implementation, but makes it clear
  List<int> neutralEmotions = [
    6
  ];

  TimestampCard({required this.timestamp, required this.jump});

  String getEmotion(int emotion) {
    switch(emotion) {
      case 0:
        return "Disapproving";
      case 1:
        return "Angry";
      case 2:
        return "Fearful";
      case 3:
        return "Happy";
      case 4:
        return "Sad";
      case 5:
        return "Surprised";
      case 6:
        return "Neutral";
      default: // we ideally never want this to happen
        print("Invalid emotion value");
        return "Neutral";
    }
  }

  // there is probably a way to not have to write this function twice
  String getEmotionImagePath(int emotion) {
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

  String formatTime(int timeMs) {
    // we have our time in milliseconds, but we want to translate this to XX:XX
    // first the first XX is minutes and the second XX is seconds. First we find
    // seconds. we can use integer division, this is only for display
    int totalSeconds = timeMs ~/ 1000; // the tilde is used for integer division in dart:
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    String minutesString = minutes < 10 ? "0$minutes" : "$minutes";
    String secondsString = seconds < 10 ? "0$seconds" : "$seconds";
    return "$minutesString:$secondsString";
  }

  int getBackgroundColor(int emotion) {

    if (positiveEmotions.contains(emotion)) {
      return 0xffb3d4ff; // blue
    }
    else if (negativeEmotions.contains(emotion)) {
      return 0xffffb3b3; // red
    }
    else {
      return 0xff808080; // gray
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => jump(timestamp.timeMs),
        //title: Text("${timestamp.timeMs}"),
        title: Text(
          formatTime(timestamp.timeMs!),
          style: const TextStyle(
            //fontWeight: FontWeight.bold,
            fontFamily: "Lusteria",
          ),
        ),
        tileColor: Color(getBackgroundColor(timestamp.emotion!)),
        visualDensity: const VisualDensity(vertical: 4),
        leading: CircleAvatar(
          backgroundImage: AssetImage(getEmotionImagePath(timestamp.emotion!)),
          backgroundColor: Color(getBackgroundColor(timestamp.emotion!)),
          radius: 25,
        ),
        trailing: Text(
          getEmotion(timestamp.emotion!),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "Lusteria",
            //letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
