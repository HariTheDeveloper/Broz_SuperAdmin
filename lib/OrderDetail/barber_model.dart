import 'dart:convert';

class UserAppointmentDetailsRequest {
  String groupId;

  UserAppointmentDetailsRequest({this.groupId});

  Map<String, dynamic> toJson() => {"groupId": groupId};
}

class UserAppointmentDetailsResponse {
  int httpCode;
  int status;
  String message;
  ResponseData responseData;
  String apiToken;
  List<String> cancelOptions;

  UserAppointmentDetailsResponse(
      {this.httpCode,
      this.status,
      this.message,
      this.responseData,
      this.apiToken,
      this.cancelOptions});

  UserAppointmentDetailsResponse.fromJson(Map<String, dynamic> json) {
    httpCode = json['httpCode'];
    status = json['status'];
    message = json['message'];
    responseData = json['responseData'] != null
        ? new ResponseData.fromJson(json['responseData'])
        : null;
    apiToken = json['api-token'];
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
    data['api-token'] = this.apiToken;
    data['cancelOptions'] = this.cancelOptions;
    return data;
  }
}

class ResponseData {
  String userAddress;
  String addressId;
  int serviceType;
  String appointmentDate;
  int appointmentId;
  int appointmentStatus;
  String appointmentTime;
  List<Services> services;
  String totalCost;
  String brozSilver;
  String brozGold;
  String wallet;
  String paymentMode;
  String description;
  String totalDuration;
  Client client;
  Outlet outlet;
  String statusName;
  

  ResponseData(
      {this.userAddress,
      this.addressId,
      this.serviceType,
      this.appointmentDate,
      this.appointmentId,
      this.appointmentStatus,
      this.appointmentTime,
      this.services,
      this.statusName,
      this.totalCost,
      this.brozSilver,
      this.brozGold,
      this.wallet,
      this.paymentMode,
      this.description,
      this.totalDuration,
      this.client,
      this.outlet});

  ResponseData.fromJson(Map<String, dynamic> json) {
    userAddress = json['userAddress'];
    addressId = json['addressId'].toString() ?? "";
    serviceType = json['serviceType'];
    appointmentDate = json['appointmentDate'];
    appointmentId = json['appointmentId'];
    appointmentStatus = json['appointmentStatus'];
    appointmentTime = json['appointmentTime'];
    statusName = json['statusName'];
    if (json['services'] != null) {
      services = new List<Services>();
      json['services'].forEach((v) {
        services.add(new Services.fromJson(v));
      });
    }
    totalCost = json['totalCost'];
    brozSilver = json['brozSilver'];
    brozGold = json['brozGold'];
    wallet = json['wallet'];
    paymentMode = json['paymentMode'];
    description = json['description'];
    totalDuration = json['totalDuration'];
    client =
        json['client'] != null ? new Client.fromJson(json['client']) : null;
    outlet =
        json['outlet'] != null ? new Outlet.fromJson(json['outlet']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userAddress'] = this.userAddress;
    data['addressId'] = this.addressId;
    data['serviceType'] = this.serviceType;
    data['appointmentDate'] = this.appointmentDate;
    data['appointmentId'] = this.appointmentId;
    data['appointmentStatus'] = this.appointmentStatus;
    data['appointmentTime'] = this.appointmentTime;
    if (this.services != null) {
      data['services'] = this.services.map((v) => v.toJson()).toList();
    }
    data['totalCost'] = this.totalCost;
    data['brozSilver'] = this.brozSilver;
    data['brozGold'] = this.brozGold;
    data['wallet'] = this.wallet;
    data['paymentMode'] = this.paymentMode;
    data['description'] = this.description;
    data['statusName'] = this.statusName;
    data['totalDuration'] = this.totalDuration;
    if (this.client != null) {
      data['client'] = this.client.toJson();
    }
    if (this.outlet != null) {
      data['outlet'] = this.outlet.toJson();
    }
    return data;
  }
}

class Services {
  int id;
  String startTime;
  String duration;
  String serviceName;
  String categoryName;
  String staff;
  String cost;
  String itemCount;

  Services(
      {this.id,
      this.startTime,
      this.duration,
      this.serviceName,
      this.categoryName,
      this.staff,
      this.itemCount,
      this.cost});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemCount = "${json['itemCount'] ?? ""}";
    startTime = json['startTime'];
    duration = json['duration'];
    serviceName = json['serviceName'];
    categoryName = json['categoryName'];
    staff = json['staff'].toString();
    cost = json['cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['startTime'] = this.startTime;
    data['duration'] = this.duration;
    data['serviceName'] = this.serviceName;
    data['categoryName'] = this.categoryName;
    data['staff'] = this.staff;
    data['cost'] = this.cost;
    data['itemCount'] = this.itemCount;
    return data;
  }
}

class Client {
  int id;
  String name;
  String email;
  String phoneNumber;

  Client({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
  });

  Client.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;

    return data;
  }
}

class PastAppointments {
  String appointmentDate;
  List<Services> services;
  String totalCost;
  String wallet;
  String totalDuration;

  PastAppointments(
      {this.appointmentDate,
      this.services,
      this.totalCost,
      this.wallet,
      this.totalDuration});

  PastAppointments.fromJson(Map<String, dynamic> json) {
    appointmentDate = json['appointmentDate'];
    if (json['services'] != null) {
      services = new List<Services>();
      json['services'].forEach((v) {
        services.add(new Services.fromJson(v));
      });
    }
    totalCost = json['totalCost'];
    wallet = json['wallet'];
    totalDuration = json['totalDuration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointmentDate'] = this.appointmentDate;
    if (this.services != null) {
      data['services'] = this.services.map((v) => v.toJson()).toList();
    }
    data['totalCost'] = this.totalCost;
    data['wallet'] = this.wallet;
    data['totalDuration'] = this.totalDuration;
    return data;
  }
}

class Outlet {
  int id;
  int vendorId;
  String name;
  String address;
  String latitude;
  String longitude;
  List<String> image;

  Outlet(
      {this.id,
      this.vendorId,
      this.name,
      this.address,
      this.latitude,
      this.longitude,
      this.image});

  Outlet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendorId'];
    name = json['name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    image = json['image'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendorId'] = this.vendorId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['image'] = this.image;
    return data;
  }
}

UserAppointmentDetailsResponse userAppointmentDetailsResponseFromJson(
    String str) {
  final jsonData = json.decode(str);
  return UserAppointmentDetailsResponse.fromJson(jsonData);
}

String userAppointmentDetailsRequestToJson(UserAppointmentDetailsRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
