import 'package:flutter/material.dart';

Future<void> showLoaderDialog(BuildContext context, GlobalKey key) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return new WillPopScope(
        onWillPop: () async => false,
        child: SimpleDialog(
          key: key,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.green),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> closeLoaderDialog(GlobalKey key) async {
  Navigator.of(key.currentContext).pop();
}
