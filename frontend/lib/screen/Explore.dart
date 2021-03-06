import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/bottomNav.dart';
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
      SharedPreferences myPrefs = await SharedPreferences.getInstance();
      String token = myPrefs.getString('jwt');
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
      // Make request to get all the books /user/saved/books (get)
      var savedRes = await http.get(
          "https://limitless-meadow-18984.herokuapp.com/user/saved/logos",
          headers: {"authorization": "Bearer: " + token});
      var responseSaved = await json.decode(savedRes.body);
      if (responseSaved['error'] != null) {
        setState(() {
          errorMessage = responseSaved['error']['message'];
          loading = false;
          return;
        });
      }
      //Read the response etc, handle errors
      //add saved field on relavent books
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
      for (int i = 0; i < response['logo'].length; i++) {
        responseSaved['savedLogos'].forEach((logo) {
          if (response['logo'][i]['_id'] == logo['_id']) {
            response['logo'][i]['saved'] = true;
          }
        });
      }
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
      SharedPreferences myPrefs = await SharedPreferences.getInstance();
      String token = myPrefs.getString('jwt');
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
      var savedRes = await http.get(
          "https://limitless-meadow-18984.herokuapp.com/user/saved/books",
          headers: {"authorization": "Bearer: " + token});
      var responseSaved = await json.decode(savedRes.body);
      if (responseSaved['error'] != null) {
        setState(() {
          errorMessage = responseSaved['error']['message'];
          loading = false;
          return;
        });
      }
      var response = await json.decode(res.body);
      if (response['error'] != null) {
        setState(() {
          errorMessage = response['error']['message'];
        });
      }
      setState(() {
        loading = false;
      });
      for (int i = 0; i < response['books'].length; i++) {
        responseSaved['savedBooks'].forEach((book) {
          if (response['books'][i]['_id'] == book['_id']) {
            response['books'][i]['saved'] = true;
          }
        });
      }
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
      SharedPreferences myPrefs = await SharedPreferences.getInstance();
      String token = myPrefs.getString('jwt');
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
      var savedRes = await http.get(
          "https://limitless-meadow-18984.herokuapp.com/user/saved/books",
          headers: {"authorization": "Bearer: " + token});
      var responseSaved = await json.decode(savedRes.body);
      if (responseSaved['error'] != null) {
        setState(() {
          errorMessage = responseSaved['error']['message'];
          loading = false;
          return;
        });
      }
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
      for (int i = 0; i < response['books'].length; i++) {
        responseSaved['savedBooks'].forEach((book) {
          if (response['books'][i]['_id'] == book['_id']) {
            response['books'][i]['saved'] = true;
          }
        });
      }
      //print(response);
      Navigator.of(context)
          .pushNamed('/fourthProduct', arguments: {'books': response['books']});
    } catch (err) {
      setState(() {
        errorMessage = err;
      });
    }
  }

  Future<void> _showChoiceDialog(BuildContext context, bool product) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          double width = MediaQuery.of(context).size.width;
          double height = MediaQuery.of(context).size.height;
          return Scaffold(
              backgroundColor: Colors.black.withOpacity(.2),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: width * .5,
                      height: height * .2,
                      margin: EdgeInsets.only(
                          left: width * .25, right: width * .25),
                      padding: EdgeInsets.only(
                          top: height * .05, bottom: height * .05),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              child: Text(
                            "Make A Choice",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          )),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              if (product) {
                                productGallery();
                              } else {
                                gallery();
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Text(
                                    'Gallery',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(child: Icon(Icons.camera, size: 20))
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              if (product) {
                                productCamera();
                              } else {
                                camera();
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Text(
                                    'Camera',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                    child: Icon(Icons.camera_alt, size: 20))
                              ],
                            ),
                          )
                        ],
                      ))
                ],
              ));
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
        bottomNavigationBar: BottomNav(),
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
                              alignment: Alignment.center,
                              child: Container(
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
                                      alignment: Alignment.center,
                                      child: Container(
                                        child: Text(
                                          "Books",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .dividerColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      )))),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed('/savedLogos');
                              },
                              child: Container(
                                  margin: EdgeInsets.only(
                                    left: width * .08,
                                  ),
                                  width: width * .38,
                                  height: height * .19,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Theme.of(context).accentColor,
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
                                    alignment: Alignment.center,
                                    child: Container(
                                      child: Text(
                                        "Saved Logos",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ))),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed('/savedBooks');
                              },
                              child: Container(
                                  margin: EdgeInsets.only(
                                    right: width * .08,
                                  ),
                                  width: width * .38,
                                  height: height * .19,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Theme.of(context).accentColor,
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
                                    alignment: Alignment.center,
                                    child: Container(
                                      child: Text(
                                        "Saved Books",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ))),
                            ),
                          ],
                        ),
                      ],
                    ))
              ],
            )
          ],
        ));
  }
}
