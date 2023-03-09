import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CUE-CETERA',
      theme: ThemeData(
        primaryColor: Color(0xff1e133d),
      ),
      home: MyHomePage(title: 'CUE-CETERA'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffc9b6b9),
      appBar: AppBar(
        backgroundColor: Color(0xff1e133d),
        toolbarHeight: 100,
        title: Center(
          child: Text(title),
        ),
      ),
      body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {},
                  child: Text("UPLOAD VIDEO"),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 110),
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    primary: Color(0xffc9b6b9),
                    onPrimary: Color(0xff1e133d),
                    elevation: 20,
                    shadowColor: Color(0xff1e133d),
                    shape: StadiumBorder(),
                  )),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const videoRecord()),
                    );
                  },
                  child: Text("USE VIDEO CAMERA"),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 110),
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    primary: Color(0xffc9b6b9),
                    onPrimary: Color(0xff1e133d),
                    elevation: 20,
                    shadowColor: Color(0xff1e133d),
                    shape: StadiumBorder(),
                  )),
            ],
          )),
    );
  }
}

class videoRecord extends StatelessWidget {
  const videoRecord({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffc9b6b9),
      appBar: AppBar(
        backgroundColor: Color(0xff1e133d),
        toolbarHeight: 100,
        title: Center(
          child: Text("CUE-CETERA"),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25.0),
              bottomRight: Radius.circular(25.0)),
        ),
      ),
      body: Container(),
    );
  }
}
