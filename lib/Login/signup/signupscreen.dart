import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:push_notification/Data/otpVerify_data.dart';
import 'package:push_notification/Data/signup_data.dart';
import 'package:push_notification/Tabs/allservices_tab.dart';
import 'package:push_notification/Utitlity/Constants.dart';
import 'package:push_notification/WebService/webservice.dart';
import 'package:push_notification/app_loader.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  final OtpVerifyDetails details;
  final String phoneNumber;
  SignupScreen({Key key, this.details, this.phoneNumber}) : super(key: key);
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<State> _keyAlertDialog = GlobalKey<State>();
  TextEditingController textEditingController = TextEditingController();
  List<String> placeholderArray = [
    'Phone Number',
    'Email',
    'First Name',
    'Last Name',
    'Password'
  ];
  List<String> textFieldValues = ["", "", "", "", ""];
  bool _showHidePassword = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      textFieldValues[0] = widget.phoneNumber.toString();
      textEditingController.text = textFieldValues[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Signup"),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: <Widget>[signupView(context), bottomView(context)],
        ));
  }

  Widget signupView(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 0),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                titleView(context),
                SizedBox(height: 20),
                formView(context),
                SizedBox(height: 20),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget titleView(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      height: 100,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text("One more step to join with us",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        )),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              Icons.account_box,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }

  void signupApi() async {
    if (textFieldValues[0].isEmpty) {
      _showAlert("Please enter phone number");
    } else if (textFieldValues[1].isEmpty) {
      _showAlert("Please enter email id");
    } else if (textFieldValues[2].isEmpty) {
      _showAlert("Please enter first name");
    } else if (textFieldValues[3].isEmpty) {
      _showAlert("Please enter last name");
    } else if (textFieldValues[4].isEmpty) {
      _showAlert("Please enter password");
    } else {
      showLoaderDialog(context, _keyAlertDialog);
      signupNew(Resource(
        url: '${BaseUrl}msignupNew',
        request: signupRequestToJson(
          SignupRequest(
              deviceId: Constants.deviceId,
              deviceToken: Constants.deviceToken,
              userName: textFieldValues[2],
              lastName: textFieldValues[3],
              phoneNumber: textFieldValues[0],
              userEmail: textFieldValues[1],
              language: "en",
              password: textFieldValues[4],
              countryCode: widget.details.countryCode,
              deviceType: "3",
              loginType: "2",
              userType: "3",
              termsCondition: "1",
              referral: "",
              gender: "M"),
        ),
      )).then((value) {
        closeLoaderDialog(_keyAlertDialog);
        if (value.status == 1) {
          moveToAllServices(value.details.userId);
        } else {
          _showAlert(value.message);
        }
      });
    }
  }

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

  Widget formView(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return index == placeholderArray.length - 1
            ? Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Theme(
                  data: Theme.of(context).copyWith(primaryColor: Colors.black),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        textFieldValues[index] = value;
                      });
                    },
                    obscureText: index == placeholderArray.length - 1
                        ? _showHidePassword
                        : false,
                    decoration: InputDecoration(
                        labelText: placeholderArray[index],
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
                height: 70,
              )
            : Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Theme(
                  data: Theme.of(context).copyWith(primaryColor: Colors.black),
                  child: TextField(
                    controller: index == 0 ? textEditingController : null,
                    onChanged: (value) {
                      setState(() {
                        textFieldValues[index] = value;
                      });
                    },
                    decoration: InputDecoration(
                        labelText: placeholderArray[index],
                        labelStyle: TextStyle(
                          color: Colors.black,
                        )),
                  ),
                ),
                height: 70,
              );
      },
      itemCount: placeholderArray.length,
    );
  }

  Widget bottomView(BuildContext context) {
    //print("Bottom: ${MediaQuery.of(context).size.height >= 812 ? 34 : 0}");
    return Container(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height >= 812 ? 34 : 0),
      //height: 100,
      child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(20),
              child: Text.rich(TextSpan(children: [
                TextSpan(
                    text: "By clicking you agree to our terms and conditions"),
                TextSpan(text: " "),
                TextSpan(
                  text: "Terms and Conditions",
                  style: TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      print("Terms clicked");
                    },
                )
              ]))),
          SizedBox(
            width: 5,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                print("Given Values : $textFieldValues");
                signupApi();
              },
              child: Container(
                height: 50,
                color: Colors.green,
                child: Center(
                  child: Text(
                    "Submit".toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void moveToAllServices(int userID) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('loginStatus', true);
    prefs.setInt('loginStatus', userID);
    Constants.userID = userID;
    Navigator.push(
        context,
        PageTransition(
            child: AllServicesPage(), type: PageTransitionType.scale));
  }
}
