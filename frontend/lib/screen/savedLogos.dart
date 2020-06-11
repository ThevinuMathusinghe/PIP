import 'package:flutter/material.dart';
import 'package:frontend/bottomNav.dart';
import 'package:frontend/widgets/error.dart';
import 'package:frontend/widgets/loading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SavedLogos extends StatefulWidget {
  @override
  _SavedLogosState createState() => _SavedLogosState();
}

class _SavedLogosState extends State<SavedLogos> {
  String errorMessage = "";
  var logos;
  bool loading = true;

  void savedLogoRequest() async {
    try {
      SharedPreferences myPrefs = await SharedPreferences.getInstance();
      String token = myPrefs.getString('jwt');
      var res = await http.get(
          "https://limitless-meadow-18984.herokuapp.com/user/saved/logos",
          headers: {"authorization": "Bearer: " + token});
      var response = json.decode(res.body);
      print(response);
      if (response['error'] != null) {
        setState(() {
          loading = false;
          errorMessage = response['error']['message'];
        });
        return;
      }

      setState(() {
        logos = response['savedLogos'];
        errorMessage = "";
        loading = false;
      });
    } catch (err) {
      setState(() {
        errorMessage = err.toString();
      });
    }
  }

  void removeSaved(String id) async {
    try {
      setState(() {
        logos = logos.where((logo) {
          return logo['_id'] != id;
        });
      });
      // Send the remove request
      SharedPreferences myPrefs = await SharedPreferences.getInstance();
      String token = myPrefs.getString('jwt');
      await http.post(
          "https://limitless-meadow-18984.herokuapp.com/user/saved/logo/delete",
          body: {"deleteLogoId": id},
          headers: {"authorization": "Bearer: " + token});
    } catch (err) {
      setState(() {
        errorMessage = err.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    savedLogoRequest();
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
                          child: Text("Saved Logos",
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
                          child: ErrorMessage(errorMessage: errorMessage),
                        ),
                        logos != null && logos.length > 0
                            ? Container(
                                height: height -
                                    MediaQuery.of(context).padding.top -
                                    height * .13,
                                child: ListView(children: <Widget>[
                                  ...logos.map((logo) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            '/fifthLogo',
                                            arguments: {'logo': logo});
                                      },
                                      child: Container(
                                        width: width * .84,
                                        height: height * .18,
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: [
                                                Theme.of(context).accentColor,
                                                Theme.of(context).canvasColor
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                offset: Offset(0, 3),
                                                blurRadius: 6)
                                          ],
                                          border: Border.all(
                                              color:
                                                  Theme.of(context).accentColor,
                                              width: 3.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                        ),
                                        margin: EdgeInsets.only(
                                          top: height * 0.05,
                                          left: width * .08,
                                          right: width * .08,
                                        ),
                                        child: Container(
                                            child: ListView(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: 10),
                                                    child: Text(
                                                      logo['title'],
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )),
                                                InkWell(
                                                  onTap: () {
                                                    removeSaved(logo['_id']);
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: 10),
                                                    child: Icon(Icons.bookmark,
                                                        color: Colors.red),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Container(
                                                padding:
                                                    EdgeInsets.only(bottom: 5),
                                                child: RichText(
                                                  text: new TextSpan(
                                                      style: new TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.black,
                                                      ),
                                                      children: <TextSpan>[
                                                        new TextSpan(
                                                            text: "Revenue: ",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            )),
                                                        new TextSpan(
                                                            text:
                                                                logo['revenue'])
                                                      ]),
                                                )),
                                            Container(
                                                child: RichText(
                                              text: new TextSpan(
                                                  style: new TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.black,
                                                  ),
                                                  children: <TextSpan>[
                                                    new TextSpan(
                                                        text: "Address: ",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                    new TextSpan(
                                                        text: logo['address'])
                                                  ]),
                                            )),
                                          ],
                                        )),
                                      ),
                                    );
                                  }).toList()
                                ]))
                            : Container()
                      ],
                    ))
              ],
            )
          ],
        ));
  }
}
