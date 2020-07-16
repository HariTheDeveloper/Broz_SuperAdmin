import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:push_notification/Barber/barber.dart';
import 'package:push_notification/Grocery/grocery.dart';
import 'package:push_notification/Laundry/laundry.dart';
import 'package:push_notification/Maid/maid.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_notification/Push/push.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: MyHomePage(title: 'Super Admin'),
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
  List<Map<String, dynamic>> tabsArray = [];
  int selectedIndex = 0;
  static FirebaseMessaging fcm = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    initialize();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Future initialize() async {
    var android = AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    var platform = InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);

    if (Platform.isIOS) {
      fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    fcm.configure(
        onBackgroundMessage: fcmBackgroundMessageHandler,

        //called when app is in foreground and we receive notifications
        onMessage: (Map<String, dynamic> message) async {
          print("on Message :$message");
          showNotification(message);
        },
        //called when app is closed completely and opened when we receive notifications
        onLaunch: (Map<String, dynamic> message) async {
          print("on Launch :$message");
          showNotification(message);
        },
        //called when app is in background and we receive notifications
        onResume: (Map<String, dynamic> message) async {
          print("on Resume :$message");
          showNotification(message);
        });
  }

  showNotification(Map<String, dynamic> msg) async {
    var android = AndroidNotificationDetails(
      'Broz_Admin_01',
      "Broz_Admin",
      "Offer Notification",
      icon: "ic_launcher_",
      sound: RawResourceAndroidNotificationSound('notification'),
      playSound: true,
    );
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, msg["notification"]["title"], msg["notification"]["body"], platform);
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

  @override
  Widget build(BuildContext context) {
    tabsArray = [
      {
        "title": "Grocery",
        "icon": Image.asset(
          "assets/grocery.png",
          width: 24,
          height: 24,
          color: selectedIndex == 0 ? Colors.green : Colors.grey,
        )
      },
      {
        "title": "Barber",
        "icon": Image.asset(
          "assets/barber.png",
          width: 24,
          height: 24,
          color: selectedIndex == 1 ? Colors.green : Colors.grey,
        )
      },
      {
        "title": "Maid",
        "icon": Image.asset(
          "assets/maid.png",
          width: 24,
          height: 24,
          color: selectedIndex == 2 ? Colors.green : Colors.grey,
        )
      },
      {
        "title": "Laundry",
        "icon": Image.asset(
          "assets/laundry.png",
          width: 24,
          height: 24,
          color: selectedIndex == 3 ? Colors.green : Colors.grey,
        )
      }
    ];

    return bottomTabViewSetup(context);
  }

  Widget bottomTabViewSetup(BuildContext context) {
    var title = tabsArray[selectedIndex];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: tabsArray.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "${title["title"]}",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShareTokenPage()));
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: Text(
                    "Share Token",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 0.8),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ],
            backgroundColor: Colors.green,
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              GroceryScreen(),
              BarberScreen(),
              MaidScreen(),
              LaundryScreen(),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: Platform.isIOS
                ? MediaQuery.of(context).size.height >= 812
                    ? EdgeInsets.only(bottom: 34)
                    : EdgeInsets.only(bottom: 0)
                : EdgeInsets.all(0),
            child: TabBar(
              isScrollable: false,
              onTap: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              tabs: _getTabs(),
              labelColor: Colors.green,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.all(5.0),
              indicatorColor: Colors.transparent,
            ),
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

//Generating tabs used in the bottom dynamically
  List<Tab> _getTabs() {
    List tabs = List<Tab>();
    for (var i = 0; i < tabsArray.length; i++) {
      tabs.add(Tab(
        icon: tabsArray[i]["icon"],
        text: tabsArray[i]["title"],
      ));
    }
    return tabs;
  }
}
