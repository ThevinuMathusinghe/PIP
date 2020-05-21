import 'package:flutter/material.dart';
import 'package:frontend/widgets/error.dart';
import 'package:frontend/widgets/loading.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  bool loading = false;
  String errorMessage = "";

  void register() async{
    try{
      setState(() {
        loading = true;
      });

      var res = await http.post("https://limitless-meadow-18984.herokuapp.com/user/register", 
      body: {
        'firstName':_firstNameController.text,
        'lastName':_lastNameController.text,
        'email':_emailController.text,
        'password':_passwordController.text,
      });

      var response = json.decode(res.body);

      if(response['error']!=null){
        setState(() {
          errorMessage= response['error']['message'];
        });
      }
      if(response['token']!=null){
        SharedPreferences myPrefs = await SharedPreferences.getInstance();
        myPrefs.setString('jwt', response['token']);
        setState(() {
          errorMessage="";
        });
      }
      setState(() {
        loading = false;
      });

    }
    catch(err){
      setState(() {
        errorMessage = err;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if(loading){
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
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: 'First Name',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
                border: OutlineInputBorder(),
              ),
              controller: _firstNameController,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: 'Surname',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
                border: OutlineInputBorder(),
              ),
              controller: _lastNameController,             
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: 'Email',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
                border: OutlineInputBorder(),
              ),
              controller: _emailController,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: 'Password',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
                border: OutlineInputBorder(),
              ),
              controller: _passwordController,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: height * .1),
            child: RaisedButton(
              child: Text(
                'Register',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.lightBlueAccent,
              onPressed:register
                //Navigator.of(context).pushNamed("/homepage");
              
            ),
          )
        ],
      )
      ),
      ),
    );
  }
}
