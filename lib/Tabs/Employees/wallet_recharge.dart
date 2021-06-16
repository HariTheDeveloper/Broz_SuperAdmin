import 'dart:io';

import 'package:broz_admin/Utitlity/safe_area_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

Future<void> showReachargeWiget({
  BuildContext mContext,
  GlobalKey key,
  KeyboardActionsConfig keyboardConfig,
  FocusNode nodeText,
  bool isDebit,
  TextEditingController walletController,
  TextEditingController commentsController,
  Function(bool, int) recharged,
}) {
  return showModalBottomSheet(
    context: mContext,
    isDismissible: true,
    isScrollControlled: true,
    enableDrag: true,
    builder: (context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: _submitWidget(
                isDebit: isDebit,
                recharged: (yes) {
                  recharged(yes, isDebit ?? false ? 0 : 1);
                },
                commentsController: commentsController,
                walletController: walletController),
            body: WillPopScope(
                onWillPop: () {
                  return Future.value(true);
                },
                child: SafeArea(
                  top: true,
                  bottom: true,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: isIphoneXorNot(context)
                          ? MediaQuery.of(context).padding.top + 30
                          : MediaQuery.of(context).padding.top + 16,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _headerWidget(mContext),
                          _walletAmountWidget(mContext, walletController,
                              keyboardConfig, nodeText, (amount) {
                            if (amount.isNotEmpty)
                              setState(() {
                                isDebit = false;
                              });
                          }),
                          _debitWidget(isDebit, setState, (onchanged) {
                            setState(() {
                              isDebit = onchanged;
                            });
                          }, walletController),
                          _descriptionWidget(mContext, commentsController)
                        ],
                      ),
                    ),
                  ),
                )));
      });
    },
  );
}

_headerWidget(BuildContext context) {
  return Container(
    height: Platform.isIOS ? 50 : 80,
    child: Padding(
      padding: EdgeInsets.fromLTRB(10.0, Platform.isIOS ? 0 : 20.0, 8.0, 0.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "Update Wallet",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              splashColor: Colors.blueAccent.withOpacity(0.4),
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.clear,
                size: 24.0,
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
    ),
  );
}

_walletAmountWidget(
    BuildContext mContext,
    TextEditingController textEditingController,
    KeyboardActionsConfig keyboardConfig,
    FocusNode focusNode,
    Function(String) onChanged) {
  return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        Container(
          width: 100,
          child: Text(
            "Amount",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          ":",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Theme(
              data: Theme.of(mContext).copyWith(primaryColor: Colors.black),
              child: Platform.isAndroid
                  ? TextField(
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      maxLength: 5,
                      onChanged: onChanged,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration:
                          InputDecoration(hintText: "Enter amount here"),
                    )
                  : KeyboardActions(
                      config: keyboardConfig,
                      bottomAvoiderScrollPhysics:
                          NeverScrollableScrollPhysics(),
                      autoScroll: false,
                      disableScroll: true,
                      isDialog: false,
                      child: TextField(
                        controller: textEditingController,
                        keyboardType: TextInputType.number,
                        maxLength: 5,
                        onChanged: onChanged,
                        focusNode: focusNode,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration:
                            InputDecoration(hintText: "Enter amount here"),
                      ),
                    ),
            ),
          ),
        ),
      ]));
}

_debitWidget(bool isDebit, StateSetter setState, Function(bool) onChanged,
    TextEditingController walletController) {
  return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        Container(
          width: 100,
          child: Text(
            "Debit",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          ":",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 8),
        CupertinoSwitch(
            value: isDebit ?? false,
            onChanged: (value) {
              onChanged(value);
              if (value)
                setState(() {
                  walletController.clear();
                });
            })
      ]));
}

_descriptionWidget(
    BuildContext mcontext, TextEditingController commentsController) {
  return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 100,
              child: Text(
                "Comments",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Text(
            ":",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
              child: Container(
                height: 200,
                child: Theme(
                  data: Theme.of(mcontext).copyWith(primaryColor: Colors.black),
                  child: TextField(
                    controller: commentsController,
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.done,
                    maxLength: 200,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "Write your comments",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                    onTap: () {},
                    onSubmitted: (value) {},
                  ),
                ),
              ),
            ),
          ),
        ]),
      ));
}

_submitWidget(
    {Function(bool) recharged,
    TextEditingController walletController,
    TextEditingController commentsController,
    bool isDebit}) {
  return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.green),
        onPressed: () {
          if (isDebit) {
            if ((commentsController.text.isNotEmpty)) recharged(true);
          } else {
            if (walletController.text.isNotEmpty &&
                (double.tryParse(walletController.text ?? "0") > 0) &&
                (commentsController.text.isNotEmpty)) recharged(true);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Recharge",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ));
}
