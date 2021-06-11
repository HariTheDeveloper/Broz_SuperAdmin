import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> showReachargeWiget({
  BuildContext mContext,
  GlobalKey key,
  TextEditingController editingController,
  Function(bool) recharged,
}) {
  return showGeneralDialog(
      barrierColor: Colors.black12.withOpacity(0.7),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: WillPopScope(
              onWillPop: () {
                return Future.value(true);
              },
              child: Dialog(
                key: key,
                insetPadding: EdgeInsets.all(40.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    8.0,
                  ),
                ),
                backgroundColor: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _titleTextWidget(),
                    Divider(
                      height: 0.3,
                      color: Colors.grey,
                    ),
                    _walletAmountWidget(mContext, editingController),
                    _submitWidget(
                        recharged: (yes) {
                          recharged(yes);
                        },
                        editingController: editingController)
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 350),
      barrierDismissible: true,
      barrierLabel: '',
      context: mContext,
      pageBuilder: (context, animation1, animation2) {});
}

_titleTextWidget() {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Text(
      "Update Wallet",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

_walletAmountWidget(
    BuildContext mContext, TextEditingController textEditingController) {
  return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        Text(
          "Amount :",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Theme(
            data: Theme.of(mContext).copyWith(primaryColor: Colors.black),
            child: TextField(
              controller: textEditingController,
              keyboardType: TextInputType.number,
              maxLength: 5,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(hintText: "Enter amount here"),
            ),
          ),
        ),
      ]));
}

_submitWidget(
    {Function(bool) recharged, TextEditingController editingController}) {
  return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.green),
        onPressed: () {
          if (editingController.text.isNotEmpty &&
              (double.tryParse(editingController.text ?? "0") > 0))
            recharged(true);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Recharge",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ));
}
