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
      setState(() {
        loading = true;
      });

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
      setState(() {
        loading = false;
      });
      Navigator.of(context)
          .pushNamed('/fourthLogo', arguments: {'logo': response['logo']});
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
      setState(() {
        loading = true;
      });
      String base64Image = base64Encode(imageFile.readAsBytesSync());
      String fileName = imageFile.path.split("/").last;
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
          loading = false;
          return;
        });
      }
      setState(() {
        loading = false;
      });
      Navigator.of(context)
          .pushNamed('/fourthLogo', arguments: {'logo': response['logo']});
    } catch (err) {
      setState(() {
        errorMessage = err;
      });
    }
  }

  void productCamera() async {
    try {
      var camera = await ImagePicker.pickImage(
        source: ImageSource.camera,
      );
      this.setState(() {
        imageFile = camera;
      });

      if (imageFile == null) return;
      setState(() {
        loading = true;
      });

      String base64Image = base64Encode(imageFile.readAsBytesSync());
      String fileName = imageFile.path.split("/").last;
      List<String> printOut = new List<String>();
      var res = await http.post(
          "https://limitless-meadow-18984.herokuapp.com/book/identify",
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
      setState(() {
        loading = false;
      });
      //print(response);
      Navigator.of(context)
          .pushNamed('/fourthProduct', arguments: {'books': response['books']});
    } catch (err) {
      setState(() {
        errorMessage = err;
      });
    }
  }

  void productGallery() async {
    try {
      var gallery = await ImagePicker.pickImage(
        source: ImageSource.gallery,
      );
      this.setState(() {
        imageFile = gallery;
      });

      if (imageFile == null) return;
      setState(() {
        loading = true;
      });
      String base64Image = base64Encode(imageFile.readAsBytesSync());
      String fileName = imageFile.path.split("/").last;
      var res = await http.post(
          "https://limitless-meadow-18984.herokuapp.com/book/identify",
          body: {
            "image": base64Image,
            "name": fileName,
          });
      var response = await json.decode(res.body);
      if (response['error'] != null) {
        setState(() {
          errorMessage = response['error']['message'];
          loading = false;
          return;
        });
      }
      setState(() {
        loading = false;
      });
      print(response);
      Navigator.of(context)
          .pushNamed('/fourthProduct', arguments: {'books': response['books']});
    } catch (err) {
      setState(() {
        errorMessage = err;
      });
    }
  }

  Future<void> _showChoiceDialog(BuildContext context, bool product) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                "Make a choice",
                textAlign: TextAlign.center,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
              content: SingleChildScrollView(
                  child: ListBody(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: height * 0.001),
                  child: GestureDetector(
                      child: Text(
                        'Gallery',
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        if (product) {
                          productGallery();
                        } else {
                          gallery();
                        }
                      }),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: height * 0.01, top: height * 0.03),
                  child: GestureDetector(
                    child: Text(
                      'Camera',
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      if (product) {
                        productCamera();
                      } else {
                        camera();
                      }
                    },
                  ),
                )
              ])));
        });
  }

  void _onItemTapped(int index) {
    setState(() {
      // _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (loading) {
      return Loading();
    }
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.close),
              title: new Text('Sign Out'),
            )
          ],
          //currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        body: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                    height: height * .15,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                          Theme.of(context).accentColor,
                          Theme.of(context).canvasColor
                        ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: Container(
                      padding: EdgeInsets.only(bottom: height * .02),
                      child: Center(
                          child: Text("Explore",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold))),
                    )),
                Container(
                    margin: EdgeInsets.only(top: height * .13),
                    height: height -
                        MediaQuery.of(context).padding.top -
                        height * .13,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    child: ListView(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: height * .07),
                          child: ErrorMessage(errorMessage: errorMessage),
                        ),
                        InkWell(
                          onTap: () {
                            _showChoiceDialog(context, false);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: width * .08,
                              right: width * .08,
                            ),
                            width: width * .84,
                            height: height * .18,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Theme.of(context).accentColor,
                                      offset: Offset(0, 3),
                                      blurRadius: 6)
                                ],
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).accentColor,
                                      Theme.of(context).canvasColor
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter)),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: width * 0.02, top: height * 0.01),
                                child: Text(
                                  "Logo",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _showChoiceDialog(context, true);
                          },
                          child: Container(
                              margin: EdgeInsets.only(
                                  left: width * .08,
                                  right: width * .08,
                                  top: height * .03,
                                  bottom: height * .03),
                              width: width * .84,
                              height: height * .18,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(.2),
                                        offset: Offset(0, 3),
                                        blurRadius: 6)
                                  ],
                                  border: Border.all(
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: Center(
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: width * 0.02,
                                            top: height * 0.01),
                                        child: Text(
                                          "Product",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .dividerColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      )))),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                              margin: EdgeInsets.only(
                                left: width * .08,
                                right: width * .08,
                              ),
                              width: width * .84,
                              height: height * .19,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Theme.of(context).accentColor,
                                        offset: Offset(0, 3),
                                        blurRadius: 6)
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                      colors: [
                                        Theme.of(context).accentColor,
                                        Theme.of(context).canvasColor
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter)),
                              child: Center(
                                  child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: width * 0.02, top: height * 0.01),
                                  child: Text(
                                    "Saved",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                              ))),
                        ),
                      ],
                    ))
              ],
            )
          ],
        ));
  }
}
