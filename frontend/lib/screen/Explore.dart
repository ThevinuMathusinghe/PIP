import 'package:flutter/material.dart';

class Explore extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    
    return MaterialApp(    
      home: new Container(
        color: Colors.blueAccent,
        child: new Column(
          children: <Widget>[
          new Row(
            children: <Widget>[
              new Expanded(
                child: RaisedButton(
                  child: Text(
                    'Logo',
                    style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.lightBlueAccent,
                    //onPressed: ,
                
                )
              )
            ]
          )
        ],)
      )
    );
  }
}


 

