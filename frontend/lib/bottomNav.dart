import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNav extends StatefulWidget {
  final int currentIndex;

  BottomNav({this.currentIndex});

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  List<String> navigation = ['/thirdExplore', '/'];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (int index) async {
        if (index == 0) {
          Navigator.of(context).pushNamed('/thirdExplore');
        } else if (index == 1) {
          SharedPreferences myPrefs = await SharedPreferences.getInstance();
          await myPrefs.setString('jwt', '');
          Navigator.of(context).pushNamed('/');
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: new Icon(Icons.home, color: Colors.black),
          title: Text('Home', style: TextStyle(color: Colors.black)),
        ),
        BottomNavigationBarItem(
          icon: new Icon(Icons.close, color: Colors.black),
          title: Text('Sign Out', style: TextStyle(color: Colors.black)),
        )
      ],
    );
  }
}
