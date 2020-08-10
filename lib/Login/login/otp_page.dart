import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:push_notification/Data/forgot_password_data.dart';
import 'package:push_notification/Data/login_data.dart';
import 'package:push_notification/Data/otpVerify_data.dart';
import 'package:push_notification/Login/password/change_password_page.dart';
import 'package:push_notification/Login/signup/signupscreen.dart';
import 'package:push_notification/Utitlity/Constants.dart';
import 'package:push_notification/WebService/webservice.dart';
import 'package:push_notification/app_loader.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class OtpPage extends StatefulWidget {
  final LoginDetails logindetail;
  final ForgotPasswordResponse fpResponse;
  final bool isforgotOtp;
  OtpPage(
      {Key key, @required this.logindetail, this.fpResponse, this.isforgotOtp})
      : super(key: key);
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final GlobalKey<State> _keyAlertDialog = GlobalKey<State>();
  Timer _timer;
  int _start = 30;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Enter OTP"),
        ),
        body: Container(
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text(
                    'We have send a code to ${widget.logindetail.countryCode} ${widget.logindetail.phoneNumber}\n Please enter it below to continue',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Theme(
                  data: Theme.of(context)
                      .copyWith(primaryColor: Colors.black.withOpacity(0.5)),
                  child: PinEntryTextField(
                    onSubmit: (String pin) {
                      widget.isforgotOtp
                          ? forgotOtpApi(pin)
                          : otpRequestApi(pin, 'msignupOtpVerify');
                    }, // end onSubmit
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Align(
                    alignment: Alignment.center,
                    child: Row(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            if (_start == 0) {
                              setState(() {
                                _start = 30;
                                startTimer();
                                otpRequestApi("", 'mresendOtp');
                                // showLoader = true;
                                // Future.delayed(
                                //     new Duration(seconds: 4), stopLoader);
                              });
                            }
                          },
                          child: Text(
                            'Resend code',
                            style: TextStyle(color: Colors.lightGreen),
                          ),
                        ),
                        Text(_start < 10 ? '00:0$_start' : '00:$_start',
                            style: TextStyle(color: Colors.lightGreen))
                      ],
                    )),
              ],
            ),
          ),
        ));
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  void forgotOtpApi(String otpValue) {
    showLoaderDialog(context, _keyAlertDialog);
    forgotOtp(
      Resource(
        url: '${BaseUrl}mforgotOtp',
        request: forgotOtpRequestToJson(
          ForgotOtpRequest(
              deviceType: "3",
              otpUnique: widget.fpResponse.otpUnique,
              userId: "",
              language: "en",
              otp: otpValue),
        ),
      ),
    ).then((value) {
      closeLoaderDialog(_keyAlertDialog);
      if (value.status == 1) {
        Navigator.push(
            context,
            PageTransition(
                child: ChangePAsswordPage(
                  otpResponse: value,
                ),
                type: PageTransitionType.leftToRight));
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

  void otpRequestApi(String otpValue, String api) async {
    otpVerify(
      Resource(
        url: '$BaseUrl$api',
        request: otpVerifyToJson(
          OtpRequest(
              deviceType: "3",
              phoneNumber: widget.logindetail.phoneNumber,
              countryCode: widget.logindetail.countryCode,
              language: "en",
              otp: otpValue),
        ),
      ),
    ).then((value) {
      if (value.status == 1 && api == 'msignupOtpVerify') {
        Navigator.push(
            context,
            PageTransition(
                child: SignupScreen(
                  details: value.details,
                  phoneNumber: widget.logindetail.phoneNumber,
                ),
                type: PageTransitionType.upToDown));
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
}
