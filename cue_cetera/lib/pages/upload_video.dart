import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:cue_cetera/pages/result_display.dart';
import 'package:cue_cetera/services/firebase_services.dart';
import 'package:cue_cetera/pages/home.dart';

class UploadVideo extends StatefulWidget {
  const UploadVideo({Key? key}) : super(key: key);

  @override
  State<UploadVideo> createState() => _UploadVideoState();
}

//class _videoUpload written referrencing code from:
//https://stackoverflow.com/questions/57869422/how-to-upload-a-video-from-gallery-in-flutter
//https://pub.dev/packages/file_picker
class _UploadVideoState extends State<UploadVideo> {
  FlutterTts flutterTts = FlutterTts();

  speak(String text) async {
    await flutterTts.speak(text);
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
              icon: Icon(Icons.volume_up, color: Color.fromARGB(255, 66, 39, 39)),
              onPressed: () {
                speak(
                    'Click below to upload a video.'
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
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  'Click Below to Upload a Video\n\n\n',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Lusteria',
                    color: Color.fromARGB(255, 212, 195, 195),
                    fontSize: TextSize28,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      var picked = await FilePicker.platform.pickFiles();

                      if (picked != null) {
                        print(picked.files.first.size / (1024 * 1024));
                        if (picked.files.first.size / (1024 * 1024) > 50) {
                          print('File size cannot exceed 50 MB');
                        } else {
                          runFirebase(picked.files.first.path!);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                //builder: (context) =>  Test(picked.files.first.path!)),
                                builder: (context) =>
                                    ResultDisplay(picked.files.first.path!)),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(250, 100),
                      textStyle: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: TextSize15,
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: const Color.fromARGB(255, 212, 195, 195),
                      foregroundColor: const Color.fromARGB(255, 66, 39, 39),
                      elevation: 0,
                      shadowColor: const Color.fromARGB(255, 66, 39, 39),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Center(
                      child: Text("SELECT"),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
