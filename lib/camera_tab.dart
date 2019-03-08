import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CameraPage extends StatefulWidget {
  static List uploads = [];
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File _image;
  String _downloadUrl;

  StorageReference firebaseStorageRef;
  StorageUploadTask task;

  Future getImageFromCamera() async {

    PermissionStatus res = await SimplePermissions.requestPermission(Permission. WriteExternalStorage);
    print(res);

    // Permission.Camera
    // Permission.WriteExternalStorage, Permission.ReadExternalStorage

    if (res == PermissionStatus.authorized) {
      var image = await ImagePicker.pickImage(source: ImageSource.camera);
      var imageName = image.path.split("/");

      if (image != null) {
        setState(() {
        _image = image;
        });

        var metadata = {
          'insect': 'spider',
        };

//        firebaseStorageRef = FirebaseStorage.instance.ref().child("images/" + imageName.last);
//        task = firebaseStorageRef.putFile(image, StorageMetadata(customMetadata: metadata));
//        Future future = (await task.onComplete).ref.getDownloadURL();
//        _downloadUrl = future.toString();
//        CameraPage.uploads.add(_downloadUrl);
//        print(getImageUris());

        firebaseStorageRef = FirebaseStorage.instance.ref().child("images/" + imageName.last);
        task = firebaseStorageRef.putFile(image, StorageMetadata(customMetadata: metadata));

        task.onComplete.then((var test) async {
          _downloadUrl = await firebaseStorageRef.getDownloadURL();
          print("DOWNLOAD URL " + _downloadUrl);
          CameraPage.uploads.add(_downloadUrl);
          print(getImageUris());
        });


      }
    }
  }

  static List getImageUris() {
    return CameraPage.uploads;
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
      _image = image;
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
              icon: Icon (Icons.camera_alt),
              onPressed: getImageFromCamera,
            ),
            IconButton(
              icon: Icon (Icons.photo),
              onPressed: getImageFromGallery,
            ),
          ],
        ),
        _image == null ? Placeholder() : Image.file(_image),
      ],
    );
  }
}

