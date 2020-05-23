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
        ));
  }
}
