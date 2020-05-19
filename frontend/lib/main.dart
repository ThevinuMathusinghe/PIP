import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:frontend/screen/login.dart';
import 'package:frontend/screen/register.dart';
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
          primarySwatch: Colors.blue,
        ),
        routes: {'/': (ctx) => Register(), '/login': (ctx) => Login()});
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({this.title});
//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   List<String> printOut = new List<String>();
//   final String nodeEndPoint =
//       'https://limitless-meadow-18984.herokuapp.com/logo/identify';

//   void newTest() async {
//     try {
//       final File imageFile =
//           await ImagePicker.pickImage(source: ImageSource.gallery);
//       if (imageFile == null) return;
//       String base64Image = base64Encode(imageFile.readAsBytesSync());
//       String fileName = imageFile.path.split("/").last;

//       http.post(nodeEndPoint, body: {
//         "image": base64Image,
//         "name": fileName,
//       }).then((res) async {
//         var test = await json.decode(res.body);
//         print(test['logos']);
//         setState(() {
//           printOut = test['logos']
//               .map((logo) {
//                 return logo;
//               })
//               .toList()
//               .cast<String>();
//         });
//       }).catchError((err) {
//         print(err);
//       });
//     } catch (err) {
//       print(err);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ...printOut.map((text) {
//               return Text(text);
//             }).toList()
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: newTest,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
