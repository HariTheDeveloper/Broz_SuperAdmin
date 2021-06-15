import 'dart:io';

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
        return SafeArea(
          top: true,
          bottom: true,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "Wallet Recharge",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
                backgroundColor: Colors.green,
              ),
              bottomNavigationBar: _submitWidget(
                  recharged: (yes) {
                    recharged(yes, isDebit ?? false ? 0 : 1);
                  },
                  commentsController: commentsController,
                  walletController: walletController),
              body: WillPopScope(
                onWillPop: () {
                  return Future.value(true);
                },
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _walletAmountWidget(
                          mContext, walletController, keyboardConfig, nodeText),
                      _debitWidget(isDebit, setState, (onchanged) {
                        setState(() {
                          isDebit = onchanged;
                        });
                      }),
                      _descriptionWidget(mContext, commentsController)
                    ],
                  ),
                ),
              )),
        );
      });
    },
  );
}

_walletAmountWidget(
    BuildContext mContext,
    TextEditingController textEditingController,
    KeyboardActionsConfig keyboardConfig,
    FocusNode focusNode) {
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

_debitWidget(bool isDebit, StateSetter setState, Function(bool) onChanged) {
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
    TextEditingController commentsController}) {
  return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.green),
        onPressed: () {
          if (walletController.text.isNotEmpty &&
              (double.tryParse(walletController.text ?? "0") > 0) &&
              (commentsController.text.isNotEmpty)) recharged(true);
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
