import 'package:flutter/material.dart';
import 'package:insect_classifier/home_page.dart';
import 'package:insect_classifier/setuppage.dart';
import 'package:insect_classifier/splash_screen.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  cameras = await availableCameras();
  runApp(MyApp());
}

var routes = <String, WidgetBuilder>{
  "/setup": (BuildContext context) => SetupPage(),
  "/home": (BuildContext context) => HomePage(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: routes,
    );
  }
}
