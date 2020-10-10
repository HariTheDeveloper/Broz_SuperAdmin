import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

final String BaseUrl = "http://user.brozapp.com/api/";

var alertStyle = AlertStyle(
  backgroundColor: Colors.black.withOpacity(0.5),
  //animationType: AnimationType.fromTop,
  isCloseButton: false,
  isOverlayTapDismiss: true,
  descStyle: TextStyle(fontWeight: FontWeight.normal),
  animationDuration: Duration(milliseconds: 400),
  titleStyle: TextStyle(
    color: Colors.black,
  ),
);

class Constants {
  static String deviceToken =
      "d_yFWOIfg0t-jixOCLzgXi:APA91bHk8JUiwVxghrhWkdlieMRL1Dpp33WSKmy77LMgp9TO_OK5JMTRx5EfVDrzC2lYZr03cIcKdJ7PHxmrDbqmTXeVbZR6dRFberz_7D4QopP8cSfLZ31SLAXnDSWRZjcrPB0P_Gx6";
  static String deviceId = DeviceId.getID as String;
  static int userID = 0;
  static int userType = 0;
  static bool showData = true;
  static List<String> outletID;
  static int admin = 0;
  static int grocery = 1;
  static int barber = 2;
  static int maid = 3;
  static int laundry = 4;
  static int restaurant = 5;
  static int userLogs = 6;
  static int offerLogs = 7;
}
