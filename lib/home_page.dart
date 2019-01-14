import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final _widgetOptions = [
    Text('Index 0: Home'),
    Text('Index 1: Camera'),
    Text('Index 2: Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Home page"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
         BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
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

// import 'package:flutter/material.dart';

// class HomePage extends StatelessWidget {
//   int _selectedIndex = 1;
//   final _widgetOptions = [
//     Text('Index 0: Home'),
//     Text('Index 1: Business'),
//     Text('Index 2: School'),
//   ];


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: Text("Home page"),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Center(
//             child: Text(
//               "Camera goes here",
//               style: TextStyle(
//                 fontSize: 50
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: <BottomNavigationBarItem>[
//          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
//          BottomNavigationBarItem(icon: Icon(Icons.business), title: Text('Business')),
//          BottomNavigationBarItem(icon: Icon(Icons.school), title: Text('School')),
//        ],
//        currentIndex: _selectedIndex,
//        onTap: _onItemTapped,
//       ),
//       // TODO: finish implementing
//     );
//   }

//   void _onItemTapped(int index) {
//    setState(() {
//      _selectedIndex = index;
//    });
//  }

// }