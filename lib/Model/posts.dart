import 'package:flutter/material.dart';
import 'package:push_notification/Model/models.dart';
import 'package:push_notification/Model/post.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class Posts extends StatefulWidget {
  const Posts({
    Key key,
  }) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final scrollController = ScrollController();
  PostsModel posts;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  @override
  void initState() {
    posts = PostsModel();
    initialize();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        posts.loadMore();
      }
    });
    super.initState();
  }

  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  initialize() {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(

        //called when app is in foreground and we receive notifications
        onMessage: (Map<String, dynamic> message) async {
      print("on Message :$message");
    },
        //called when app is closed completely and opened when we receive notifications
        onLaunch: (Map<String, dynamic> message) async {
      print("on Launch :$message");
    },
        //called when app is in background and we receive notifications
        onResume: (Map<String, dynamic> message) async {
      print("on Resume :$message");
    });

    _fcm.onIosSettingsRegistered.listen((IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });

    _fcm.getToken().then((token) {
      print("Token :$token");
    });
  }

/*
  update(String token) {
    print(token);
    DatabaseReference databaseReference = new FirebaseDatabase().reference();
    databaseReference.child('fcm-token/${token}').set({"token": token});
    textValue = token;
    setState(() {});
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: posts.stream,
        builder: (BuildContext _context, AsyncSnapshot _snapshot) {
          if (!_snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.green[300])));
          } else {
            return RefreshIndicator(
              onRefresh: posts.refresh,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                controller: scrollController,
                separatorBuilder: (context, index) => Divider(),
                itemCount: _snapshot.data.length + 1,
                itemBuilder: (BuildContext _context, int index) {
                  if (index < _snapshot.data.length) {
                    return Post(post: _snapshot.data[index]);
                  } else if (posts.hasMore) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      child: Center(
                          child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.green[300]))),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      child: Center(child: Text('nothing more to load!')),
                    );
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }
}
