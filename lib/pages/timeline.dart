import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dilena/widgets/header.dart';
import 'package:dilena/widgets/progress.dart';
import 'package:flutter/material.dart';

final usersRef = Firestore.instance.collection("users");

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  void initState() {
    // getUserById();
    // createUser();
    // updateUser();
    // deleteUser();
    super.initState();
  }

  createUser() {
    usersRef.document("id001").setData({
      "username": "Nércio",
      "isAdmin": false,
      "postsCount": 6,
    });
  }

  updateUser() async {
    final doc = await usersRef.document("gS2057tmSNhA7hHjz4x0").get();
    if (doc.exists) {
      doc.reference.updateData({
        "username": "Banks Slomoh",
        "isAdmin": true,
        "postsCount": 6,
      });
    }
  }

  deleteUser() async {
    final DocumentSnapshot doc =
        await usersRef.document("gS2057tmSNhA7hHjz4x0").get();
    if (doc.exists) {
      doc.reference.delete();
    }
  }

  // getUserById() async {
  //   final String id = "hOddcvKWUTZ6u5hqauTv";
  //   final DocumentSnapshot doc = await usersRef.document(id).get();
  //   print(doc.data);
  //   print(doc.documentID);
  //   print(doc.exists);
  // }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          final List<Text> children = snapshot.data.documents
              .map((user) => Text(user["username"]))
              .toList();
          return Container(
            child: ListView(
              children: children,
            ),
          );
        },
      ),
    );
  }
}
