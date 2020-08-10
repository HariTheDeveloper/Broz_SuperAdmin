import 'dart:convert';

class LoginRequest {
  String phoneNumber;
  String language;
  String countryCode;
  String deviceType;
  String deviceId;
  String facebookId;
  String deviceToken;
  bool isFacebookLogin;

  LoginRequest(
      {this.phoneNumber,
      this.countryCode,
      this.deviceId,
      this.deviceToken,
      this.deviceType,
      this.facebookId,
      this.isFacebookLogin,
      this.language});

  Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
        "countryCode": countryCode,
        "deviceId": deviceId,
        "deviceToken": deviceToken,
        "deviceType": deviceType,
        "facebookId": facebookId,
        "isFacebookLogin": isFacebookLogin,
        "language": language
      };
}

class Login {
  final int status;
  final String message;
  LoginDetails details;

  Login({this.status, this.message, this.details});

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      status: json['status'],
      message: json['message'],
      details: LoginDetails.fromJson(json['detail']),
    );
  }
}

class LoginDetails {
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

  LoginDetails({
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
  });

  factory LoginDetails.fromJson(Map<String, dynamic> json) {
    return LoginDetails(
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
    );
  }
}

String loginRequestToJson(LoginRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

Login loginFromJson(String str) {
  final jsonData = json.decode(str);
  return Login.fromJson(jsonData);
}
