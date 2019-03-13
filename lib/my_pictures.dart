import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyPictures extends StatefulWidget {
  @override
  _MyPicturesState createState() => _MyPicturesState();
}

class _MyPicturesState extends State<MyPictures> {
  @override
  void initState() {
    super.initState();
  }

  final CollectionReference collectionReference =
      Firestore.instance.collection("images");

  // TODO: PUT NEW PHOTOS AT TOP

  Widget _buildListItem(context, index) {
    return Card(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 200.0,
            child: CachedNetworkImage(
              placeholder: Center(
                child: CircularProgressIndicator(),
              ),
              imageUrl: index['downloadUrl'],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(index['insect']),
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
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: collectionReference.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text("Loading...");
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) =>
              _buildListItem(context, snapshot.data.documents[index]),
        );
      },
    );
  }
}
