import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:frontend/widgets/error.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/widgets/loading.dart';

class Explore extends StatefulWidget {
  @override
  _explore createState() => _explore();
}

class _explore extends State<Explore> {
  File imageFile;
  bool loading = false;
  String errorMessage = "";

  void camera() async {
    try {
      var camera = await ImagePicker.pickImage(
        source: ImageSource.camera,
      );
      this.setState(() {
        imageFile = camera;
      });

      if (imageFile == null) return;
      String base64Image = base64Encode(imageFile.readAsBytesSync());
      String fileName = imageFile.path.split("/").last;
      List<String> printOut = new List<String>();
      var res = await http.post(
          "https://limitless-meadow-18984.herokuapp.com/logo/identify",
          body: {
            "image": base64Image,
            "name": fileName,
          });
      var response = await json.decode(res.body);
      if (response['error'] != null) {
        setState(() {
          errorMessage = response['error']['message'];
        });
      }
      print(response);
    } catch (err) {
      setState(() {
        errorMessage = err;
      });
    }
  }

  void gallery() async {
    try {
      var gallery = await ImagePicker.pickImage(
        source: ImageSource.gallery,
      );
      this.setState(() {
        imageFile = gallery;
      });

      if (imageFile == null) return;
      String base64Image = base64Encode(imageFile.readAsBytesSync());
      String fileName = imageFile.path.split("/").last;
      List<String> printOut = new List<String>();
      var res = await http.post(
          "https://limitless-meadow-18984.herokuapp.com/logo/identify",
          body: {
            "image": base64Image,
            "name": fileName,
          });
      var response = await json.decode(res.body);
      if (response['error'] != null) {
        setState(() {
          errorMessage = response['error']['message'];
        });
      }
      print(response);
    } catch (err) {
      setState(() {
        errorMessage = err;
      });
    }
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Make a choice"),
              content: SingleChildScrollView(
                  child: ListBody(children: <Widget>[
                GestureDetector(
                    child: Text('Gallery'),
                    onTap: () {
                      gallery();
                    }),
                GestureDetector(
                  child: Text('Camera'),
                  onTap: () {
                    camera();
                  },
                )
              ])));
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double exploreHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: new Container(
            padding: EdgeInsets.only(top: exploreHeight * 0.2),
            color: Colors.blueAccent,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //Container(height: MediaQuery.of(context).padding.top),
                new Column(children: <Widget>[
                  ErrorMessage(errorMessage: errorMessage),
                  ButtonTheme(
                    minWidth: width * 0.85,
                    height: exploreHeight * 0.20,
                    child: Container(
                      height: exploreHeight * .2,
                      padding: EdgeInsets.only(
                          right: width * 0.05, left: width * .05),
                      child: RaisedButton(
                        onPressed: () {
                          _showChoiceDialog(context);
                        },
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Logo',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                  ButtonTheme(
                    minWidth: width * 0.85,
                    height: exploreHeight * 0.20,
                    child: Padding(
                      padding: EdgeInsets.all(width * 0.05),
                      child: RaisedButton(
                        onPressed: () {
                          _showChoiceDialog(context);
                        },
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Product',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  )
                ])
              ],
            )));
  }
}
