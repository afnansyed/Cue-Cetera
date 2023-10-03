import 'package:flutter/material.dart';
import 'package:cue_cetera/pages/home.dart';
import 'package:cue_cetera/pages/result_display.dart';

class InfoResults extends StatefulWidget {
  const InfoResults({Key? key}) : super(key: key);

  @override
  State<InfoResults> createState() => _InfoRState();
}

class _InfoRState extends State<InfoResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 172, 158, 158),
      appBar: AppBar(
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  ' HOW TO READ RESULTS',
                  style: TextStyle(
                    fontFamily: 'Lusteria',
                    color: Color.fromARGB(255, 134, 109, 109),
                    fontSize: TextSize28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 66, 39, 39),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    ' Emotions will be categorized as POSITIVE, NEGATIVE, or NEUTRAL. Clicking on the categorized results will show you the video at the specific timestamp.',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: Color.fromARGB(255, 222, 215, 215),
                      fontSize: TextSize15,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 66, 39, 39),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
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
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 66, 39, 39),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: <Widget>[
                      Image.asset('assets/imgs/thumbs/greenThumb.png',
                          scale: 6),
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
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 66, 39, 39),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: <Widget>[
                      Image.asset('assets/imgs/thumbs/neutralThumb.png',
                          scale: 6),
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
                ),
                const SizedBox(height: 20),
                Image.asset('assets/imgs/infopage/results_info.png'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
