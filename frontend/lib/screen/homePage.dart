import 'package:flutter/material.dart';
import 'package:frontend/screen/register.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: Column(children: <Widget>[
          Container(height: MediaQuery.of(context).padding.top),
          Container(
            height: width * .4,
            width: width * .4,
            child: new Image.asset(
              'assets/image.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: height * .0005),
            child: RaisedButton(
              child: Text('Login'),
              onPressed: () {
                Navigator.pushNamed(context, '/secondLogin');
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: height * .05),
            child: RaisedButton(
              child: Text('Register'),
              onPressed: () {
                Navigator.pushNamed(context, '/secondRegister');
              },
            ),
          ),
        ]));
  }
}
