import 'dart:convert';

import 'package:broz_admin/OrderDetail/order_detail_model.dart';

class AddNewUserWalletRequest {
  String userId;
  String amount;
  int walletType;
  String transactionId;
  int credit;
  String description;
  String managerNumber;

  AddNewUserWalletRequest(
      {this.userId,
      this.amount,
      this.walletType,
      this.description,
      this.managerNumber,
      this.transactionId,
      this.credit});

  AddNewUserWalletRequest.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    amount = json['amount'];
    walletType = json['walletType'];
    managerNumber = json['managerNumber'];
    description = json['description'];
    transactionId = json['transactionId'];
    credit = json['credit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['amount'] = this.amount;
    data['walletType'] = this.walletType;
    data['managerNumber'] = this.managerNumber;
    data['description'] = this.description;
    data['transactionId'] = this.transactionId;
    data['credit'] = this.credit;
    return data;
  }
}

class AddNewUserWalletResponse {
  int httpCode;
  int status;
  String message;

  AddNewUserWalletResponse({this.httpCode, this.status, this.message});

  AddNewUserWalletResponse.fromJson(Map<String, dynamic> json) {
    httpCode = json['httpCode'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['httpCode'] = this.httpCode;
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

String newAddUserWalletRequestToJson(AddNewUserWalletRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

AddNewUserWalletResponse newAddUserWalletResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return AddNewUserWalletResponse.fromJson(jsonData);
}

Future<AddNewUserWalletResponse> addNewUserWallet<T>(
    Resource<T> resource) async {
  final response = await httpRequest(resource: resource);
  return newAddUserWalletResponseFromJson(response);
}
