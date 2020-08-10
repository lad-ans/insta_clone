import 'package:dilena/pages/home.dart';
import 'package:dilena/widgets/header.dart';
import 'package:dilena/widgets/post.dart';
import 'package:dilena/widgets/progress.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatelessWidget {
  final String userId;
  final String postId;

  PostScreen({this.userId, this.postId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postsRef
          .document(userId)
          .collection("userPosts")
          .document(postId)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // print("=============== POST SCREEN =============== \n postId: " +
          //     postId +
          //     "userId: " +
          //     userId);
          return circularProgress();
        }
        Post post = Post.fromDocument(snapshot.data);
        return Center(
          child: Scaffold(
            appBar:
                header(context, titleText: post.description, isAppTitle: false),
            body: ListView(
              children: <Widget>[
                Container(
                  child: post,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
