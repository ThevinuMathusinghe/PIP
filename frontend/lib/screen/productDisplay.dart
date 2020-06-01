import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDisplay extends StatefulWidget {
  @override
  _ProductDisplayState createState() => _ProductDisplayState();
}

class _ProductDisplayState extends State<ProductDisplay> {
  var products;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    if (routeArgs != null && routeArgs['books'] != null) {
      products = routeArgs['books'];
    }

    _launchURL(String link) async {
      String url = link;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
        body: ListView(
      children: <Widget>[
        Stack(children: <Widget>[
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
                    child: Text("Product",
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
              child: ListView(children: <Widget>[
                ...products.map(
                  (book) {
                    return InkWell(
                      onTap: () {
                        _launchURL(book['link']);
                      },
                      child: Container(
                        width: width * .84,
                        height: height * .28,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context).accentColor,
                                offset: Offset(0, 3),
                                blurRadius: 6)
                          ],
                          border: Border.all(
                              color: Theme.of(context).accentColor, width: 3.0),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        margin: EdgeInsets.only(
                          top: height * 0.05,
                          left: width * .08,
                          right: width * .08,
                        ),
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  height: height * 0.3,
                                  width: width * 0.25,
                                  padding: EdgeInsets.only(bottom: 0.2),
                                  child: Image.network(
                                    book['image'],
                                    fit: BoxFit.cover,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        width: width * 0.4,
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          book['title'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
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
                                                    text: "Author: ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                                new TextSpan(
                                                    text: book['author'])
                                              ]),
                                        )),
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
                                                    text: "Rating: ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                                new TextSpan(
                                                    text: book['rating'])
                                              ]),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ]))
        ])
      ],
    ));
  }
}