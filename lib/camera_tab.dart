import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File _image;
  String _downloadUrl;
  String _mlResult = 'No image taken... yet!';
  String _label = '';

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
      classify(image).whenComplete(() {
        uploadImage(image, _label);
      });
    }
  }

  Future getImageFromGallery() async {
    PermissionStatus res = await SimplePermissions.requestPermission(
        Permission.ReadExternalStorage);
    print(res);

    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    classify(image).whenComplete(() {
      uploadImage(image, _label);
    });

    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  void uploadImage(image, String label) {
    var imageName = timestamp() + ".jpg";

    if (image != null) {
      setState(() {
        _image = image;
      });

      var metadata = {
        'insect': label,
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
          'insect': label
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

  Future classify(image) async {
    String result = '';

    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
    final LabelDetector labelDetector = FirebaseVision.instance.labelDetector();

    final List<Label> labels = await labelDetector.detectInImage(visionImage);
    result += 'Detected ${labels.length} labels';

    double prevConfidence = 0;
    double confidence = 0;
    String mlLabel = '';
    for (Label label in labels) {
      confidence = label.confidence;

      if (label.confidence > prevConfidence) {
        mlLabel = label.label;
        result =
            '\nLabel: $mlLabel, confidence=${confidence.toStringAsFixed(3)}';
        prevConfidence = label.confidence;
      }
    }
    if (result.length > 0) {
      setState(() {
        this._mlResult = result;
        _label = mlLabel;
        print("ML RESULT " + _label);
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
