import 'package:flutter/material.dart';
import 'package:cue_cetera/classes/timestamp.dart';

class TimestampCard extends StatelessWidget {

  final Timestamp timestamp;
  final Function jump;

  TimestampCard({required this.timestamp, required this.jump});

  String getEmotion(int emotion) {
    switch(emotion) {
      case 0:
        return "Anger";
      case 1:
        return "Embarrassment";
      case 2:
        return "Fear";
      case 3:
        return "Happiness";
      case 4:
        return "Joy";
      case 5:
        return "Pride";
      case 6:
        return "Sadness";
      case 7:
        return "Frustration"; // replacement for "upset"
      case 8:
        return "Worry";
      default: // we ideally never want to reach this
        print("Invalid emotion value");
        return "Anger";
    }
  }

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
    switch(emotion) {
      case 0:
        //anger
        return 0xffffb3b3;
      case 1:
        // embarrassment
        return 0xffd4ffb3;
      case 2:
        // fear
        return 0xfffcb3ff;
      case 3:
        // happiness
        return 0xfffcffb3;
      case 4:
        // joy
        return 0xffffe3b3;
      case 5:
        // pride
        return 0xffffd1b3;
      case 6:
        // sadness
        return 0xffb3d4ff;
      case 7:
        // frustration (replacement for upset)
        return 0xffb3ffdd;
      case 8:
        // worry
        return 0xffb3e8ff;
      default: // we ideally never want to reach this
        print("Invalid emotion value");
        return 0xffffb3b3; // color for anger
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
