import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:cue_cetera/pages/result_display.dart';
import 'package:cue_cetera/services/firebase_services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cue_cetera/services/user_settings.dart';

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
  double buttonSpacing = 18;

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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
              fontSize: UserSettings.textSizeMedium,
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
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Processing Video...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Lusteria',
                      color: const Color.fromARGB(255, 212, 195, 195),
                      fontSize: UserSettings.textSizeHuge,
                    ),
                  ),
                ),
                SizedBox(height: buttonSpacing + 12),
                const SpinKitFadingCircle(
                    color: Colors.white,
                    size: 50.0
                ),
                SizedBox(height: buttonSpacing * 2),
                 Text(
                  "Please be patient while we analyze these emotions!",
                  style: TextStyle(
                    color: Color.fromARGB(255, 212, 195, 195),
                    fontFamily: "Lusteria",
                    fontSize: UserSettings.textSizeSmall,
                  ),
                ),
                SizedBox(height: buttonSpacing),
                 Text(
                  "HOW TO READ RESULTS",
                  style: TextStyle(
                    color: Color.fromARGB(255, 212, 195, 195),
                    fontFamily: "Lusteria",
                    fontSize:UserSettings.textSizeMedium,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                 Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Emotions will be categorized as POSITIVE, NEGATIVE, or NEUTRAL. \n Clicking on the categorized results will show you the video at the specific timestamp.",
                    style: TextStyle(
                      color: Color.fromARGB(255, 212, 195, 195),
                      fontFamily: "Lusteria",
                      fontSize: UserSettings.textSizeSmall,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: buttonSpacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/imgs/thumbs/redThumb.png', scale: 6),
                    const SizedBox(width: 10),
                    Text(
                      'Emotion is negative',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        color: const Color.fromARGB(255, 222, 215, 215),
                        fontSize: UserSettings.textSizeSmall,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(UserSettings.colorBlind ? 'assets/imgs/thumbs/blueThumb.png': 'assets/imgs/thumbs/greenThumb.png', scale: 6),
                    const SizedBox(width: 10),
                    Text(
                      'Emotion is positive',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        color: const Color.fromARGB(255, 222, 215, 215),
                        fontSize: UserSettings.textSizeSmall,
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
                        color: const Color.fromARGB(255, 222, 215, 215),
                        fontSize: UserSettings.textSizeSmall,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              color: Color.fromARGB(255, 212, 195, 195),
                              fontFamily: "Lusteria",
                              fontSize: UserSettings.textSizeSmall,
                            ),
                            children: <InlineSpan>[
                              TextSpan(
                                text: "If you want to view this information again, click on ",
                              ),
                              WidgetSpan(
                                child: Icon(
                                  Icons.info,
                                  color: Color.fromARGB(255, 212, 195, 195),
                                  size: 30,
                                ),
                              ),
                              TextSpan(
                                text: " in the results page",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: buttonSpacing),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
