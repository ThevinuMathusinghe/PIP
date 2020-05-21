import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

class Explore extends StatelessWidget{
  @override
  Widget build(BuildContext context){

    Future<void> _optionsDialogBox(){
      return showDialog(context: context,
      builder: (BuildContext context){
        return AlertDialog(
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                GestureDetector(
                  child: new Text('Capture your logo'),
                  //onTap: openCamera,
                  )
              ]
            )
          ))
      }
      )
    }
    
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


 

