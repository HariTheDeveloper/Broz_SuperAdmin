import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:push_notification/Data/forgot_password_data.dart';
import 'package:push_notification/Data/password_check_data.dart';
import 'package:push_notification/Login/login/mobile_login.dart';
import 'package:push_notification/Utitlity/Constants.dart';
import 'package:push_notification/WebService/webservice.dart';
import 'package:push_notification/app_loader.dart';
import 'package:push_notification/main.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ChangePAsswordPage extends StatefulWidget {
  final ForgotOtpResponse otpResponse;

  const ChangePAsswordPage({Key key, this.otpResponse}) : super(key: key);
  @override
  _ChangePAsswordPageState createState() => _ChangePAsswordPageState();
}

class _ChangePAsswordPageState extends State<ChangePAsswordPage> {
  final GlobalKey<State> _keyAlertDialog = GlobalKey<State>();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();
  bool _showConfirmPassword = true;
  bool _showNewPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'New Password',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              SizedBox(height: 5),
              SizedBox(
                height: 40,
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(primaryColor: Colors.black.withOpacity(0.5)),
                  child: TextField(
                    controller: newPassword,
                    obscureText: _showNewPassword,
                    decoration: new InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          child: Icon(
                              _showNewPassword ? Icons.cloud_off : Icons.cloud),
                          onTap: () {
                            setState(() {
                              _showNewPassword = !_showNewPassword;
                            });
                          },
                        ),
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(2.0),
                        ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Confirm Password',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 40,
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(primaryColor: Colors.black.withOpacity(0.5)),
                  child: TextField(
                    controller: confirmPassword,
                    obscureText: _showConfirmPassword,
                    decoration: new InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          child: Icon(_showConfirmPassword
                              ? Icons.cloud_off
                              : Icons.cloud),
                          onTap: () {
                            setState(() {
                              _showConfirmPassword = !_showConfirmPassword;
                            });
                          },
                        ),
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(2.0),
                        ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                  width: 250,
                  color: Colors.green,
                  child: FlatButton(
                    onPressed: () {
                      if (newPassword.text.isEmpty) {
                        _showAlert("Please enter new password");
                      } else if (confirmPassword.text.isEmpty) {
                        _showAlert("Please enter confirm password");
                      } else if (newPassword.text == confirmPassword.text) {
                        changePasswordApi();
                      } else {
                        _showAlert("passwords does not match");
                      }
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    color: Colors.green,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  final PageRouteBuilder _homeRoute = new PageRouteBuilder(
    pageBuilder: (BuildContext context, _, __) {
      return MyApp();
    },
  );

  _showAlert(withMessage) {
    Alert(
      style: AlertStyle(
        isCloseButton: false,
      ),
      context: context,
      type: AlertType.none,
      title: "Broz",
      desc: withMessage,
      buttons: [
        DialogButton(
          child: Text(
            "Okay",
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

  void changePasswordApi() {
    showLoaderDialog(context, _keyAlertDialog);
    passwordChange(Resource(
      url: '${BaseUrl}mupdateNewPassword',
      request: changePasswordRequestToJson(
        ChangePasswordRequest(
          userId: "",
          language: "en",
          newPassword: newPassword.text,
          retypePassword: confirmPassword.text,
          userUnique: widget.otpResponse.userUnique,
          deviceType: "3",
          deviceToken: Constants.deviceToken,
          deviceId: Constants.deviceId,
        ),
      ),
    )).then((value) {
      closeLoaderDialog(_keyAlertDialog);
      if (value.status == 1) {
        Navigator.pushAndRemoveUntil(context, _homeRoute, (route) => false);
        Navigator.push(
            context,
            PageTransition(
                child: MobileLoginPage(), type: PageTransitionType.scale));
      } else {
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
                "Okay",
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
      print(value);
    });
  }
}
