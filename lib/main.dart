import 'dart:io';
import 'package:device_id/device_id.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:just_audio/just_audio.dart';

import 'package:push_notification/Login/login/mobile_login.dart';
import 'package:push_notification/Tabs/allservices_tab.dart';
import 'package:push_notification/Utitlity/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Broz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MyHomePageState createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<bool> loggedIn;
  Future<int> useriD;
  Future<int> userType;
  Future<List<String>> outletID;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static FirebaseMessaging fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    _loginSetup();
    initialize();
    fcm.getToken().then((value) {
      setState(() {
        Constants.deviceToken = value;
      });
    });
  }

  _playAlert() {
    var player = AudioPlayer();
    Future.delayed(Duration(milliseconds: 250), () async {
      player.setAsset('assets/Alert_Android.mp3');
      player.setLoopMode(LoopMode.all);
      await player.play();
    });
    Future.delayed(Duration(seconds: 15), () async {
      player.dispose();
    });
  }

  _loginSetup() {
    loggedIn = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool("loginStatus") ?? false;
    });
    useriD = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt("userID") ?? 0;
    });

    userType = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt("userType") ?? 0;
    });

    outletID = _prefs.then((SharedPreferences prefs) {
      return prefs.getStringList("outletID") ?? ["0"];
    });

    useriD.then((value) {
      Constants.userID = value;
    });
    userType.then((value) {
      Constants.userType = value;
    });
    outletID.then((value) {
      Constants.outletID = value;
    });
    loggedIn.then((value) {
      _moveScreens(value);
    });
  }

  void dispose() {
    super.dispose();
  }

  Future initialize() async {
    Constants.deviceId = await DeviceId.getID;
    print(Constants.deviceId);

    var android = AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    var platform = InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform,
        onSelectNotification: selectNotification);

    if (Platform.isIOS) {
      fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    fcm.configure(
        onBackgroundMessage:
            Platform.isAndroid ? fcmBackgroundMessageHandler : null,

        //called when app is in foreground and we receive notifications
        onMessage: (Map<String, dynamic> message) async {
          print("on Message :$message");
          if (Platform.isAndroid) {
            showNotification(message["notification"]["title"],
                message["notification"]["body"]);
          } else {
            showNotification(message["aps"]["alert"]["title"],
                message["aps"]["alert"]["body"]);
          }
        },
        //called when app is closed completely and opened when we receive notifications
        onLaunch: (Map<String, dynamic> message) async {
          print("on Launch :$message");
          //_playAlert();
        },
        //called when app is in background and we receive notifications
        onResume: (Map<String, dynamic> message) async {
          //_playAlert();
        });
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      ),
    );
  }

  showNotification(String title, String message) async {
    print("Message :$title");

    var android = AndroidNotificationDetails(
      'Broz_Admin_01',
      "Broz_Admin",
      "Offer Notification",
      icon: "ic_launcher_",
      sound: RawResourceAndroidNotificationSound('truckhorn'),
      playSound: true,
    );
    var iOS = IOSNotificationDetails(
        presentAlert: true, presentSound: true, sound: 'truckHorn.wav');
    var platform = NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, title, message, platform);
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 3000);
    }
  }

  static Future<dynamic> fcmBackgroundMessageHandler(
      Map<String, dynamic> message) {
    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      return notification;
    }

    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      return data;
    }

    return null;
    // Or do other work.
  }

  Future selectNotification(String payload) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FutureBuilder<bool>(
        future: loggedIn,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.green));
            default:
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return Container();
              }
          }
        },
      )),
    );
  }

  _moveScreens(bool loggedIn) {
    if (loggedIn) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AllServicesPage()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MobileLoginPage()));
    }
  }
}
