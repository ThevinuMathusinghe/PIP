import 'package:flutter/material.dart';
import 'package:frontend/widgets/error.dart';
import 'package:frontend/widgets/loading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:convert';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  FacebookLogin facebookLogin = new FacebookLogin();
  bool isLoggedIn = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool loading = false;
  String errorMessage = "";
  bool _showPassword = false;

  void onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
    });
  }

  void initiateFacebookLogin() async {
    var fbLogin = FacebookLogin();
    var fbLoginResult = await facebookLogin.logIn(['email']);
    switch (fbLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error logging in");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled by User");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        print("Login Successfull");
        onLoginStatusChanged(true);
        break;
    }
  }

  void login() async {
    try {
      setState(() {
        loading = true;
      });
      var res = await http.post(
          "https://limitless-meadow-18984.herokuapp.com/user/login",
          body: {
            "email": _emailController.text,
            "password": _passwordController.text
          });
      var response = json.decode(res.body);

      if (response['error'] != null) {
        setState(() {
          errorMessage = response['error']['message'];
        });
      }
      if (response['token'] != null) {
        SharedPreferences myPrefs = await SharedPreferences.getInstance();
        myPrefs.setString("jwt", response['token']);
        setState(() {
          errorMessage = "";
        });
        Navigator.of(context).pushNamed("/thirdExplore");
      }
      setState(() {
        loading = false;
      });
    } catch (err) {
      setState(() {
        errorMessage = err;
      });
    }
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
                height: height * .15,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Theme.of(context).accentColor,
                  Theme.of(context).canvasColor
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: Container(
                  padding: EdgeInsets.only(bottom: height * .02),
                  child: Center(
                      child: Text("Login",
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
                    Container(
                      margin: EdgeInsets.only(top: height * .05),
                      child: ErrorMessage(errorMessage: errorMessage),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                            top: errorMessage != ""
                                ? height * .07
                                : height * .1),
                        child: Text(
                          "PIP",
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * .08,
                          right: width * .08,
                          top: height * .1),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: Container(
                            margin: EdgeInsets.only(
                                left: width * .02, right: width * .05),
                            child: Icon(
                              Icons.email,
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).cursorColor, width: 3),
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * .08,
                          right: width * .08,
                          top: height * .03),
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: Container(
                              margin: EdgeInsets.only(
                                  left: width * .02, right: width * .05),
                              child: Icon(Icons.lock,
                                  color: Theme.of(context).dividerColor)),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                            child: Icon(
                              _showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).cursorColor, width: 3),
                          ),
                          border: OutlineInputBorder(),
                        ),
                        obscureText: !_showPassword,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        login();
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
  }
}
