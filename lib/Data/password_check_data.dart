import 'dart:convert';

class CheckPasswordRequest {
  String phoneNumber;
  String userPassword;
  String language;
  String countryCode;
  String deviceType;
  String deviceId;
  int userId;
  String deviceToken;

  CheckPasswordRequest(
      {this.phoneNumber,
      this.userPassword,
      this.countryCode,
      this.deviceId,
      this.deviceToken,
      this.deviceType,
      this.userId,
      this.language});

  Map<String, dynamic> toJson() => {
        "phone": phoneNumber,
        "countryCode": countryCode,
        "deviceId": deviceId,
        "deviceToken": deviceToken,
        "deviceType": deviceType,
        "userId": userId,
        "password": userPassword,
        "language": language
      };
}

class CheckPasswordResponse {
  final int status;
  final String message;
  PasswordDetails details;

  CheckPasswordResponse({this.status, this.message, this.details});

  factory CheckPasswordResponse.fromJson(Map<String, dynamic> json) {
    return CheckPasswordResponse(
      status: json['status'],
      message: json['message'],
      details: json['responseData'] != null
          ? PasswordDetails.fromJson(json['responseData'])
          : null,
    );
  }
}

class PasswordDetails {
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
  final int userType;
  List<UserAddress> userAddress;
  List<String> outletId;
  final String editPermission;

  PasswordDetails(
      {this.userId,
      this.countryCode,
      this.phoneNumber,
      this.token,
      this.isNewUser,
      this.userEmail,
      this.userName,
      this.firstName,
      this.lastName,
      this.userOtp,
      this.userType,
      this.editPermission,
      this.outletId,
      this.userAddress});

  factory PasswordDetails.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      final Iterable addressList = json['userAddress'];
      final Iterable outletId = json['outletId'];
      // print("Outlet ID: $outletId");
      return PasswordDetails(
          userId: json['id'],
          countryCode: json['countryCode'],
          phoneNumber: json['phoneNumber'],
          token: json['token'],
          isNewUser: json['isNewUser'],
          userEmail: json['userEmail'],
          userName: json['userName'],
          firstName: json['firstName'],
          lastName: json['lastName'],
          userOtp: json['userOtp'],
          userType: json['userType'],
          editPermission: json['editPermission'].toString(),
          outletId: outletId != null
              ? outletId.map((el) => el.toString()).toList()
              : null,
          userAddress: addressList != null
              ? addressList.map((e) => UserAddress.fromJson(e)).toList()
              : null);
    } else
      return null;
  }
}

class UserAddress {
  String address;
  String latitude;
  String longitude;
  int address_type;
  int user_id;
  int address_id;
  String land_mark;
  String home_no;
  String created_date;
  String modified_date;
  String active_status;
  String type_text;
  int id;

  UserAddress(
      {this.active_status,
      this.address,
      this.address_id,
      this.address_type,
      this.created_date,
      this.home_no,
      this.id,
      this.land_mark,
      this.latitude,
      this.longitude,
      this.modified_date,
      this.type_text,
      this.user_id});

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      active_status: json['active_status'],
      address: json['address'],
      address_id: json['address_id'],
      address_type: json['address_type'],
      created_date: json['created_date'],
      home_no: json['home_no'],
      id: json['id'],
      land_mark: json['land_mark'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      modified_date: json['modified_date'],
      type_text: json['type_text'],
      user_id: json['user_id'],
    );
  }
}

String checkPasswordRequestToJson(CheckPasswordRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

CheckPasswordResponse checkPasswordFromJson(String str) {
  final jsonData = json.decode(str);
  return CheckPasswordResponse.fromJson(jsonData);
}

class ChangePasswordRequest {
  String newPassword;
  String retypePassword;
  String language;
  String userUnique;
  String deviceType;
  String deviceId;
  String userId;
  String deviceToken;

  ChangePasswordRequest(
      {this.newPassword,
      this.retypePassword,
      this.userUnique,
      this.deviceId,
      this.deviceToken,
      this.deviceType,
      this.userId,
      this.language});

  Map<String, dynamic> toJson() => {
        "newPassword": newPassword,
        "userUnique": userUnique,
        "deviceId": deviceId,
        "deviceToken": deviceToken,
        "deviceType": deviceType,
        "userId": userId,
        "retypePassword": retypePassword,
        "language": language
      };
}

String changePasswordRequestToJson(ChangePasswordRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
