import 'dart:convert';

class OrderDetailsRequest {
  String orderId;
  String userId;
  String language;

  OrderDetailsRequest({this.orderId, this.userId, this.language});

  OrderDetailsRequest.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    userId = json['userId'];
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['userId'] = this.userId;
    data['language'] = this.language;
    return data;
  }
}

class ScheduleOrderDetailsRequest {
  String orderId;
  String userId;
  String language;

  ScheduleOrderDetailsRequest({this.orderId, this.userId, this.language});

  ScheduleOrderDetailsRequest.fromJson(Map<String, dynamic> json) {
    orderId = json['scheduleId'];
    userId = json['userId'];
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scheduleId'] = this.orderId;
    data['userId'] = this.userId;
    data['language'] = this.language;
    return data;
  }
}

class OrderDetailsResponse {
  int status;
  String message;
  List<OrderProductList> orderProductList;
  DeliveryDetails deliveryDetails;
  OrderData orderData;
  ReturnReasons returnReasons;
  int lastState;
  List<TrackData> trackData;
  List<MobReturnReasons> mobReturnReasons;
  Reviews reviews;
  String orderIdEncrypted;
  String adminPhone;

  OrderDetailsResponse(
      {this.status,
      this.message,
      this.orderProductList,
      this.deliveryDetails,
      this.orderData,
      this.returnReasons,
      this.lastState,
      this.trackData,
      this.mobReturnReasons,
      this.reviews,
      this.orderIdEncrypted,
      this.adminPhone});

  OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['orderProductList'] != null) {
      orderProductList = new List<OrderProductList>();
      json['orderProductList'].forEach((v) {
        orderProductList.add(new OrderProductList.fromJson(v));
      });
    }
    deliveryDetails = json['deliveryDetails'] != null
        ? new DeliveryDetails.fromJson(json['deliveryDetails'])
        : null;
    orderData = json['orderData'] != null
        ? new OrderData.fromJson(json['orderData'])
        : null;
    returnReasons = json['return_reasons'] != null
        ? new ReturnReasons.fromJson(json['return_reasons'])
        : null;
    lastState = json['lastState'];
    if (json['trackData'] != null) {
      trackData = new List<TrackData>();
      json['trackData'].forEach((v) {
        trackData.add(new TrackData.fromJson(v));
      });
    }
    if (json['mob_return_reasons'] != null) {
      mobReturnReasons = new List<MobReturnReasons>();
      json['mob_return_reasons'].forEach((v) {
        mobReturnReasons.add(new MobReturnReasons.fromJson(v));
      });
    }
    reviews =
        json['reviews'] != null ? new Reviews.fromJson(json['reviews']) : null;
    orderIdEncrypted = json['order_id_encrypted'];
    adminPhone = json['adminPhone'];
  }
}

class OrderProductList {
  int id;
  List<String> productImage;
  List<String> productInfoImage;
  List<String> productZoomImage;
  String description;
  int productId;
  String discountPrice;
  int itemOffer;
  String deliveryCharge;
  int serviceTax;
  int orderId;
  String replacement;
  int packedStage;
  int adjustShow;
  int orderUnit;
  String invoiceId;
  String productName;
  String couponAmount;
  String title;
  String unitCode;
  String orderKeyFormated;
  String weight;
  String invoicePdf;
  String barCode;
  int subCategory;
  String totalAmount;
  int adjustmentWeight;
  int adjust;
  double netWeight;

  OrderProductList(
      {this.id,
      this.productImage,
      this.productInfoImage,
      this.productZoomImage,
      this.description,
      this.productId,
      this.discountPrice,
      this.itemOffer,
      this.deliveryCharge,
      this.serviceTax,
      this.orderId,
      this.replacement,
      this.packedStage,
      this.adjustShow,
      this.orderUnit,
      this.invoiceId,
      this.productName,
      this.couponAmount,
      this.title,
      this.unitCode,
      this.orderKeyFormated,
      this.weight,
      this.invoicePdf,
      this.barCode,
      this.subCategory,
      this.totalAmount,
      this.adjustmentWeight,
      this.adjust,
      this.netWeight});

  OrderProductList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productImage = json['productImage'].cast<String>();
    productInfoImage = json['productInfoImage'].cast<String>();
    productZoomImage = json['productZoomImage'].cast<String>();
    description = json['description'];
    productId = json['productId'];
    discountPrice = json['discountPrice'];
    itemOffer = json['itemOffer'];
    deliveryCharge = json['deliveryCharge'];
    serviceTax = json['serviceTax'];
    orderId = json['orderId'];
    replacement = json['replacement'];
    packedStage = json['packedStage'];
    adjustShow = json['adjust_show'];
    orderUnit = json['orderUnit'];
    invoiceId = json['invoiceId'];
    productName = json['productName'];
    couponAmount = json['couponAmount'];
    title = json['title'];
    unitCode = json['unitCode'];
    orderKeyFormated = json['orderKeyFormated'];
    weight = json['weight'];
    invoicePdf = json['invoicePdf'];
    barCode = json['barCode'];
    subCategory = json['subCategory'];
    totalAmount = json['totalAmount'];
    adjustmentWeight = json['adjustmentWeight'];
    adjust = json['adjust'];
    netWeight = double.tryParse(json['adjust'].toString() ?? "0") ?? 0;
  }
}

class DeliveryDetails {
  String driverId;
  String deliveryInstructions;
  String customerName;
  String mobileNumber;
  String driverName;
  String userContactAddress;
  int paymentGatewayId;
  String name;
  String totalAmount;
  String deliveryCharge;
  int serviceTax;
  String startTime;
  String endTime;
  String createdDate;
  String deliveryDate;
  String scheduleDate;
  int orderType;
  String contactAddress;
  String couponAmount;
  String email;
  double subTotal;
  int taxAmount;
  String userLatitude;
  String userLongitude;
  String outletLatitude;
  String outletLongitude;
  int userId;
  String driverRating;
  String orderRating;
  String replace;
  int swipeMachineRequired;
  String walletAmountUsed;
  String landMark;
  String doorNo;
  String oldSubtotal;

  DeliveryDetails(
      {this.driverId,
      this.deliveryInstructions,
      this.customerName,
      this.mobileNumber,
      this.driverName,
      this.userContactAddress,
      this.paymentGatewayId,
      this.name,
      this.totalAmount,
      this.deliveryCharge,
      this.scheduleDate,
      this.serviceTax,
      this.startTime,
      this.endTime,
      this.createdDate,
      this.deliveryDate,
      this.orderType,
      this.contactAddress,
      this.couponAmount,
      this.email,
      this.subTotal,
      this.taxAmount,
      this.userLatitude,
      this.userLongitude,
      this.outletLatitude,
      this.outletLongitude,
      this.userId,
      this.driverRating,
      this.orderRating,
      this.replace,
      this.swipeMachineRequired,
      this.walletAmountUsed,
      this.landMark,
      this.doorNo,
      this.oldSubtotal});

  DeliveryDetails.fromJson(Map<String, dynamic> json) {
    driverId = json['driverId'].toString();
    deliveryInstructions = json['deliveryInstructions'];
    customerName = json['customerName'];
    mobileNumber = json['mobileNumber'];
    driverName = json['driverName'];
    userContactAddress = json['userContactAddress'];
    paymentGatewayId = json['paymentGatewayId'];
    name = json['name'];
    totalAmount = json['totalAmount'];
    deliveryCharge = json['deliveryCharge'];
    serviceTax = json['serviceTax'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    createdDate = json['createdDate'];
    deliveryDate = json['deliveryDate'];
    orderType = json['orderType'];
    contactAddress = json['contactAddress'];
    couponAmount = json['couponAmount'].toString() ?? "0.0";
    email = json['email'];
    subTotal = double.tryParse(json['subTotal'].toString()) ?? 0.0;
    taxAmount = json['taxAmount'];
    userLatitude = json['userLatitude'];
    userLongitude = json['userLongitude'];
    outletLatitude = json['outletLatitude'];
    outletLongitude = json['outletLongitude'];
    userId = json['userId'];
    driverRating = json['driverRating'].toString();
    orderRating = json['orderRating'].toString();
    replace = json['replace'];
    swipeMachineRequired = json['swipeMachineRequired'];
    walletAmountUsed = json['walletAmountUsed'];
    landMark = json['landMark'].toString();
    doorNo = json['doorNo'].toString();
    oldSubtotal = json['oldSubtotal'];
    scheduleDate = json['scheduleDate'] ?? "";
  }
}

class OrderData {
  int orderId;
  int orderQuantity;
  String orderComments;
  int salesFleetId;
  String salesFleetName;
  String outletName;
  String vendorLogo;
  String outletAddress;
  String contactEmail;
  String createdDate;
  int orderStatus;
  String name;
  String paymentGatewayName;
  int outletId;
  int vendorId;
  String orderKeyFormated;
  String invoiceId;
  String startTime;
  String endTime;
  String deliveryAddress;
  int actionType;
  String action;

  OrderData(
      {this.orderId,
      this.orderQuantity,
      this.orderComments,
      this.salesFleetId,
      this.salesFleetName,
      this.outletName,
      this.vendorLogo,
      this.outletAddress,
      this.contactEmail,
      this.createdDate,
      this.orderStatus,
      this.name,
      this.paymentGatewayName,
      this.outletId,
      this.vendorId,
      this.orderKeyFormated,
      this.invoiceId,
      this.startTime,
      this.endTime,
      this.deliveryAddress,
      this.actionType,
      this.action});

  OrderData.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderQuantity = json['orderQuantity'];
    orderComments = json['orderComments'];
    salesFleetId = json['salesFleetId'];
    salesFleetName = json['salesFleetName'];
    outletName = json['outletName'];
    vendorLogo = json['vendorLogo'];
    outletAddress = json['outletAddress'];
    contactEmail = json['contactEmail'];
    createdDate = json['createdDate'];
    orderStatus = json['orderStatus'];
    name = json['name'];
    paymentGatewayName = json['paymentGatewayName'];
    outletId = json['outletId'];
    vendorId = json['vendorId'];
    orderKeyFormated = json['orderKeyFormated'];
    invoiceId = json['invoiceId'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    deliveryAddress = json['deliveryAddress'];
    actionType = json['actionType'];
    action = json['action'];
  }
}

class ReturnReasons {
  String s9;
  String s10;
  String s11;
  String s12;
  String s13;
  String s14;

  ReturnReasons({this.s9, this.s10, this.s11, this.s12, this.s13, this.s14});

  ReturnReasons.fromJson(Map<String, dynamic> json) {
    s9 = json['9'];
    s10 = json['10'];
    s11 = json['11'];
    s12 = json['12'];
    s13 = json['13'];
    s14 = json['14'];
  }
}

class TrackData {
  String text;
  String process;
  String orderComments;
  String date;

  TrackData({this.text, this.process, this.orderComments, this.date});

  TrackData.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    process = json['process'];
    orderComments =
        json['orderComments'] != null ? json['orderComments'] : null;
    date = json['date'];
  }
}

class MobReturnReasons {
  int id;
  String name;

  MobReturnReasons({this.id, this.name});

  MobReturnReasons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Reviews {
  int reviewstatus;

  Reviews({this.reviewstatus});

  Reviews.fromJson(Map<String, dynamic> json) {
    reviewstatus = json['reviewstatus'];
  }
}

OrderDetailsResponse orderDetailsResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return OrderDetailsResponse.fromJson(jsonData);
}

String orderDetailsRequestToJson(OrderDetailsRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

String scheduleorderDetailsRequestToJson(ScheduleOrderDetailsRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
