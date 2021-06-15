import 'dart:convert';

class ResetPasswordRequest {
  String phoneNumber;
  String countryCode;
  String deviceType;
  String language;

  ResetPasswordRequest(
      {this.phoneNumber, this.countryCode, this.deviceType, this.language});

  ResetPasswordRequest.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    countryCode = json['countryCode'];
    deviceType = json['deviceType'];
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    data['countryCode'] = this.countryCode;
    data['deviceType'] = this.deviceType;
    data['language'] = this.language;
    return data;
  }
}


class ResetPasswordResponse {
  int status;
  String message;

  ResetPasswordResponse({this.status, this.message});

  ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

String resetPasswordRequestToJson(ResetPasswordRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

ResetPasswordResponse resetPasswordFromJson(String str) {
  final jsonData = json.decode(str);
  return ResetPasswordResponse.fromJson(jsonData);
}