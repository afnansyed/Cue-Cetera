import 'package:flutter/material.dart';
import 'package:cue_cetera/pages/home.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Info extends StatefulWidget {
  const Info({Key? key}) : super(key: key);

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  FlutterTts flutterTts = FlutterTts();
  speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 172, 158, 158),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: IconButton(
              icon:
                  Icon(Icons.volume_up, color: Color.fromARGB(255, 66, 39, 39)),
              onPressed: () {
                speak(
                    'How to use. 1. Choose between "Upload Video" or "Use Video Camera" option on the homepage. 2. Choose or take a video that is less than 30 seconds long. 3. Make sure the faces are clearly visible in the video. Results may take up to 1 minute to load. Emotions will be categorized as POSITIVE, NEGATIVE, or NEUTRAL. Clicking on the categorized results will show you the specific video frame.');
              },
              iconSize: 40,
            ),
          )
        ],
        backgroundColor: const Color.fromARGB(255, 172, 158, 158),
        centerTitle: true,
        toolbarHeight: 100,
        elevation: 0,
        title: Text(
          'CUE-CETERA',
          style: TextStyle(
            fontFamily: 'Lusteria',
            color: Color.fromARGB(255, 66, 39, 39),
            fontSize: TextSize20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(50),
          ),
          color: Color.fromRGBO(66, 39, 39, 1),
        ),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Text(
                  '- how to use -',
                  style: TextStyle(
                    fontFamily: 'Lusteria',
                    color: Color.fromARGB(255, 222, 215, 215),
                    fontSize: TextSize20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 212, 195, 195),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '1. Choose between "Upload Video" or "Use Video Camera" option on the homepage. \n'
                    '2. Choose or take a video that is less than 30 seconds long. \n'
                    '3. Make sure the faces are clearly visible in the video. \n\n'
                    'Results may take up to 1 minute to load. Emotions will be categorized as POSITIVE, NEGATIVE, or NEUTRAL. Clicking on the categorized results will show you the specific video frame.',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: Color.fromARGB(255, 66, 39, 39),
                      fontSize: TextSize15,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
