import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cue_cetera/pages/info.dart';
import 'package:cue_cetera/pages/settings.dart';
import 'package:cue_cetera/pages/record_video.dart';
import 'package:cue_cetera/pages/processing_video.dart';
import 'package:cue_cetera/services/user_settings.dart';
import 'package:cue_cetera/pages/stream_video.dart';

//MARK-TODO: tts would have to be updated for the new option

class Home extends StatefulWidget {
  final String title;
  const Home(this.title, {Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState(title);
}

class _HomeState extends State<Home> {
  FlutterTts flutterTts = FlutterTts();
  speak(String text) async {
    await flutterTts.speak(text);
  }

  String title;
  _HomeState(this.title);
  bool runningFirebase = false;
  bool videoChosen = false;
  double buttonSpacing = 18;

  openFilePicker() async {
    var picked = await FilePicker.platform.pickFiles();

    if (picked != null) {
      print(picked.files.first.size / (1024 * 1024));
      if (picked.files.first.size / (1024 * 1024) > 50) {
        print('File size cannot exceed 50 MB');
      } else {
        // we open up the processing_video screen instead, and do all of this in initState();
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProcessingVideo(picked.files.first.path!)),
          );
        } else {
          print("context not mounted which is bad for some reason");
        }
      }
    }
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: IconButton(
              icon: const Icon(Icons.volume_up,
                  color: Color.fromARGB(255, 66, 39, 39)),
              onPressed: () {
                speak('Welcome to Cue-Cetera. Cue-Cetera is an application that can be used to detect and classify visual facial cues by the means of Machine Learning. Our goal is to have a social impact by giving access to a learning tool and hence, bringing awareness to related communities.' +
                    'Choose an option below to begin your exploration. Upload video, Use Video Camera, Or Real time camera. For more details, click on the info and settings button.');
              },
              iconSize: 40,
            ),
          )
        ],
        backgroundColor: const Color.fromARGB(255, 172, 158, 158),
        centerTitle: false,
        toolbarHeight: 50,
        elevation: 0,
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Lusteria',
            color: const Color.fromARGB(255, 66, 39, 39),
            fontSize: UserSettings.textSizeLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 66, 39, 39),
        ),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(right: 20, left: 20, bottom: 30),
              alignment: Alignment.center,
              //padding: EdgeInsets.only(top: 80),
              decoration: const BoxDecoration(
                // borderRadius: BorderRadius.vertical(
                // bottom: Radius.circular(50),
                //  ),
                color: Color.fromARGB(255, 172, 158, 158),
              ),
              child: Text(
                ' is an application that can be used to detect and classify visual facial cues by the means of Machine Learning. Our goal is to have a social impact by giving access to a learning tool and hence, bringing awareness to related communities.',
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  color: const Color.fromARGB(255, 66, 39, 39),
                  fontSize: UserSettings.textSizeSmall,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: Color.fromARGB(255, 172, 158, 158), width: 0.5),
                ),
                color: Color.fromARGB(255, 172, 158, 158),
              ),
              child: Container(
                padding: const EdgeInsets.only(top: 30, bottom: 5),
                alignment: Alignment.center,
                //padding: EdgeInsets.only(top: 80),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(50),
                  ),
                  color: Color.fromARGB(255, 66, 39, 39),
                ),
                child: Text('Choose an Option',
                    style: TextStyle(
                      fontFamily: 'Lusteria',
                      color: const Color.fromARGB(255, 212, 195, 195),
                      fontSize: UserSettings.textSizeLarge,
                    ),
                    textAlign: TextAlign.center),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: buttonSpacing,
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        'Your feelings, deciphered.',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: const Color.fromARGB(255, 172, 158, 158),
                          fontSize: UserSettings.textSizeSmall,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: buttonSpacing,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        flutterTts.stop();
                        openFilePicker();
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(250, 70),
                        textStyle: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: UserSettings.textSizeSmall,
                          fontWeight: FontWeight.bold,
                        ),
                        backgroundColor:
                            const Color.fromARGB(255, 212, 195, 195),
                        foregroundColor: const Color.fromARGB(255, 66, 39, 39),
                        elevation: 0,
                        shadowColor: const Color.fromARGB(255, 66, 39, 39),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "UPLOAD VIDEO",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: buttonSpacing,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        flutterTts.stop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RecordVideo()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(250, 70),
                        textStyle: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: UserSettings.textSizeSmall,
                          fontWeight: FontWeight.bold,
                        ),
                        backgroundColor:
                            const Color.fromARGB(255, 212, 195, 195),
                        foregroundColor: const Color.fromARGB(255, 66, 39, 39),
                        elevation: 0,
                        shadowColor: const Color.fromARGB(255, 66, 39, 39),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text("RECORD VIDEO",
                          textAlign: TextAlign.center),
                    ),
                    SizedBox(
                      height: buttonSpacing,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        flutterTts.stop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StreamVideo()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(250, 70),
                        textStyle: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: UserSettings.textSizeSmall,
                          fontWeight: FontWeight.bold,
                        ),
                        backgroundColor:
                            const Color.fromARGB(255, 212, 195, 195),
                        foregroundColor: const Color.fromARGB(255, 66, 39, 39),
                        elevation: 0,
                        shadowColor: const Color.fromARGB(255, 66, 39, 39),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text("REAL TIME CAMERA",
                          textAlign: TextAlign.center),
                    ),
                    SizedBox(
                      height: buttonSpacing,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        flutterTts.stop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Info()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(150, 50),
                        textStyle: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: UserSettings.textSizeSmall,
                          fontWeight: FontWeight.bold,
                        ),
                        backgroundColor: const Color.fromARGB(255, 35, 23, 23),
                        foregroundColor:
                            const Color.fromARGB(255, 158, 144, 144),
                        elevation: 0,
                        shadowColor: const Color.fromARGB(255, 66, 39, 39),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text("INFO"),
                    ),
                    SizedBox(
                      height: buttonSpacing,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        flutterTts.stop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Set()),
                        );
                      },
                      backgroundColor: const Color.fromARGB(255, 35, 23, 23),
                      foregroundColor: const Color.fromARGB(255, 158, 144, 144),
                      child: const Icon(Icons.settings),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
