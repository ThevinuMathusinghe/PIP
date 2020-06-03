import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: new Icon(Icons.home),
          title: InkWell(
            child: Text('Home'),
            onTap: () {
              Navigator.of(context).pushNamed('/thirdExplore');
            },
          ),
        ),
        BottomNavigationBarItem(
          icon: new Icon(Icons.close),
          title: InkWell(
            child: Text('Sign Out'),
            onTap: () {
              print("Got ge");
              Navigator.of(context).pushNamed('/');
            },
          ),
        )
      ],
    );
  }
}
