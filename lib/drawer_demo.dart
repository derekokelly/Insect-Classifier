import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home page"),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Derek O'Kelly"),
              accountEmail: Text("derekokelly1997@gmail.com"),
              currentAccountPicture: GestureDetector(
                onTap: () => print("profile image tapped"),
                child: CircleAvatar(
                  backgroundImage: NetworkImage("http://pngimages.net/sites/default/files/user-png-image-79267.png"),
                ),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage("https://bit.ly/2ChQTUr")
                ),
              ),
            ),
            ListTile(
              title: Text("First Page"),
            ),
            ListTile(
              title: Text("Second Page"),
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          "Placeholder",
          style: TextStyle(
            fontSize: 50,
          ),
        ),
      ),
    );
  }
}
