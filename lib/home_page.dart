import 'package:flutter/material.dart';
import 'camera_tab.dart';
import 'my_pictures.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final _widgetOptions = [
    MyPictures(),
    CameraPage(),
//    Center(
//      child: Text('Index 2: Settings'),
//    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Home page"),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.collections), title: Text('My Pictures')),
          BottomNavigationBarItem(
              icon: Icon(Icons.photo_camera), title: Text('Camera')),
//          BottomNavigationBarItem(
//              icon: Icon(Icons.settings), title: Text('Settings')),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      // TODO: finish implementing
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}

