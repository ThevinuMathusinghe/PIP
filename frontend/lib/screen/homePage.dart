import 'dart:html';
import 'package:flutter/material.dart';
import 'package:frontend/screen/register.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage>{

  @override
  Widget build(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      
     body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
            child: RaisedButton(
              child: Text('Loginn'),
              onPressed: (){
                Navigator.pushNamed(context, '/second');
              },
               
              
            ),
          ),
          new Image.asset('assets/image.png',
          width: width*0.4,
          height: height*0.4,
          )
            
            
          
        ]
      )
     )
    );
  }

}
