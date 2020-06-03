import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class logoDisplay extends StatefulWidget {
  @override
  _logoDisplayState createState() => _logoDisplayState();
}

class _logoDisplayState extends State<logoDisplay> {
  var logos;

  void addLogo(String id) async {
    try {
      SharedPreferences myPrefs = await SharedPreferences.getInstance();
      String token = myPrefs.getString('jwt');
      var res = await http.post(
          "https://limitless-meadow-18984.herokuapp.com/user/saved/logo/add",
          body: {"newLogoId": id},
          headers: {"authorization": "Bearer: " + token});
      var response = json.decode(res.body);

      // Change the color of the icon or even change the icon
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    if (routeArgs != null && routeArgs['logo'] != null) {
      logos = routeArgs['logo'];
    }

    return Scaffold(
        body: ListView(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
                height: height * .15,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Theme.of(context).accentColor,
                  Theme.of(context).canvasColor
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: Container(
                  padding: EdgeInsets.only(bottom: height * .02),
                  child: Center(
                      child: Text("Logo",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold))),
                )),
            Container(
                margin: EdgeInsets.only(top: height * .13),
                height:
                    height - MediaQuery.of(context).padding.top - height * .13,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                child: ListView(
                  children: <Widget>[
                    ...logos.map((logo) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('/fifthLogo',
                              arguments: {'logo': logo});
                        },
                        child: Container(
                          width: width * .84,
                          height: height * .18,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).accentColor,
                                  offset: Offset(0, 3),
                                  blurRadius: 6)
                            ],
                            border: Border.all(
                                color: Theme.of(context).accentColor,
                                width: 3.0),
                            borderRadius: BorderRadius.all(Radius.circular(25)),
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
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        logo['title'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  InkWell(
                                    onTap: () {
                                      addLogo(logo['_id']);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Icon(Icons.add),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                  padding: EdgeInsets.only(bottom: 5),
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
                                                fontWeight: FontWeight.bold,
                                              )),
                                          new TextSpan(text: logo['revenue'])
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
                                            fontWeight: FontWeight.bold,
                                          )),
                                      new TextSpan(text: logo['address'])
                                    ]),
                              )),
                            ],
                          )),
                        ),
                      );
                    }).toList()
                  ],
                ))
          ],
        ),
      ],
    ));
  }
}
