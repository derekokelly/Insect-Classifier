import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File _image;
  String _downloadUrl;

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
      uploadImage(image);
    }
  }

  Future getImageFromGallery() async {
    PermissionStatus res = await SimplePermissions.requestPermission(
        Permission.ReadExternalStorage);

    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    uploadImage(image);

    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  void uploadImage(image) {
    var imageName = timestamp() + ".jpg";

    if (image != null) {
      setState(() {
        _image = image;
      });

      var metadata = {
        'insect': 'spider',
      };

      Fluttertoast.showToast(
          msg: "Uploading image to Firebase...",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16.0);

      firebaseStorageRef =
          FirebaseStorage.instance.ref().child("images/" + imageName);
      task = firebaseStorageRef.putFile(
          image, StorageMetadata(customMetadata: metadata));

      task.onComplete.then((var test) async {
        _downloadUrl = await firebaseStorageRef.getDownloadURL();

        final DocumentReference documentReference =
            Firestore.instance.document("images/$imageName");
        Map<String, String> data = <String, String>{
          "downloadUrl": _downloadUrl,
        };

        documentReference.setData(data).whenComplete(() {
          print("data added");
          Fluttertoast.showToast(
              msg: "Finsished uploading",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              fontSize: 16.0);
        }).catchError((e) => print(e));

        print("DOWNLOAD URL " + _downloadUrl);
      });
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
        _image == null ? Placeholder() : Image.file(_image),
      ],
    );
  }
}
