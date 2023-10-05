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
              icon: Icon(Icons.volume_up, color: Color.fromARGB(255, 66, 39, 39)),
              onPressed: () {
                speak(
                    'About. Cue-Cetera is an application that can be used to detect and classify visual facial cues by the means of Machine Learning. Our goal is to have a social impact by giving access to a learning tool and hence, bringing awareness to related communities.'
                        +
                        'How to use. 1. Choose between "Upload Video" or "Use Video Camera" option on the homepage. 2. Choose or take a video that is less than 30 seconds long. 3. Make sure the faces are clearly visible in the video. Results may take up to 1 minute to load. Emotions will be categorized as POSITIVE, NEGATIVE, or NEUTRAL. Clicking on the categorized results will show you the specific video frame.'
                );
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
          color: Color.fromARGB(255, 66, 39, 39),
        ),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'ABOUT',
                  style: TextStyle(
                    fontFamily: 'Lusteria',
                    color: Color.fromARGB(255, 222, 215, 215),
                    fontSize: TextSize28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 212, 195, 195),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Cue-Cetera is an application that can be used to detect and classify visual facial cues by the means of Machine Learning. Our goal is to have a social impact by giving access to a learning tool and hence, bringing awareness to related communities.',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: Color.fromARGB(255, 66, 39, 39),
                      fontSize: TextSize15,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 70),
                Text(
                  'HOW TO USE',
                  style: TextStyle(
                    fontFamily: 'Lusteria',
                    color: Color.fromARGB(255, 222, 215, 215),
                    fontSize: TextSize28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(20),
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
