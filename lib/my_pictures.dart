import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'camera_tab.dart';

class MyPictures extends StatefulWidget {
  @override
  _MyPicturesState createState() => _MyPicturesState();
}

class _MyPicturesState extends State<MyPictures> {
//  static String downloadUrl = "https://firebasestorage.googleapis.com/v0/b/insectclassifier.appspot.com/o/f58a9ade-d3a6-4245-a18a-c624214419e06125892513033482463.jpg?alt=media&token=735b28c1-e196-49a7-b15e-cb62001f36cb";

  @override
  void initState() {
    super.initState();
  }

  List photos = CameraPage.uploads;

  static var storage = FirebaseStorage.instance.ref();
  var httpsReference = storage.child('gs://insectclassifier.appspot.com/images');

  // TODO: GET METADATA FROM URL

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: photos.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 200.0,
//                child: Image.network(
//                  photos[index],
//                  fit: BoxFit.cover,
//                  width: double.infinity,
//                  height: double.infinity,
//                ),
                child: CachedNetworkImage(
                  placeholder: LinearProgressIndicator(),
                  imageUrl: photos[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              ButtonTheme.bar(
                child: ButtonBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Spider"),
                    FlatButton(
                      child: Text("More info"),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
