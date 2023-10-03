import 'package:flutter/material.dart';
import 'package:cue_cetera/pages/home.dart';

class Set extends StatefulWidget {
  const Set({Key? key}) : super(key: key);

  @override
  State<Set> createState() => _SetState();
}

class _SetState extends State<Set> {
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
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(250, 90),
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
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  child: const Text("TEXT-TO-SPEECH"),
                ),
                const SizedBox(height: 10),
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
                            color: Color.fromARGB(255, 66, 39, 39),
                            fontSize: TextSize15,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Slider(
                        value: TextSize15,
                        min: 10.0,
                        max: 70.0,
                        label: TextSize15.round().toString(),
                        activeColor: Color.fromARGB(255, 81, 48, 48),
                        inactiveColor: Color.fromARGB(255, 158, 144, 144),
                        thumbColor: Color.fromARGB(255, 35, 23, 23),
                        onChanged: (double value) {
                          setState(() {
                            TextSize15 = value;
                            TextSize20 = value + 5;
                            TextSize28 = value + 13;
                            TextSize37 = value + 17;
                          });
                        },
                      ),
                      Text(
                        TextSize15.round().toString(),
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: TextSize15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 66, 39, 39),
                        ),
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
