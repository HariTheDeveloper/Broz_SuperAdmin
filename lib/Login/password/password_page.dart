import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:push_notification/Data/forgot_password_data.dart';
import 'package:push_notification/Data/login_data.dart';
import 'package:push_notification/Data/password_check_data.dart';
import 'package:push_notification/Login/login/otp_page.dart';
import 'package:push_notification/Tabs/allservices_tab.dart';
import 'package:push_notification/Utitlity/Constants.dart';
import 'package:push_notification/WebService/webservice.dart';
import 'package:push_notification/app_loader.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordPage extends StatefulWidget {
  final LoginDetails logindetail;
  PasswordPage({Key key, @required this.logindetail}) : super(key: key);

  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final GlobalKey<State> _keyAlertDialog = GlobalKey<State>();
  Future<CheckPasswordResponse> _checkPassword;
  final myController = TextEditingController();
  bool _showHidePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Verify password"),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
            height: MediaQuery.of(context).size.height,
            child: Container(
              child: Column(
                children: <Widget>[
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Text('Welcome back, Sign in to Continue',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  SizedBox(
                    height: 20,
                  ),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(primaryColor: Colors.black.withOpacity(0.5)),
                    child: TextField(
                      textAlign: TextAlign.start,
                      controller: myController,
                      obscureText: _showHidePassword,
                      decoration: InputDecoration(
                          hintText: 'Enter Password',
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(10),
                            child: GestureDetector(
                              child: Icon(_showHidePassword
                                  ? Icons.cloud_off
                                  : Icons.cloud),
                              onTap: () {
                                setState(() {
                                  _showHidePassword = !_showHidePassword;
                                });
                              },
                            ),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.black,
                          )),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: FlatButton(
                        onPressed: () {
                          Alert(
                            style: AlertStyle(
                              isCloseButton: false,
                            ),
                            context: context,
                            type: AlertType.none,
                            title: "Forgot Password?",
                            desc:
                                'To update new password, please confirm this number ${widget.logindetail.countryCode} - ${widget.logindetail.phoneNumber} to send otp',
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Proceed",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  forgotPasswordApi();
                                },
                                color: Colors.green,
                              ),
                              DialogButton(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(116, 116, 191, 1.0),
                                  Color.fromRGBO(52, 138, 199, 1.0)
                                ]),
                              )
                            ],
                          ).show();
                        },
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                              color: Colors.lightGreen,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      width: 200,
                      child: FlatButton(
                        onPressed: () {
                          if (myController.text == "") {
                            Alert(
                              style: AlertStyle(
                                isCloseButton: false,
                              ),
                              context: context,
                              type: AlertType.none,
                              title: "Broz",
                              desc: "Please enter your password",
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
                          } else if (myController.text.length < 6) {
                            Alert(
                              style: AlertStyle(
                                isCloseButton: false,
                              ),
                              context: context,
                              type: AlertType.none,
                              title: "Broz",
                              desc: 'Please enter atleast 6 digit password',
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
                            checkPasswordApi();
                          }
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        color: Colors.green,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void forgotPasswordApi() {
    showLoaderDialog(context, _keyAlertDialog);
    forgotPassword(Resource(
      url: '${BaseUrl}mforgotPassword',
      request: forgotpasswordRequestToJson(
        ForgotPasswordRequest(
          phoneNumber: widget.logindetail.phoneNumber,
          language: "en",
          countryCode: widget.logindetail.countryCode,
          deviceType: "3",
        ),
      ),
    )).then((value) {
      closeLoaderDialog(_keyAlertDialog);
      if (value.status == 1) {
        Navigator.push(
            context,
            PageTransition(
                child: OtpPage(
                  logindetail: widget.logindetail,
                  isforgotOtp: true,
                  fpResponse: value,
                ),
                type: PageTransitionType.rightToLeftWithFade));
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
    });
  }

  void checkPasswordApi() {
    showLoaderDialog(context, _keyAlertDialog);
    passwordCheckDetails(Resource(
      url: '${BaseUrl}mverifyPassword',
      request: checkPasswordRequestToJson(
        CheckPasswordRequest(
          userId: widget.logindetail.userId,
          phoneNumber: widget.logindetail.phoneNumber,
          userPassword: myController.text,
          language: "en",
          countryCode: widget.logindetail.countryCode,
          deviceType: "3",
          deviceToken: Constants.deviceToken,
          deviceId: Constants.deviceId,
        ),
      ),
    )).then((value) {
      closeLoaderDialog(_keyAlertDialog);
      if (value.status == 1) {
        moveToAllServices(value.details.userId);
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

  void moveToAllServices(int withUserID) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('loginStatus', true);
    prefs.setInt('userID', withUserID);
    Constants.userID = withUserID;
    Navigator.push(
        context,
        PageTransition(
            child: AllServicesPage(), type: PageTransitionType.scale));
  }
}
