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
  bool _showPassword = false;

  void register() async {
    try {
      setState(() {
        loading = true;
      });

      var res = await http.post(
          "https://limitless-meadow-18984.herokuapp.com/user/register",
          body: {
            'firstName': _firstNameController.text,
            'lastName': _lastNameController.text,
            'email': _emailController.text,
            'password': _passwordController.text,
          });

      var response = json.decode(res.body);

      if (response['error'] != null) {
        setState(() {
          errorMessage = response['error']['message'];
        });
      }
      if (response['token'] != null) {
        SharedPreferences myPrefs = await SharedPreferences.getInstance();
        myPrefs.setString('jwt', response['token']);
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
                      child: Text("Register",
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
                      margin: EdgeInsets.only(top: height * 0.06),
                      child: ErrorMessage(errorMessage: errorMessage),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: height * .04),
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
                          top: height * .05),
                      child: TextField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          hintText: "First Name",
                          prefixIcon: Container(
                              margin: EdgeInsets.only(
                                  left: width * .02, right: width * .05),
                              child: Icon(Icons.person_outline,
                                  color: Theme.of(context).dividerColor)),
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
                      child: TextField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          hintText: "Last Name",
                          prefixIcon: Container(
                              margin: EdgeInsets.only(
                                  left: width * .02, right: width * .05),
                              child: Icon(Icons.person,
                                  color: Theme.of(context).dividerColor)),
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
                      child: TextField(
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
                        register();
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
                              "Register",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("/secondLogin");
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
                              "Login",
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

/*   @override
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
                  borderSide: BorderSide(color: Colors.black26),
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
                  borderSide: BorderSide(color: Colors.black26),
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
                  borderSide: BorderSide(color: Colors.black26),
                ),
                border: OutlineInputBorder(),
              ),
              controller: _emailController,
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
              child: Text(
                'Register',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.lightBlueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

              onPressed:(){
              register();
              Navigator.of(context).pushNamed("/thirdExplore");
              }
            ),
          )
        ],
      )
      ),
      ),
    );
  } */
}
