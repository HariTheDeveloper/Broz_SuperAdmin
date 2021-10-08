import 'dart:convert';

class AppointmentDetailRequest {
  String appointmentId;
  String userId;

  AppointmentDetailRequest({this.appointmentId, this.userId});

  AppointmentDetailRequest.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointmentId'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointmentId'] = this.appointmentId;
    data['userId'] = this.userId;
    return data;
  }
}

class AppointmentDetailResponse {
  int httpCode;
  int status;
  String message;
  ResponseData responseData;
  List<String> cancelOptions;

  AppointmentDetailResponse(
      {this.httpCode,
      this.status,
      this.message,
      this.responseData,
      this.cancelOptions});

  AppointmentDetailResponse.fromJson(Map<String, dynamic> json) {
    httpCode = json['httpCode'];
    status = json['status'];
    message = json['message'];
    responseData = json['responseData'] != null
        ? new ResponseData.fromJson(json['responseData'])
        : null;
    cancelOptions = json['cancelOptions'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['httpCode'] = this.httpCode;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.responseData != null) {
      data['responseData'] = this.responseData.toJson();
    }

    data['cancelOptions'] = this.cancelOptions;
    return data;
  }
}

class ResponseData {
  String userAddress;
  String addressId;
  int serviceType;
  int appointmentId;
  String userNumber;
  int appointmentStatus;
  String statusName;
  String appointmentTime;
  String appointmentDate;
  String orderDate;
  String deliveryDate;
  String description;
  String subCategoryName;
  String childCategoryName;
  String price;
  String toPay;
  String transactionAmount;
  String totalPrice;
  String brozSilver;
  String brozGold;
  String wallet;
  String userEmail;
  String userName;
  String paymentMode;
  List<ServicesList> servicesList;
  int statusId;
  String suggestedReview;
  String trainerRating;
  int trainerId;

  ResponseData(
      {this.userAddress,
      this.addressId,
      this.serviceType,
      this.appointmentId,
      this.appointmentStatus,
      this.statusName,
      this.toPay,
      this.userName,
      this.trainerId,
      this.transactionAmount,
      this.appointmentTime,
      this.appointmentDate,
      this.userEmail,
      this.userNumber,
      this.orderDate,
      this.deliveryDate,
      this.description,
      this.subCategoryName,
      this.childCategoryName,
      this.price,
      this.totalPrice,
      this.brozSilver,
      this.brozGold,
      this.servicesList,
      this.wallet,
      this.statusId,
      this.suggestedReview,
      this.trainerRating,
      this.paymentMode});

  ResponseData.fromJson(Map<String, dynamic> json) {
    userAddress = json['userAddress'];
    addressId = json['addressId'];
    serviceType = json['serviceType'];
    userName = json['userName'];
    transactionAmount = json["transactionAmount"];
    toPay = json['toPay'];
    appointmentId = json['appointmentId'];
    appointmentStatus = json['appointmentStatus'];
    statusName = json['statusName'];
    userNumber = json['userNumber'];
    userEmail = json['userEmail'];
    appointmentTime = json['appointmentTime'];
    appointmentDate = json['appointmentDate'];
    orderDate = json['orderDate'];
    deliveryDate = json['deliveryDate'];
    description = json['description'];
    subCategoryName = json['subCategoryName'];
    childCategoryName = json['childCategoryName'];
    price = json['price'];
    totalPrice = json['totalPrice'];
    brozSilver = json['brozSilver'];
    brozGold = json['brozGold'];
    wallet = json['wallet'];
    paymentMode = json['paymentMode'];
    statusId = json['statusId'];
    trainerRating = json['trainerRating'].toString();
    trainerId = json['trainerId'];
    suggestedReview = json['suggestedReview'];
    if (json['servicesList'] != null) {
      servicesList = new List<ServicesList>.empty(growable: true);
      json['servicesList'].forEach((v) {
        servicesList.add(new ServicesList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userAddress'] = this.userAddress;
    data['addressId'] = this.addressId;
    data['serviceType'] = this.serviceType;
    data['userName'] = this.userName;
    data['appointmentId'] = this.appointmentId;
    data['appointmentStatus'] = this.appointmentStatus;
    data['statusName'] = this.statusName;
    data['appointmentTime'] = this.appointmentTime;
    data['appointmentDate'] = this.appointmentDate;
    data['orderDate'] = this.orderDate;
    data['userEmail'] = this.userEmail;
    data['userNumber'] = this.userNumber;
    data['toPay'] = this.toPay;
    data['trainerId'] = this.trainerId;
    data['transactionAmount'] = this.transactionAmount;
    data['deliveryDate'] = this.deliveryDate;
    data['description'] = this.description;
    data['subCategoryName'] = this.subCategoryName;
    data['childCategoryName'] = this.childCategoryName;
    data['price'] = this.price;
    data['totalPrice'] = this.totalPrice;
    data['brozSilver'] = this.brozSilver;
    data['brozGold'] = this.brozGold;
    data['wallet'] = this.wallet;
    data['paymentMode'] = this.paymentMode;
    data['suggestedReview'] = this.suggestedReview;
    data['trainerRating'] = this.trainerRating;
    data['statusId'] = this.statusId;
    if (this.servicesList != null) {
      data['servicesList'] = this.servicesList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServicesList {
  int id;
  String name;
  String originalPrice;
  String discountPrice;

  ServicesList({this.id, this.name, this.originalPrice, this.discountPrice});

  ServicesList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    originalPrice = json['originalPrice'];
    discountPrice = json['discountPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['originalPrice'] = this.originalPrice;
    data['discountPrice'] = this.discountPrice;
    return data;
  }
}

AppointmentDetailResponse appointmentDetailResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return AppointmentDetailResponse.fromJson(jsonData);
}

String appointmentDetailRequestToJson(AppointmentDetailRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
