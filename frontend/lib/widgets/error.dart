import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String errorMessage;

  ErrorMessage({this.errorMessage});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return errorMessage != ""
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: width * .08),
            child: Text(errorMessage, style: TextStyle(color: Colors.red)))
        : Container();
  }
}
