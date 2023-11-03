import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:cue_cetera/pages/result_display.dart';
import 'package:cue_cetera/services/firebase_services.dart';
import 'package:cue_cetera/pages/home.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProcessingVideo extends StatefulWidget {
  final String filePath;
  const ProcessingVideo(this.filePath, {Key? key}) : super(key: key);

  @override
  State<ProcessingVideo> createState() => _ProcessingVideoState(filePath);
}

//class _videoUpload written referrencing code from:
//https://stackoverflow.com/questions/57869422/how-to-upload-a-video-from-gallery-in-flutter
//https://pub.dev/packages/file_picker
class _ProcessingVideoState extends State<ProcessingVideo> {

  FlutterTts flutterTts = FlutterTts();

  String filePath;
  _ProcessingVideoState(this.filePath);

  speak(String text) async {
    await flutterTts.speak(text);
  }

  void processVideo() async {
    setState(() {});
    var output = await runFirebase(filePath);
    setState(() {});
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ResultDisplay(filePath, output)),
      );
    }
    else {
      print("context not mounted which is bad for some reason");
    }
  }

  // need a init function that runs the file picker
  @override
  void initState() {
    super.initState();
    processVideo();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 172, 158, 158),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 172, 158, 158),
        centerTitle: true,
        toolbarHeight: 100,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'CUE-CETERA',
          style: TextStyle(
            fontFamily: 'Lusteria',
            color: const Color.fromARGB(255, 66, 39, 39),
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
        child: Column(
          children: [
            const Expanded(
              flex: 1,
              child: SizedBox(width: double.infinity),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 50),
              child: Text(
                'Processing Video...\n\n\n',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Lusteria',
                  color: const Color.fromARGB(255, 212, 195, 195),
                  fontSize: TextSize28,
                ),
              ),
            ),
            const SpinKitFadingCircle(
                color: Colors.white,
                size: 50.0
            ),
            const Expanded(
              flex: 2,
              child: SizedBox(width: double.infinity),
            ),
            const Text(
              "Please be patient while we analyze these emotions!",
              style: TextStyle(
                color: Color.fromARGB(255, 212, 195, 195),
                fontFamily: "Lusteria",
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "HOW TO READ RESULTS",
              style: TextStyle(
                color: Color.fromARGB(255, 212, 195, 195),
                fontFamily: "Lusteria",
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Emotions will be categorized as POSITIVE, NEGATIVE, or NEUTRAL. \n Clicking on the categorized results will show you the video at the specific timestamp.",
                style: TextStyle(
                  color: Color.fromARGB(255, 212, 195, 195),
                  fontFamily: "Lusteria",
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/imgs/thumbs/redThumb.png', scale: 6),
                const SizedBox(width: 10),
                Text(
                  'Emotion is negative',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    color: Color.fromARGB(255, 222, 215, 215),
                    fontSize: TextSize15,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(colorBlind ? 'assets/imgs/thumbs/blueThumb.png': 'assets/imgs/thumbs/greenThumb.png', scale: 6),
                const SizedBox(width: 10),
                Text(
                  'Emotion is positive',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    color: Color.fromARGB(255, 222, 215, 215),
                    fontSize: TextSize15,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/imgs/thumbs/neutralThumb.png', scale: 6),
                const SizedBox(width: 10),
                Text(
                  'Emotion is neutral',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    color: Color.fromARGB(255, 222, 215, 215),
                    fontSize: TextSize15,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
            const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "If you want to view this information again, click on",
              style: TextStyle(
                color: Color.fromARGB(255, 212, 195, 195),
                fontFamily: "Lusteria",
                fontSize: 10,
              ),
            ),
            Icon(
              Icons.info,
              color: const Color.fromARGB(255, 212, 195, 195),
              size: 30,
            ),
            const Text(
              "in the results page",
              style: TextStyle(
                color: Color.fromARGB(255, 212, 195, 195),
                fontFamily: "Lusteria",
                fontSize: 10,
              ),
            ),
          ],
        ),
            const Expanded(
              flex: 2,
              child: SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}
