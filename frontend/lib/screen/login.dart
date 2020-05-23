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
        //Navigator.of(context).pushNamed("/login");
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
      backgroundColor: Colors.grey[300],
      body: Center(
          child: SingleChildScrollView(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(height: MediaQuery.of(context).padding.top),
          ErrorMessage(errorMessage: errorMessage),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: 'Email',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26),
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock), 
                labelText: 'Password',
                suffixIcon: GestureDetector(
                  onTap: (){
                    setState(() {  
                      _showPassword=!_showPassword;                
                    });
                  },
                  child: Icon(
                  _showPassword ? Icons.visibility:Icons.visibility_off,
                ),
                ),
                  enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26),
                ),
                border: OutlineInputBorder(),
              ),
              obscureText: !_showPassword,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: height * .1),
            child: RaisedButton(
              color: Colors.lightBlueAccent,
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              onPressed:(){
              login();
              Navigator.of(context).pushNamed("/thirdExplore");
              }
              
            ),
          ),
          Container(     
              child: Center(
                  child: isLoggedIn
                      ? Text("Logged In")
                      : RaisedButton(
                        color: Colors.blue,
                          child: Text(
                            'Login with Facebook',
                          style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () => initiateFacebookLogin(),
                        )))
        ],
      ))),
    );
  }
}
