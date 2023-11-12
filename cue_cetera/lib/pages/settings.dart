import 'package:flutter/material.dart';
import 'package:cue_cetera/pages/home.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:cue_cetera/services/user_settings.dart';

class Set extends StatefulWidget {
  const Set({Key? key}) : super(key: key);

  @override
  State<Set> createState() => _SetState();
}

class _SetState extends State<Set> {
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const Home('CUE-CETERA'),
              ),
              (route) => false,
            ),
          },
          color: const Color.fromARGB(255, 242, 228, 228),
          iconSize: 40,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: IconButton(
              icon:
                  const Icon(Icons.volume_up, color: Color.fromARGB(255, 66, 39, 39)),
              onPressed: () {
                speak(
                    'You are on the settings page. Text-to-speech option: Tap on the speaker icon at the top of each page to enable Text-to-Speech. Change Text Size option: adjust the text size for better readability. Colorblind mode: Enable this to adjust the color scheme making it more accessible for those with red-green color blindness');
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
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '- settings -',
                  style: TextStyle(
                    fontFamily: 'Lusteria',
                    color: const Color.fromARGB(255, 210, 188, 188),
                    fontSize: UserSettings.textSizeMedium,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 250,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 212, 195, 195),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "TEXT-TO-SPEECH",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: UserSettings.textSizeSmall,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 66, 39, 39),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.volume_up,
                              color: Color.fromARGB(255, 66, 39, 39)),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              'Tap on the speaker icon at the top of each page to enable Text-to-Speech.',
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                color: const Color.fromARGB(255, 66, 39, 39),
                                fontSize: UserSettings.textSizeSmall - 3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 250,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 212, 195, 195),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'CHANGE TEXT SIZE',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            color: const Color.fromARGB(255, 66, 39, 39),
                            fontSize: UserSettings.textSizeSmall,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Slider(
                        value: UserSettings.textSizeSmall,
                        min: 10.0,
                        max: 23.0,
                        label: UserSettings.textSizeSmall.round().toString(),
                        activeColor: const Color.fromARGB(255, 81, 48, 48),
                        inactiveColor: const Color.fromARGB(255, 158, 144, 144),
                        thumbColor: const Color.fromARGB(255, 35, 23, 23),
                        onChanged: (double value) {
                          setState(() {
                            UserSettings.textSizeSmall = value;
                            UserSettings.textSizeMedium = value + 5;
                            UserSettings.textSizeLarge = value + 13;
                            UserSettings.textSizeHuge = value + 17;
                          });
                        },
                      ),
                      Text(
                        UserSettings.textSizeSmall.round().toString(),
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: UserSettings.textSizeSmall,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 66, 39, 39),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 250,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 212, 195, 195),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'COLOR BLIND MODE',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            color: const Color.fromARGB(255, 66, 39, 39),
                            fontSize: UserSettings.textSizeSmall,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Switch(
                        activeColor: const Color.fromARGB(255, 35, 23, 23),
                        inactiveThumbColor: const Color.fromARGB(255, 158, 144, 144),
                        value: UserSettings.colorBlind,
                        onChanged: (bool value) {
                          setState(() {
                            UserSettings.colorBlind = value;
                          });
                        },
                      ),
                    ],
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
