import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';


class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
  
}

Future<String> attemptLogIn(String email, String password) async{
var res = await http.post("https://limitless-meadow-18984.herokuapp.com",
body: {
  "email": email,
  "password": password
  }
);
if(res.statusCode == 200) return res.body;
return null;
}

class _Login extends State<Login> {
  String email;
  String password;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: TextField(
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
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.lightBlueAccent,
              onPressed: () async {
                email = _emailController.text;
                password = _passwordController.text;
                var jwt = await attemptLogIn(email, password);
                if(jwt != null){
                  //storage.write(key: "jwt", value: jwt);
                }
                // Navigator.of(context).pushNamed("/login");
              },
            ),
          )
        ],
      )),
    );
  }
}
