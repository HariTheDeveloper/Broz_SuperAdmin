import 'dart:convert';

class UpdateCustomerRequest {
  int userId;

  UpdateCustomerRequest({this.userId});

  UpdateCustomerRequest.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    return data;
  }
}

class UpdateCustomerResponse {
  int httpCode;
  int status;
  String message;

  UpdateCustomerResponse({this.httpCode, this.status, this.message});

  UpdateCustomerResponse.fromJson(Map<String, dynamic> json) {
    httpCode = json['httpCode'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['httpCode'] = this.httpCode;
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

String updateCustomerRequestToJson(UpdateCustomerRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

UpdateCustomerResponse updateCustomerFromJson(String str) {
  final jsonData = json.decode(str);
  return UpdateCustomerResponse.fromJson(jsonData);
}
