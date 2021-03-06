import 'package:flutter/material.dart';
import 'package:frontend/screen/register.dart';
import 'package:frontend/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  bool loading = true;

  void checkJwt() async {
    try {
      SharedPreferences myPrefs = await SharedPreferences.getInstance();
      String token = myPrefs.getString('jwt');
      if (token == null || token == "") {
        setState(() {
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
        Navigator.of(context).pushNamed("/thirdExplore");
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    checkJwt();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (loading) {
      return Loading();
    }
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
                height: height * .50,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Theme.of(context).accentColor,
                  Theme.of(context).canvasColor
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: Container(
                  padding: EdgeInsets.only(bottom: height * .1),
                  child: Center(
                      child: Text("PIP",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 70,
                              fontWeight: FontWeight.bold))),
                )),
            Container(
                margin: EdgeInsets.only(top: height * .4),
                height:
                    height - MediaQuery.of(context).padding.top - height * .4,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                child: ListView(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: height * .05),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("/secondLogin");
                      },
                      child: Container(
                          margin: EdgeInsets.only(
                              left: width * .08,
                              right: width * .08,
                              top: height * .06),
                          width: width * .84,
                          height: height * .05,
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
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("/secondRegister");
                      },
                      child: Container(
                          margin: EdgeInsets.only(
                              left: width * .08,
                              right: width * .08,
                              top: height * .03),
                          width: width * .84,
                          height: height * .05,
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
                            child: Text(
                              "Register",
                              style: TextStyle(
                                  color: Theme.of(context).dividerColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          )),
                    )
                  ],
                ))
          ],
        )
      ],
    ));

    /* return Scaffold(
        backgroundColor: Colors.grey[300],
        body: Center(
          child: new Column(
            children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: height*0.1),
              child: new Container(
                child: new Image.asset(
                  'assets/image.jpg',
                  height: height*0.4,
                  width: width*0.4,
                  //colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  //fit: BoxFit.cover,
                ),
              ),
            ),
            ButtonTheme(
              padding: EdgeInsets.symmetric(vertical: height * .0005),
              child: RaisedButton(
                child: Text('Login',
                style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/secondLogin');
                },
                color: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * .05),
              child: RaisedButton(
                child: Text('Register',
                style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/secondRegister');
                },
                color: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ]),
        )); */
  }
}
