import 'dart:convert';

class SignupRequest {
  final String deviceToken;
  final String userName;
  final String userEmail;
  final String language;
  final String password;
  final String countryCode;
  final String deviceType;
  final String loginType;
  final String deviceId;
  final String userType;
  final String lastName;
  final String termsCondition;
  final String referral;
  final String gender;
  final String phoneNumber;

  SignupRequest(
      {this.deviceToken,
      this.userName,
      this.userEmail,
      this.language,
      this.password,
      this.countryCode,
      this.deviceType,
      this.loginType,
      this.deviceId,
      this.userType,
      this.lastName,
      this.termsCondition,
      this.referral,
      this.gender,
      this.phoneNumber});

  Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
        "countryCode": countryCode,
        "deviceId": deviceId,
        "deviceToken": deviceToken,
        "deviceType": deviceType,
        "userName": userName,
        "userEmail": userEmail,
        "language": language,
        "password": password,
        "loginType": loginType,
        "userType": userType,
        "lastName": lastName,
        "termsCondition": termsCondition,
        "referral": referral,
        "gender": gender
      };
}

class SignupResponse {
  final int status;
  final String message;
  SignupResponseDetails details;

  SignupResponse({this.status, this.message, this.details});

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      status: json['status'],
      message: json['message'],
      details: SignupResponseDetails.fromJson(json['detail']),
    );
  }
}

class SignupResponseDetails {
  final int userId;
  final String countryCode;
  final String phoneNumber;
  final String token;
  final int userType;
  final String guest;
  final String userEmail;
  final String userName;
  final String firstName;
  final String lastName;
  final String facebookId;
  final int phoneVerify;
  final String referral_code;

  SignupResponseDetails({
    this.userType,
    this.guest,
    this.facebookId,
    this.phoneVerify,
    this.referral_code,
    this.userId,
    this.countryCode,
    this.phoneNumber,
    this.token,
    this.userEmail,
    this.userName,
    this.firstName,
    this.lastName,
  });

  factory SignupResponseDetails.fromJson(Map<String, dynamic> json) {
    return SignupResponseDetails(
      userId: json['userId'],
      countryCode: json['countryCode'],
      phoneNumber: json['phoneNumber'],
      phoneVerify: json['phoneVerify'],
      referral_code: json['referral_code'],
      token: json['token'],
      userType: json['userType'],
      userEmail: json['userEmail'],
      userName: json['userName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      guest: json['guest'],
      facebookId: json['facebookId'],
    );
  }
}

String signupRequestToJson(SignupRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

SignupResponse signupFromJson(String str) {
  final jsonData = json.decode(str);
  return SignupResponse.fromJson(jsonData);
}
