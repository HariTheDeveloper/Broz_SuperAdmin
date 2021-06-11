
import 'dart:io';
import 'package:flutter/material.dart';

class SafeAreaContainer extends StatefulWidget {
  final Widget child;
  const SafeAreaContainer(
      {Key key,
      this.child,
      })
      : super(key: key);
  @override
  _SafeAreaContainerState createState() => _SafeAreaContainerState();
}

class _SafeAreaContainerState extends State<SafeAreaContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color:  Colors.white,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.only(bottom: isIphoneXorNot(context) ? 34 : 0),
        child: Material(
            color: Colors.white,
            child: widget.child),
      ),
    );
  }


}
bool isIphoneXorNot(BuildContext context) {
  return Platform.isIOS
      ? MediaQuery.of(context).size.height >= 812
          ? true
          : false
      : false;
}


