import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:push_notification/main.dart';
import 'package:share/share.dart';

class ShareTokenPage extends StatefulWidget {
  @override
  _ShareTokenPageState createState() => _ShareTokenPageState();
}

class _ShareTokenPageState extends State<ShareTokenPage> {
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  String deviceToken;
  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() {
    fcm.getToken().then((value) {
      setState(() {
        deviceToken = value;
      });
      print("deviceToken:$deviceToken");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Device Token",
          style: TextStyle(color: Colors.white),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 5.0,
            ),
            Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Token",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "$deviceToken",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Text(
                            "Please share your device token to admin to get in contact by clicking the share button below !",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ))),
            const SizedBox(
              height: 8.0,
            ),
            InkWell(
              onTap: () {
                final RenderBox box = context.findRenderObject();
                Share.share(deviceToken,
                    subject: "Push Notification",
                    sharePositionOrigin:
                        box.localToGlobal(Offset.zero) & box.size);
              },
              child: Container(
                color: Colors.green,
                padding: EdgeInsets.all(10),
                child: Text(
                  'Share',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
