import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  String email;
  String password;
  FacebookLogin facebookLogin = new FacebookLogin();
  bool isLoggedIn = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void onLoginStatusChanged(bool isLoggedIn){
    setState((){
      this.isLoggedIn = isLoggedIn;
    }
    );
  }

  void initiateFacebookLogin() async{
    var fbLogin = FacebookLogin();
    var fbLoginResult = await facebookLogin.logIn(['email']);
    switch(fbLoginResult.status){
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

  Future<String> attemptLogIn(String email, String password) async {
    var res = await http.post(
        "https://limitless-meadow-18984.herokuapp.com/user/login",
        body: {"email": email, "password": password});
    print(res.body);
    if (res.statusCode == 200) return res.body;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
          child: SingleChildScrollView(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: 'Email',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: 'Password',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: height * .1),
            child: RaisedButton(
              color: Colors.lightBlueAccent,
              onPressed: () async {
                SharedPreferences myPrefs =
                    await SharedPreferences.getInstance();
                email = _emailController.text;
                password = _passwordController.text;
                var jwt = await attemptLogIn(email, password);
                if (jwt != null) {
                  myPrefs.setString("jwt", jwt);
                  //Navigator.of(context).pushNamed("/login");
                } else {
                  return ("No account was found that matches that email and password");
                }
              },
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            child: Center(child: isLoggedIn
            ? Text("Logged In"):
            RaisedButton(
              child: Text("Login with Facebook"),
              onPressed: ()=> initiateFacebookLogin(),
              )
            )
            )
        ],
      )
      )
      ),
    );
  }
}
