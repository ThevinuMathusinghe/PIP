import 'package:flutter/material.dart';
import 'package:frontend/bottomNav.dart';

class SingleLogo extends StatefulWidget {
  @override
  _SingleLogoState createState() => _SingleLogoState();
}

class _SingleLogoState extends State<SingleLogo> {
  var logo;
  List<bool> openDropdown = new List<bool>();
  bool dataSet = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    if (routeArgs != null && routeArgs['logo'] != null && !dataSet) {
      logo = routeArgs['logo'];
      openDropdown = logo['information']
          .map((information) {
            return false;
          })
          .toList()
          .cast<bool>();
      dataSet = true;
    }
    int indexDropdown = -1;
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
                          child: Text(logo['title'],
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
                          height: height * 0.2,
                          width: width * 0.6,
                          margin: EdgeInsets.only(
                              top: height * 0.05,
                              left: width * 0.08,
                              right: width * 0.08),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).accentColor,
                                  offset: Offset(0, 3),
                                  blurRadius: 6)
                            ],
                            border: Border.all(
                              color: Theme.of(context).accentColor,
                              width: 3.0,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          child: Container(
                            child: ListView(
                              padding: EdgeInsets.all(15),
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.all(5),
                                    child: RichText(
                                      text: new TextSpan(
                                          style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          ),
                                          children: <TextSpan>[
                                            new TextSpan(
                                                text: "Description: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            new TextSpan(
                                                text: logo['description']),
                                          ]),
                                    )),
                                Container(
                                    padding: EdgeInsets.all(5),
                                    child: RichText(
                                      text: new TextSpan(
                                          style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          ),
                                          children: <TextSpan>[
                                            new TextSpan(
                                                text: "Revenue: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            new TextSpan(text: logo['revenue']),
                                          ]),
                                    )),
                                Container(
                                    padding: EdgeInsets.all(5),
                                    child: RichText(
                                      text: new TextSpan(
                                          style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          ),
                                          children: <TextSpan>[
                                            new TextSpan(
                                                text: "Address: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            new TextSpan(text: logo['address']),
                                          ]),
                                    )),
                                Container(
                                    padding: EdgeInsets.all(5),
                                    child: RichText(
                                      text: new TextSpan(
                                          style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          ),
                                          children: <TextSpan>[
                                            new TextSpan(
                                                text: "Phone Number: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            new TextSpan(
                                                text: logo['phoneNumber']),
                                          ]),
                                    )),
                                Container(
                                    padding: EdgeInsets.all(5),
                                    child: RichText(
                                      text: new TextSpan(
                                          style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          ),
                                          children: <TextSpan>[
                                            new TextSpan(
                                                text: "Website: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            new TextSpan(text: logo['website']),
                                          ]),
                                    )),
                              ],
                            ),
                          ),
                        ),
                        ...logo['information'].map((information) {
                          indexDropdown++;
                          int index = indexDropdown;
                          Color color = Colors.grey;
                          if (information['rating'] == "praise") {
                            color = Colors.green;
                          } else if (information['rating'] == "criticism") {
                            color = Colors.red;
                          }

                          return InkWell(
                            onTap: () {
                              setState(() {
                                openDropdown[index] = !openDropdown[index];
                              });
                            },
                            child: Container(
                                margin: EdgeInsets.only(
                                    left: width * 0.08,
                                    right: width * 0.08,
                                    top: height * 0.02),
                                decoration: BoxDecoration(
                                  //color: color,
                                  /* boxShadow: [
                                BoxShadow(
                                    color: Theme.of(context).accentColor,
                                    offset: Offset(0, 3),
                                    blurRadius: 6)
                              ], */
                                  border: Border.all(color: color, width: 3.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Text(information['title'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    openDropdown[index]
                                        ? Container(
                                            padding: EdgeInsets.only(
                                                top: height * 0.01),
                                            child: Text(
                                              information['details'],
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        : Container()
                                  ],
                                )),
                          );
                        }).toList(),
                        Container(height: height * .1)
                      ],
                    ))
              ],
            ),
          ],
        ));
  }
}
