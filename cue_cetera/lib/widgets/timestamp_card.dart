import 'package:flutter/material.dart';
import 'package:cue_cetera/classes/timestamp.dart';

class TimestampCard extends StatelessWidget {

  final Timestamp timestamp;
  final Function jump;

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

  // dont actually need this list with current implementation, but is clear
  List<int> neutralEmotions = [
    23,
    25,
    27
  ];

  TimestampCard({required this.timestamp, required this.jump});

  String getEmotion(int emotion) {
    switch(emotion) {
      case 0:
        return "Affection";
      case 1:
        return "Anger";
      case 2:
        return "Annoyance";
      case 3:
        return "Anticipation";
      case 4:
        return "Aversion";
      case 5:
        return "Confidence";
      case 6:
        return "Disapproval";
      case 7:
        return "Disconnection";
      case 8:
        return "Disquietment";
      case 9:
        return "Doubt/Confusion";
      case 10:
        return "Embarrassment";
      case 11:
        return "Engagement";
      case 12:
        return "Esteem";
      case 13:
        return "Excitement";
      case 14:
        return "Fatigue";
      case 15:
        return "Fear";
      case 16:
        return "Happiness";
      case 17:
        return "Pain";
      case 18:
        return "Peace";
      case 19:
        return "Pleasure";
      case 20:
        return "Sadness";
      case 21:
        return "Sensitivity";
      case 22:
        return "Suffering";
      case 23:
        return "Surprise";
      case 24:
        return "Sympathy";
      case 25:
        return "Yearning";
      case 26:
        return "Disgust";
      case 27:
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
        title: Text(formatTime(timestamp.timeMs!)),
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
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
