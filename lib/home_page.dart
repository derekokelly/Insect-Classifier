import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final _widgetOptions = [
    Center(
      child: Text('Index 0: Home'),
    ),
    CameraPage(),
    Center(
      child: Text('Index 2: Settings'),
    ),
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
          BottomNavigationBarItem(icon: Icon(Icons.collections), title: Text('My Pictures')),
          BottomNavigationBarItem(icon: Icon(Icons.photo_camera), title: Text('Camera')),
          BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text('Settings')),
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
}

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.red,
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 15),
                splashColor: Colors.grey,
                onPressed: () => print("pressed button"),
                child: Icon(
                  Icons.camera_alt,
                  size: 50,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
