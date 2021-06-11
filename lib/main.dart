import 'dart:io';
import 'package:broz_admin/Login/login/mobile_login.dart';
import 'package:broz_admin/Tabs/allservices_tab.dart';
import 'package:broz_admin/Utitlity/Constants.dart';
import 'package:device_id/device_id.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

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
  FirebaseMessaging fcm;
  bool isFromBackgroundNotification = false;
  @override
  void initState() {
    super.initState();

    _loginSetup();
    initialize();
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

  Future<void> firebaseConfig() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    fcm = FirebaseMessaging.instance;
    _firebaseCloudMessagingListeners();
  }

  Future initialize() async {
    Constants.deviceId = await DeviceId.getID;
    print(Constants.deviceId);
    firebaseConfig();
  }

  void _firebaseCloudMessagingListeners() {
    if (Platform.isIOS) _iOSPermission();

    fcm.getToken().then((value) {
      setState(() {
        Constants.deviceToken = value;
      });
    });
    var android = AndroidInitializationSettings('app_icon');
    var ios = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false);
    var platform = InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(
      platform,
    );

//*: Foreground Message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      var remoteMessage = message.data;
      RemoteNotification remoteNotification;
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        remoteNotification = message.notification;
      }

      if (Platform.isAndroid) {
        //   var data = remoteMessage['body'];
        // Map<String, dynamic> notification = json.decode(data);
        _handleMessageForAndroid(remoteNotification);
      } else {
        _handleMessageForiOS(remoteNotification);
      }
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      var remoteMessage = message.data;
      //  _playAlert();
      RemoteNotification remoteNotification;
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        remoteNotification = message.notification;
      }
      if (Platform.isAndroid) {
        // var data = remoteMessage['body'];
        // Map<String, dynamic> notification = json.decode(data);
        isFromBackgroundNotification = true;
        _handleMessageForAndroid(remoteNotification);
      } else {
        isFromBackgroundNotification = true;
        _handleMessageForiOS(remoteNotification);
      }
    });
  }

  _iOSPermission() async {
    NotificationSettings settings = await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
    print('Handling a background message $message');
    // _playAlert();
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

  _handleMessageForAndroid(RemoteNotification notification) {
    _showNotification(notification.title, notification.body);
  }

  _handleMessageForiOS(RemoteNotification notification) {
    _showNotification(notification.title, notification.body);
    print(notification.title);
  }

  _showNotification(String title, String message) async {
    print("Message :$title");

    var android = AndroidNotificationDetails(
      'Broz_Admin_01',
      "Broz_Admin",
      "Offer Notification",
      icon: "ic_launcher_",
      sound: RawResourceAndroidNotificationSound('alert.mp3'),
      playSound: true,
    );
    var iOS = IOSNotificationDetails(
        presentAlert: true, presentSound: true, sound: 'alert.wav');
    var platform = NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(0, title, message, platform);
    if (!isFromBackgroundNotification) {
      // await flutterLocalNotificationsPlugin.show(0, title, message, platform);
      // if (await Vibration.hasVibrator()) {
      //   Vibration.vibrate(duration: 3000);
      //   // _playAlert();
      // }
    } else {
      isFromBackgroundNotification = false;
    }
  }

  static Future<dynamic> fcmBackgroundMessageHandler(
      Map<String, dynamic> message) {
    print("Background Message");
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
