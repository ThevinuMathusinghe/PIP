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
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
              Container(height: MediaQuery.of(context).padding.top),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Image.asset(
                  'assets/image.jpg',
                  width: width * 0.7,
                  height: height * 0.7,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: height * .05),
                child: RaisedButton(
                  child: Text('Login'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/secondLogin');
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: height * .0001),
                child: RaisedButton(
                  child: Text('Register'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/secondRegister');
                  },
                ),
              ),
            ])));
  }
}
