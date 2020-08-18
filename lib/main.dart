import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:push_notification/Login/login/mobile_login.dart';
import 'package:push_notification/Tabs/allservices_tab.dart';
import 'package:push_notification/Utitlity/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  static FirebaseMessaging fcm = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    _loginSetup();
    fcm.getToken().then((value) {
      setState(() {
        Constants.deviceToken = value;
      });
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
      return prefs.getStringList("outletID") ?? 0;
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
                return Text('Error: ${snapshot.error}');
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
