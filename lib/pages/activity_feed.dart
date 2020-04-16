import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dilena/pages/post_screen.dart';
import 'package:dilena/pages/profile.dart';
import 'package:dilena/widgets/header.dart';
import 'package:dilena/pages/home.dart';
import 'package:dilena/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  getActivityFeed() async {
    QuerySnapshot snapshot = await activityFeedRef
        .document(currentUser.id)
        .collection("feedItems")
        .orderBy("timestamp", descending: true)
        .limit(50)
        .getDocuments();
    List<ActivityFeedItem> feedItems = [];
    snapshot.documents.forEach((doc) {
      feedItems.add(ActivityFeedItem.fromDocument(doc));
      // print("Itens do mural de actividades: ${doc.data}");
    });
    return feedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
        appBar: header(context,
            titleText: "Mural de actividades", isAppTitle: false),
        body: Container(
          child: FutureBuilder(
              future: getActivityFeed(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return circularProgress();
                }
                return ListView(
                  children: snapshot.data,
                );
              }),
        ),
      ),
    );
  }
}

Widget mediaPreview;
String activityItemText;

class ActivityFeedItem extends StatelessWidget {
  final String username;
  final String userId;
  final String type; // like, follow, comment
  final String mediaUrl;
  final String postId;
  final String userProfileImage;
  final String commentData;
  final Timestamp timestamp;

  ActivityFeedItem(
      {this.username,
      this.userId,
      this.type, // like, follow, comment
      this.mediaUrl,
      this.postId,
      this.userProfileImage,
      this.commentData,
      this.timestamp});

  factory ActivityFeedItem.fromDocument(DocumentSnapshot doc) {
    return ActivityFeedItem(
      username: doc["username"],
      userId: doc["userId"],
      type: doc["type"],
      mediaUrl: doc["mediaUrl"],
      postId: doc["postId"],
      userProfileImage: doc["userProfileImage"],
      commentData: doc["commentData"],
      timestamp: doc["timestamp"],
    );
  }
  showPost(context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return PostScreen(
        postId: postId,
        userId: userId,
      );
    }));
  }

  configureMediaPreview(context) {
    if (type == "like" || type == "comment") {
      mediaPreview = GestureDetector(
        onTap: () {
          showPost(context);
        },
        child: Container(
          width: 50,
          height: 50,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(mediaUrl),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = Text("");
    }

    if (type == "like") {
      activityItemText = "gostou da tua publicação";
    } else if (type == "follow") {
      activityItemText = "está seguindo você";
    } else if (type == "comment") {
      activityItemText = "respondeu: \"$commentData\"";
    } else {
      activityItemText = "Erro: tipo desconhecido '$type'";
    }
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 2),
      child: Container(
        color: Colors.white54,
        child: ListTile(
          title: GestureDetector(
            onTap: () {
              showProfile(context, profileId: userId);
            },
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(fontSize: 14, color: Colors.black),
                children: [
                  TextSpan(
                    text: username,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: " $activityItemText",
                  )
                ],
              ),
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: CachedNetworkImageProvider(userProfileImage),
          ),
          subtitle: Text(
            timeago.format(timestamp.toDate()),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}

showProfile(BuildContext context, {String profileId}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) {
        return Profile(
          profileId: profileId,
        );
      },
    ),
  );
}
