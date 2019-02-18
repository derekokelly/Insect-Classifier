import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:simple_permissions/simple_permissions.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File _image;

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future getImageFromCamera() async {

    PermissionStatus res = await SimplePermissions.requestPermission(Permission. WriteExternalStorage);
    print(res);

    // Permission.Camera
    // Permission.WriteExternalStorage, Permission.ReadExternalStorage

    if (res == PermissionStatus.authorized) {
      var image = await ImagePicker.pickImage(source: ImageSource.camera);
      final String path = "/storage/emulated/0/Pictures/Insect Classifier";
      await Directory(path).create(recursive: true);
      final File newImage = await image.copy('$path/${timestamp()}.jpg');

      if (newImage != null) {
        setState(() {
        _image = newImage;
        });
      }
    }
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
