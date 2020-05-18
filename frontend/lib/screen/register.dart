import 'package:flutter/material.dart';

class Register extends StatefulWidget{
@override
_Register createState() => _Register();

}


class _Register extends State<Register> {
String email;
String firstName;
String surname;
String password;

  @override
  Widget build(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal:16.0),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'First Name',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey[300]
                      ),
                    ),
                    border: OutlineInputBorder(),
                    ),
                    onChanged: (value){
                      setState(() {
                        firstName = value;
                      });
                    },
                  ),
                ),
                Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal:16.0),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Surname',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey[300]
                      ),
                    ),
                    border: OutlineInputBorder(),
                    ),
                    onChanged: (value){
                      setState(() {
                        surname = value;
                      });
                    },
                  ),
                ),
                Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal:16.0),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Email',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey[300]
                      ),
                    ),
                    border: OutlineInputBorder(),
                    ),
                    onChanged: (value){
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                ),
                Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal:16.0),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Password',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey[300]
                      ),
                    ),
                    border: OutlineInputBorder(),
                    ),
                    onChanged: (value){
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:width, vertical:height),
                  child: MaterialButton(
                    child: Text('Register',
                    style: TextStyle(
                      color: Colors.white
                      ),),
                      color: Colors.lightBlueAccent,                     
                    ),
                  )



            ],
            )
          
          ),
      );
  }
}