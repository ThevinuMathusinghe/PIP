import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

class Explore extends StatelessWidget{
  @override
  Widget build(BuildContext context){

    void camera() async{
      try{
        var camera = await ImagePicker.pickImage(
      source: ImageSource.camera,
        );
      }
      catch(err){

      }
    }

    void gallery() async{
      try{
        var gallery = await ImagePicker.pickImage(
          source: ImageSource.gallery,
        );
      }
      catch(err){

      }
    }

    Future<void> _optionsDialogBox(){
      return showDialog(context: context,
      builder: (BuildContext context){
        return AlertDialog(
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                RaisedButton(
                  child: new Text('Capture your logo'),
                  onPressed: camera,
                  ),
                
              ]
            )
          )
          );
      }
      );
      
    }
    
    return MaterialApp(    
      home: new Container(
        color: Colors.blueAccent,
        child: new Column(
          children: <Widget>[
          new Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: RaisedButton(
                  child: Text(
                    'Logo',
                    style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.lightBlueAccent,
                    onPressed: camera,           
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: RaisedButton(
                  child: Text(
                    'Product',
                    style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.lightBlueAccent,
                    onPressed: gallery,           
                ),
                
              )
            ]
          )
        ],)
      )
    );
  }
}


 

