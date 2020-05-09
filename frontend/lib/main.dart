import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> printOut = new List<String>();
  final String nodeEndPoint = 'http://192.168.56.1:3000/image';

  void newTest() async {
    try {
      print ("llllll");
      final File imageFile =
          await ImagePicker.pickImage(source: ImageSource.gallery);
      if (imageFile == null) return;
      String base64Image = base64Encode(imageFile.readAsBytesSync());
      String fileName = imageFile.path.split("/").last;

      http.post(nodeEndPoint, body: {
        "image": base64Image,
        "name": fileName,
      }).then((res) async {
        var test = await json.decode(res.body);
        print(test['logos']);
        setState(() {
          printOut = test['logos']
              .map((logo) {
                return logo;
              })
              .toList()
              .cast<String>();
        });
      }).catchError((err) {
        print(err);
      });
    } catch (err) {
      print(err);
    }
  }

  void test() async {
    printOut = new List<String>();
    final File imageFile =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);
    final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
    final List<ImageLabel> labels = await labeler.processImage(visionImage);
    for (ImageLabel label in labels) {
      final String text = label.text;
      final String entityId = label.entityId;
      final double confidence = label.confidence;
      print(entityId);
      setState(() {
        printOut.add(text);
      });
    }

    labeler.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ...printOut.map((text) {
              return Text(text);
            }).toList()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: newTest,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}