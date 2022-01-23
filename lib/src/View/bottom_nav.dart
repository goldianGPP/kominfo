import 'package:flutter/material.dart';
import 'package:kominfo/src/View/arsip.dart';
import 'package:kominfo/src/View/home.dart';
import 'package:kominfo/src/View/profile.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key, required this.id_pengguna}) : super(key: key);
  final String? id_pengguna;

  @override
  State<BottomNav> createState() => _navState();
}

// ignore: camel_case_types
class _navState extends State<BottomNav> {
  int _selectedIndex = 0;
  late String? id_pengguna;

  @override
  void initState() {
    super.initState();
    id_pengguna = widget.id_pengguna;
  }

  static List<Widget> _widgetOptions(id_pengguna) {
    return <Widget>[
      Home(initialDate: DateTime.now(), id_pengguna: id_pengguna,),
      const ArsipIn(),
      Profile(id_pengguna: id_pengguna,),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions(id_pengguna).elementAt(_selectedIndex),
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
