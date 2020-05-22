import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:frontend/widgets/error.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Explore extends StatefulWidget{
  @override
  _explore createState() => _explore();
}

class _explore extends State<Explore>{

  File imageFile;
  bool loading = false;
  String errorMessage = "";
  

    void camera() async{
      try{
        var camera = await ImagePicker.pickImage(
          source: ImageSource.camera,
        );
        this.setState(() {
          imageFile = camera;
        });

      if (imageFile == null) return;
      String base64Image = base64Encode(imageFile.readAsBytesSync());
      String fileName = imageFile.path.split("/").last;
      List<String> printOut = new List<String>();
      var res = await http.post(
          "https://limitless-meadow-18984.herokuapp.com/user/identify",     
      body: {
        "image": base64Image,
        "name": fileName,
      });
        var response = await json.decode(res.body);
        if (response['error'] != null) {
        setState(() {
          errorMessage = response['error']['message'];
        });
      }
        print(response['logos']);
        setState(() {
          printOut = response['logos']
              .map((logo) {
                return logo;
              })
              .toList()
              .cast<String>();
        });
      }
      catch (err) {
      setState(() {
        errorMessage = err;
      });
    }
    } 
    

    /* void gallery() async{
      try{
        var gallery = await ImagePicker.pickImage(
          source: ImageSource.gallery,
        );
        this.setState(() {
          imageFile = gallery;
        });
      }
      catch (err) {
      setState(() {
        errorMessage = err;
      });
    }
    } */

    Future<void> _showChoiceDialog(BuildContext context){
      return showDialog(context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Make a choice"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child:  Text('Gallery'),
                  onTap: (){
                    gallery();
                  } 
                ),
                GestureDetector(
                  child: Text('Camera'),
                  onTap: (){
                    camera();
                  },
                )
              ]
            )
          )
          );
      }
      );
    }
    

    
    @override
    Widget build(BuildContext context) {
      return Scaffold(
    
      body: new Container(      
        color: Colors.blueAccent,
        child: new Column(
          children: <Widget>[
          new Row(
            children: <Widget>[
              ErrorMessage(errorMessage: errorMessage),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: RaisedButton(
                  child: Text(
                    'Logo',
                    style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.lightBlueAccent,
                    onPressed: (){
                    _showChoiceDialog(context);
                  },            
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: RaisedButton(
                  onPressed: (){
                    _showChoiceDialog(context);
                  }, 
                  child: Text(
                    'Product',
                    style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.lightBlueAccent,
                               
                ),
                
              )
            ]
          )
        ],)
      )
      );
    }
    
  
  }



 

