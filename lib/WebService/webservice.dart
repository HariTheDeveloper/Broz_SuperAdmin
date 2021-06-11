import 'dart:io';

import 'package:broz_admin/Data/forgot_password_data.dart';
import 'package:broz_admin/Data/login_data.dart';
import 'package:broz_admin/Data/otpVerify_data.dart';
import 'package:broz_admin/Data/password_check_data.dart';
import 'package:broz_admin/Data/signup_data.dart';
import 'package:broz_admin/Data/update_customer_data.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Resource<T> {
  final String url;
  final String request;
  T Function(Response response) parse;

  Resource({this.url, this.request, this.parse});
}

Future<Login> loginDetails<T>(Resource<T> resource) async {
  print('request params ${resource.request} ** ${resource.url}');
  final response = await http.post((Uri.parse(resource.url)),
      headers: _defaultApiHeaders, body: resource.request);
  print("Response body: ${response.body}");
  return loginFromJson(response.body);
}

Future<CheckPasswordResponse> passwordCheckDetails<T>(
    Resource<T> resource) async {
  print('request params ${resource.request} ** ${resource.url}');
  final response = await http.post(Uri.parse(resource.url),
      headers: _defaultApiHeaders, body: resource.request);
  print("Response body: ${response.body}");
  return checkPasswordFromJson(response.body);
}

Future<OtpVerify> otpVerify<T>(Resource<T> resource) async {
  print('request params ${resource.request} ** ${resource.url}');
  final response = await http.post(Uri.parse(resource.url),
      headers: _defaultApiHeaders, body: resource.request);
  print("Response body: ${response.body}");
  return otpVerifyFromJson(response.body);
}

Future<SignupResponse> signupNew<T>(Resource<T> resource) async {
  print('request params ${resource.request} ** ${resource.url}');
  final response = await http.post(Uri.parse(resource.url),
      headers: _defaultApiHeaders, body: resource.request);
  print("Response body: ${response.body}");
  return signupFromJson(response.body);
}

Future<ForgotPasswordResponse> forgotPassword<T>(Resource<T> resource) async {
  print('request params ${resource.request} ** ${resource.url}');
  final response = await http.post(Uri.parse(resource.url),
      headers: _defaultApiHeaders, body: resource.request);
  print("Response body: ${response.body}");
  return forgotpasswordFromJson(response.body);
}

Future<UpdateCustomerResponse> updateCustomer<T>(Resource<T> resource) async {
  print('request params ${resource.request} ** ${resource.url}');
  final response = await http.post(Uri.parse(resource.url),
      headers: _defaultApiHeaders, body: resource.request);
  print("Response body: ${response.body}");
  return updateCustomerFromJson(response.body);
}

Future<ForgotOtpResponse> forgotOtp<T>(Resource<T> resource) async {
  print('request params ${resource.request} ** ${resource.url}');
  final response = await http.post(Uri.parse(resource.url),
      headers: _defaultApiHeaders, body: resource.request);
  print("Response body: ${response.body}");
  return forgotOtpFromJson(response.body);
}

Future<CheckPasswordResponse> passwordChange<T>(Resource<T> resource) async {
  print('request params ${resource.request} ** ${resource.url}');
  final response = await http.post(Uri.parse(resource.url),
      headers: _defaultApiHeaders, body: resource.request);
  print("Response body: ${response.body}");
  return checkPasswordFromJson(response.body);
}

var _defaultApiHeaders = {
  HttpHeaders.contentTypeHeader: 'application/json',
  HttpHeaders.authorizationHeader: '',
  'api-token': 'dGhpc2lzYWNvbW1vbnRva2VuXzE='
};
