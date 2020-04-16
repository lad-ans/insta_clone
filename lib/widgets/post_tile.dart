import 'package:dilena/pages/post_screen.dart';
import 'package:dilena/widgets/custom_image.dart';
import 'package:dilena/widgets/post.dart';
import 'package:flutter/material.dart';

class PostTile extends StatelessWidget {
  final Post post;

  PostTile({
    this.post,
  });

  showPost(context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return PostScreen(
        postId: post.postId,
        userId: post.ownerId,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showPost(context);
      },
      child: cachedNetworkImage(post.mediaUrl),
    );
  }
}
