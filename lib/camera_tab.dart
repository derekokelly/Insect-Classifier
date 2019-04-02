import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File _image;
  String _downloadUrl;
  String _mlResult = 'No image taken... yet!';
  String _imageName = '';
  var _response;

  StorageReference firebaseStorageRef;
  StorageUploadTask task;

  FirebaseDatabase mDatabase;
  DatabaseReference databaseReference;

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future getImageFromCamera() async {
    PermissionStatus res = await SimplePermissions.requestPermission(
        Permission.WriteExternalStorage);

    if (res == PermissionStatus.authorized) {
      var image = await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        this._mlResult = "Classifying...";
      });
      uploadToStorage(image).then((_) {
        classify(_downloadUrl).then((_) {
          uploadToFireStore();
        });
      });
    }
  }

  Future getImageFromGallery() async {
    PermissionStatus res = await SimplePermissions.requestPermission(
        Permission.ReadExternalStorage);

    if (res == PermissionStatus.authorized) {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        this._mlResult = "Classifying...";
      });
      uploadToStorage(image).then((_) {
        classify(_downloadUrl).then((_) {
          uploadToFireStore();
        });
      });
    }
  }

  Future uploadToStorage(image) {
    _imageName = timestamp() + ".jpg";

    if (image != null) {
      setState(() {
        _image = image;
      });

      Fluttertoast.showToast(
          msg: "Uploading image to Firebase...",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16.0);

      firebaseStorageRef =
          FirebaseStorage.instance.ref().child("images/" + _imageName);
      task = firebaseStorageRef.putFile(image);

      return task.onComplete.then((var test) async {
        _downloadUrl = await firebaseStorageRef.getDownloadURL();

        print("DOWNLOAD URL " + _downloadUrl);
      });
    }
  }

  Future uploadToFireStore() {
    final DocumentReference documentReference =
        Firestore.instance.document("images/$_imageName");
//
//    String responseBody = _response.body;
//    List<String> newString = responseBody.split(RegExp("[^a-zA-Z0-9 -]"));
//    print("RESPONSE BODY " + newString);

    Map<String, dynamic> result = jsonDecode(_response.body);
    var insect = result["insect"];

    setState(() {
      this._mlResult = insect;
    });

    Map<String, String> data = <String, String>{
      "downloadUrl": _downloadUrl,
      "insect": insect,
    };

    return documentReference.setData(data).whenComplete(() {
      print("data added");
      Fluttertoast.showToast(
          msg: "Finsished uploading",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16.0);
    }).catchError((e) => print(e));
  }

  Future<http.Response> classify(downloadUrl) async {
    var url = 'http://209.97.186.15:8080';

//    Map data = {'downloadUrl': downloadUrl};

    //encode Map to JSON
    var body = downloadUrl;

    _response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
    print("${_response.statusCode}");
    print("${_response.body}");
    if (_response.statusCode == 200) {
      return _response;
    } else {
      return Future.error(StackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ButtonBar(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: getImageFromCamera,
            ),
            IconButton(
              icon: Icon(Icons.photo),
              onPressed: getImageFromGallery,
            ),
          ],
        ),
        _image == null
            ? Placeholder(
                fallbackHeight: 300.0,
              )
            : Image.file(
                _image,
                height: 400.0,
              ),
        Divider(),
        Text('Result: '),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            this._mlResult,
          ),
        ),
      ],
    );
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
