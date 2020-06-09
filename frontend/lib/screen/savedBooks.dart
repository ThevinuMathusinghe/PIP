import 'package:flutter/material.dart';
import 'package:frontend/bottomNav.dart';
import 'package:frontend/widgets/error.dart';
import 'package:frontend/widgets/loading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SavedBooks extends StatefulWidget {
  @override
  _SavedBooksState createState() => _SavedBooksState();
}

class _SavedBooksState extends State<SavedBooks> {
  String errorMessage = "";
  var books;
  bool loading = true;

  _launchURL(String link) async {
    String url = link;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void savedBooksRequest() async {
    try {
      SharedPreferences myPrefs = await SharedPreferences.getInstance();
      String token = myPrefs.getString('jwt');
      var res = await http.get(
          "https://limitless-meadow-18984.herokuapp.com/user/saved/books",
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
        books = response['savedBooks'];
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
        books = books.where((logo) {
          return logo['_id'] != id;
        });
      });
      // Send the remove request
      SharedPreferences myPrefs = await SharedPreferences.getInstance();
      String token = myPrefs.getString('jwt');
      await http.post(
          "https://limitless-meadow-18984.herokuapp.com/user/saved/book/delete",
          body: {"deleteBookId": id},
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
    savedBooksRequest();
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
                          child: Text("Saved Books",
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
                        books != null && books.length > 0
                            ? Container(
                                height: height -
                                    MediaQuery.of(context).padding.top -
                                    height * .13,
                                child: ListView(children: <Widget>[
                                  ...books.map(
                                    (book) {
                                      return InkWell(
                                        onTap: () {
                                          _launchURL(book['link']);
                                        },
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              width: width * .84,
                                              height: height * .28,
                                              padding: EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Theme.of(context)
                                                          .accentColor,
                                                      Theme.of(context)
                                                          .canvasColor
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
                                                    color: Theme.of(context)
                                                        .accentColor,
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
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                        height: height * 0.3,
                                                        width: width * 0.25,
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 0.2),
                                                        child: Image.network(
                                                          book['image'],
                                                          fit: BoxFit.cover,
                                                        )),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Container(
                                                              width:
                                                                  width * 0.4,
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          10),
                                                              child: Text(
                                                                book['title'],
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              )),
                                                          Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          5),
                                                              child: RichText(
                                                                text:
                                                                    new TextSpan(
                                                                        style:
                                                                            new TextStyle(
                                                                          fontSize:
                                                                              14.0,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                        children: <
                                                                            TextSpan>[
                                                                      new TextSpan(
                                                                          text:
                                                                              "Author: ",
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          )),
                                                                      new TextSpan(
                                                                          text:
                                                                              book['author'])
                                                                    ]),
                                                              )),
                                                          Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          5),
                                                              child: RichText(
                                                                text:
                                                                    new TextSpan(
                                                                        style:
                                                                            new TextStyle(
                                                                          fontSize:
                                                                              14.0,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                        children: <
                                                                            TextSpan>[
                                                                      new TextSpan(
                                                                          text:
                                                                              "Rating: ",
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          )),
                                                                      new TextSpan(
                                                                          text:
                                                                              book['rating'])
                                                                    ]),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                onTap: () {
                                                  removeSaved(book['_id']);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      top: height * 0.065,
                                                      right: width * .09 + 10),
                                                  padding: EdgeInsets.only(
                                                      bottom: 10),
                                                  child: Icon(Icons.bookmark,
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ).toList(),
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
