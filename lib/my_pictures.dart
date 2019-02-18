import 'package:flutter/material.dart';
import 'dart:io';

class MyPictures extends StatelessWidget {
  static File image1 = File("/storage/emulated/0/Pictures/Insect Classifier/image1.jpg");
  static File image2 = File("/storage/emulated/0/Pictures/Insect Classifier/image2.jpg");
  List<File> photos = [image1, image2];

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
                  child: Image.file(
                    photos[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )),
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
