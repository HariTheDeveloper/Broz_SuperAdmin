import 'dart:io';

import 'package:device_id/device_id.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_country_picker/country.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:page_transition/page_transition.dart';
import 'package:push_notification/Data/login_data.dart';
import 'package:push_notification/Login/login/otp_page.dart';
import 'package:push_notification/Login/password/password_page.dart';
import 'package:push_notification/Utitlity/Constants.dart';
import 'package:push_notification/WebService/webservice.dart';
import 'package:push_notification/app_loader.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MobileLoginPage extends StatefulWidget {
  static const routeName = '/mobile_login';
  @override
  MobileLoginPageState createState() => MobileLoginPageState();
}

class MobileLoginPageState extends State<MobileLoginPage> {
  final GlobalKey<State> _keyAlertDialog = GlobalKey<State>();
  Country _selected;
  Future<Login> _futureLogin;
  bool showLoader = false;
  bool isCountrySelected = false;
  final myController = TextEditingController();
  static FirebaseMessaging fcm = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  OverlayEntry overlayEntry;

  void initState() {
    super.initState();
    showLoader = false;
    initialize();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    showLoader = false;
    super.dispose();
  }

  Future initialize() async {
    Constants.deviceId = await DeviceId.getID;
    print(Constants.deviceId);

    var android = AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    var platform = InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);

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
        },
        //called when app is in background and we receive notifications
        onResume: (Map<String, dynamic> message) async {
          print("on Resume :$message");
        });
  }

  showNotification(String title, String message) async {
    print("Message :$title");
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
    await flutterLocalNotificationsPlugin.show(0, title, message, platform);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Login"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              // padding: EdgeInsets.only(top: 50),
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        padding: const EdgeInsets.only(top: 50),
                        child: Text(
                          'Please verify your mobile number, in case we need to get in touch with you',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  mobileNumView(),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 40,
                    width: 200,
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          if (myController.text == "") {
                            Alert(
                              style: AlertStyle(
                                isCloseButton: false,
                              ),
                              context: context,
                              type: AlertType.none,
                              title: "Broz",
                              desc: "Please enter your mobile number",
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "Okay",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  color: Colors.green,
                                ),
                              ],
                            ).show();
                          } else {
                            callLogin();
                          }
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        'Verify',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      color: Colors.green,
                    ),
                  ),
                  /*
                  SizedBox(height: 10),
                  Text('(OR)'),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    width: 200,
                    child: FlatButton(
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        'Join us with facebook',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      color: Colors.blue,
                    ),
                  )*/
                  Container(
                    height: 100,
                    color: Colors.white,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  mobileNumView() => Container(
        padding: EdgeInsets.all(20),
        height: 60,
        child: Row(
          children: <Widget>[
            Container(
              child: Theme(
                data: Theme.of(context)
                    .copyWith(primaryColor: Colors.black.withOpacity(0.5)),
                child: CountryPicker(
                  dense: false,
                  showDialingCode: true,
                  showName: false,
                  onChanged: (Country country) {
                    setState(() {
                      _selected = country;
                      isCountrySelected = true;
                    });
                  },
                  selectedCountry: _selected,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Theme(
                data: Theme.of(context)
                    .copyWith(primaryColor: Colors.black.withOpacity(0.5)),
                child: TextField(
                  textAlign: TextAlign.start,
                  controller: myController,
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                    hintText: 'Enter mobile number',
                    labelStyle: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  void callLogin() async {
    showLoaderDialog(context, _keyAlertDialog);
    loginDetails(
      Resource(
        url: '${BaseUrl}adminVerifyPhone', //mverifyPhone
        request: loginRequestToJson(
          LoginRequest(
              countryCode:
                  isCountrySelected ? "+${_selected.dialingCode}" : "+1",
              deviceId: Constants.deviceId,
              deviceToken: Constants.deviceToken,
              deviceType: "3",
              facebookId: "",
              isFacebookLogin: false,
              language: "en",
              phoneNumber: myController.text),
        ),
      ),
    ).then((value) {
      closeLoaderDialog(_keyAlertDialog);
      if (value.status == 1) {
        print(value.details);
        Navigator.push(
            context,
            PageTransition(
                child: PasswordPage(logindetail: value.details),
                type: PageTransitionType.rightToLeftWithFade));
        return const SizedBox.shrink();
      } /*else if (value.status == 2) {
        Navigator.push(
            context,
            PageTransition(
                child: OtpPage(
                  logindetail: value.details,
                  isforgotOtp: false,
                ),
                type: PageTransitionType.leftToRightWithFade));
        return const SizedBox.shrink();
      } */
      else {
        Alert(
          style: AlertStyle(
            isCloseButton: false,
          ),
          context: context,
          type: AlertType.none,
          title: "Broz",
          desc: value.message,
          buttons: [
            DialogButton(
              child: Text(
                "Yes",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.green,
            ),
          ],
        ).show();
      }
    });
  }

  Future stopLoader() async {
    setState(() {
      showLoader = false;
    });
  }

  handleSnapshot(AsyncSnapshot<Login> snapshot) {
    print('handleSnapshot $snapshot ${snapshot.connectionState}');
    switch (snapshot.connectionState) {
      case ConnectionState.done:
        print(snapshot.data);

        print(snapshot.data.details);
        if (snapshot.data.status == 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PasswordPage(logindetail: snapshot.data.details)));
          return const SizedBox.shrink();
        } else if (snapshot.data.status == 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OtpPage(
                        isforgotOtp: false,
                        logindetail: snapshot.data.details,
                      )));
          return const SizedBox.shrink();
        } else {
          return Alert(
            style: AlertStyle(
              isCloseButton: false,
            ),
            context: context,
            type: AlertType.none,
            title: "Broz",
            desc: snapshot.data.message,
            buttons: [
              DialogButton(
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.green,
              ),
            ],
          ).show();
        }

        break;
      case ConnectionState.none:
        break;
      default:
        return Positioned.fill(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.green),
          ),
        );
    }
  }
}
