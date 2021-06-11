import 'dart:convert';

import 'package:broz_admin/OrderDetail/order_detail_model.dart';

class NewUserWalletRequest {
  String userId;
  String type;
  String pageSize;
  String pageNumber;

  NewUserWalletRequest(
      {this.userId, this.type, this.pageNumber, this.pageSize});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['type'] = this.type;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    return data;
  }
}

class NewUserWalletResponse {
  int httpCode;
  int status;
  String message;
  int totalCount;
  ResponseData responseData;

  NewUserWalletResponse(
      {this.httpCode,
      this.status,
      this.message,
      this.totalCount,
      this.responseData});

  NewUserWalletResponse.fromJson(Map<String, dynamic> json) {
    httpCode = json['httpCode'];
    status = json['status'];
    message = json['message'];
    totalCount = json['totalCount'];
    responseData = json['responseData'] != null
        ? new ResponseData.fromJson(json['responseData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['httpCode'] = this.httpCode;
    data['status'] = this.status;
    data['message'] = this.message;
    data['totalCount'] = this.totalCount;
    if (this.responseData != null) {
      data['responseData'] = this.responseData.toJson();
    }
    return data;
  }
}

class ResponseData {
  String walletAmount;
  String offerAmount;
  String totalWalletAmount;
  String description;
  String siverDescription;
  String goldDescription;
  List<WalletHistory> walletHistory;
  List<OfferDetails> offerDetails;

  ResponseData(
      {this.walletAmount,
      this.offerAmount,
      this.totalWalletAmount,
      this.description,
      this.siverDescription,
      this.goldDescription,
      this.walletHistory,
      this.offerDetails});

  ResponseData.fromJson(Map<String, dynamic> json) {
    walletAmount = json['walletAmount'];
    offerAmount = json['offerAmount'];
    totalWalletAmount = json['totalWalletAmount'];
    description = json['description'];
    siverDescription = json['siverDescription'];
    goldDescription = json['goldDescription'];
    if (json['walletHistory'] != null) {
      walletHistory = new List<WalletHistory>();
      json['walletHistory'].forEach((v) {
        walletHistory.add(new WalletHistory.fromJson(v));
      });
    }
    if (json['offerDetails'] != null) {
      offerDetails = new List<OfferDetails>();
      json['offerDetails'].forEach((v) {
        offerDetails.add(new OfferDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['walletAmount'] = this.walletAmount;
    data['offerAmount'] = this.offerAmount;
    data['totalWalletAmount'] = this.totalWalletAmount;
    data['description'] = this.description;
    data['siverDescription'] = this.siverDescription;
    data['goldDescription'] = this.goldDescription;
    if (this.walletHistory != null) {
      data['walletHistory'] =
          this.walletHistory.map((v) => v.toJson()).toList();
    }
    if (this.offerDetails != null) {
      data['offerDetails'] = this.offerDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WalletHistory {
  int id;
  int walletType;
  String amount;
  String date;
  int credit;
  int debit;
  String description;
  String outletImage;
  int serviceType;
  int walletId;

  WalletHistory(
      {this.id,
      this.walletType,
      this.amount,
      this.date,
      this.credit,
      this.debit,
      this.serviceType,
      this.walletId,
      this.description,
      this.outletImage});

  WalletHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    walletType = json['walletType'];
    amount = json['amount'];
    date = json['date'];
    credit = json['credit'];
    debit = json['debit'];
    description = json['description'];
    outletImage = json['outletImage'];
    serviceType = json['serviceType'];
    walletId = json['walletId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['walletType'] = this.walletType;
    data['amount'] = this.amount;
    data['date'] = this.date;
    data['credit'] = this.credit;
    data['debit'] = this.debit;
    data['description'] = this.description;
    data['outletImage'] = this.outletImage;
    data['serviceType'] = this.serviceType;
    data['walletId'] = this.walletId;
    return data;
  }
}

class OfferDetails {
  int id;
  String title;
  String description;
  int subscribed;
  String offerCode;
  OfferDetails(
      {this.id, this.title, this.offerCode, this.description, this.subscribed});

  OfferDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    subscribed = json['subscribed'];
    offerCode = json['offerCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['subscribed'] = this.subscribed;
    data['offerCode'] = this.offerCode;
    return data;
  }
}

NewUserWalletResponse newUserWalletResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return NewUserWalletResponse.fromJson(jsonData);
}

String newUserWalletRequestToJson(NewUserWalletRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

Future<NewUserWalletResponse> newUserWallet<T>(Resource<T> resource) async {
  final response = await httpRequest(resource: resource);
  return newUserWalletResponseFromJson(response);
}