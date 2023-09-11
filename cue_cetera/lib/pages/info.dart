import 'package:flutter/material.dart';

class Info extends StatefulWidget {
  const Info({Key? key}) : super(key: key);

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 172, 158, 158),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 172, 158, 158),
        centerTitle: true,
        toolbarHeight: 100,
        elevation: 0,
        title: const Text(
          'CUE-CETERA',
          style: TextStyle(
            fontFamily: 'Lusteria',
            color: Color.fromARGB(255, 66, 39, 39),
            fontSize: 20,
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
                const Text(
                  'ABOUT',
                  style: TextStyle(
                    fontFamily: 'Lusteria',
                    color: Color.fromARGB(255, 222, 215, 215),
                    fontSize: 28,
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
                  child: const Text(
                    'Cue-Cetera is an application that can be used to detect and classify visual facial cues by the means of Machine Learning. Our goal is to have a social impact by giving access to a learning tool and hence, bringing awareness to related communities.',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: Color.fromARGB(255, 66, 39, 39),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 70),
                const Text(
                  'HOW TO USE',
                  style: TextStyle(
                    fontFamily: 'Lusteria',
                    color: Color.fromARGB(255, 222, 215, 215),
                    fontSize: 28,
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
                  child: const Text(
                    '1. Choose between "Upload Video" or "Use Video Camera" option on the homepage. \n'
                        '2. Choose or take a video that is less than 30 seconds long. \n'
                        '3. Make sure the faces are clearly visible in the video. \n\n'
                        'Results may take up to 1 minute to load. Emotions will be categorized as POSITIVE, NEGATIVE, or NEUTRAL. Clicking on the categorized results will show you the specific video frame.',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: Color.fromARGB(255, 66, 39, 39),
                      fontSize: 16,
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
