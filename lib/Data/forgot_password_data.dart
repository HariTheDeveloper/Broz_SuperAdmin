import 'dart:convert';

class ForgotPasswordRequest {
  final String countryCode;
  final String deviceType;
  final String language;
  final String phoneNumber;

  ForgotPasswordRequest(
      {this.countryCode, this.deviceType, this.language, this.phoneNumber});

  Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
        "countryCode": countryCode,
        "deviceType": deviceType,
        "language": language
      };
}

class ForgotPasswordResponse {
  final String otpUnique;
  final int status;
  final String userOtp;
  final String message;

  ForgotPasswordResponse(
      {this.otpUnique, this.status, this.userOtp, this.message});
  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
        status: json['status'],
        message: json['message'],
        otpUnique: json['otpUnique'],
        userOtp: json['userOtp']);
  }
}

String forgotpasswordRequestToJson(ForgotPasswordRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

ForgotPasswordResponse forgotpasswordFromJson(String str) {
  final jsonData = json.decode(str);
  return ForgotPasswordResponse.fromJson(jsonData);
}

class ForgotOtpRequest {
  final String otpUnique;
  final String deviceType;
  final String language;
  final String userId;
  final String otp;

  ForgotOtpRequest(
      {this.deviceType, this.language, this.otpUnique, this.userId, this.otp});

  Map<String, dynamic> toJson() => {
        "otpUnique": otpUnique,
        "userId": userId,
        "otp": otp,
        "deviceType": deviceType,
        "language": language
      };
}

class ForgotOtpResponse {
  final String userUnique;
  final int status;
  final String message;

  ForgotOtpResponse({this.userUnique, this.status, this.message});
  factory ForgotOtpResponse.fromJson(Map<String, dynamic> json) {
    return ForgotOtpResponse(
      status: json['status'],
      message: json['message'],
      userUnique: json['userUnique'],
    );
  }
}

String forgotOtpRequestToJson(ForgotOtpRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

ForgotOtpResponse forgotOtpFromJson(String str) {
  final jsonData = json.decode(str);
  return ForgotOtpResponse.fromJson(jsonData);
}
