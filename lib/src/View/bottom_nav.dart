import 'package:flutter/material.dart';
import 'package:kominfo/src/View/arsip.dart';
import 'package:kominfo/src/View/home.dart';
import 'package:kominfo/src/View/profile.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _navState();
}

// ignore: camel_case_types
class _navState extends State<BottomNav> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    Home(initialDate: DateTime.now()),
    const ArsipIn(),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'absen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility),
            label: 'arsip',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
