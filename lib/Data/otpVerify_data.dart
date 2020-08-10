import 'dart:convert';

class OtpRequest {
  String phoneNumber;
  String language;
  String countryCode;
  String deviceType;
  String otp;

  OtpRequest(
      {this.phoneNumber,
      this.countryCode,
      this.otp,
      this.deviceType,
      this.language});

  Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
        "countryCode": countryCode,
        "otp": otp,
        "deviceType": deviceType,
        "language": language
      };
}

class OtpVerify {
  final int status;
  final String message;
  OtpVerifyDetails details;

  OtpVerify({this.status, this.message, this.details});

  factory OtpVerify.fromJson(Map<String, dynamic> json) {
    return OtpVerify(
      status: json['status'],
      message: json['message'],
      details: json['detail'] != null
          ? OtpVerifyDetails.fromJson(json['detail'])
          : null,
    );
  }
}

class OtpVerifyDetails {
  final int userId;
  final String countryCode;
  final String phoneNumber;
  final String token;
  final int isNewUser;
  final String userEmail;
  final String userName;
  final String firstName;
  final String lastName;
  final String userOtp;
  final int isVerified;

  OtpVerifyDetails({
    this.userId,
    this.countryCode,
    this.phoneNumber,
    this.token,
    this.isNewUser,
    this.userEmail,
    this.userName,
    this.firstName,
    this.lastName,
    this.userOtp,
    this.isVerified,
  });

  factory OtpVerifyDetails.fromJson(Map<String, dynamic> json) {
    return OtpVerifyDetails(
        userId: json['userId'],
        countryCode: json['countryCode'],
        phoneNumber: json['phoneNumber'],
        token: json['token'],
        isNewUser: json['isNewUser'],
        userEmail: json['userEmail'],
        userName: json['userName'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        userOtp: json['userOtp'],
        isVerified: json['isVerified']);
  }
}

String otpVerifyToJson(OtpRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

OtpVerify otpVerifyFromJson(String str) {
  final jsonData = json.decode(str);
  return OtpVerify.fromJson(jsonData);
}
