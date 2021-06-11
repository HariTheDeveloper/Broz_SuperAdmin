import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as Encrypt;
import 'package:broz_admin/OrderDetail/barber_model.dart';
import 'package:broz_admin/OrderDetail/grocery_model.dart';
import 'package:broz_admin/OrderDetail/order_detail.dart';

class OrderDetailArguments {
  final OrderedService orderedService;
  final String orderID;
  final String userId;
  OrderDetailArguments({this.orderedService, this.orderID, this.userId});
}

var _defaultApiHeaders = {
  HttpHeaders.contentTypeHeader: 'application/json',
  HttpHeaders.authorizationHeader: '',
  'api-token': 'dGhpc2lzYWNvbW1vbnRva2VuXzE='
};

class Resource<T> {
  final String url;
  final String request;
  T Function(http.Response response) parse;

  Resource({this.url, this.request, this.parse});
}

enum RequestType { GET, POST, PUT }

Future<String> httpRequest(
    {RequestType requestType = RequestType.POST,
    @required Resource resource,
    bool encryptParams = true,
    bool decryptResponse = false}) async {
  var selectedLanguage = "en";
  selectedLanguage = selectedLanguage == "" ? "en" : selectedLanguage;
  var apiUrl = resource.url.contains("googleapis")
      ? resource.url
      : resource.url + "?lang=$selectedLanguage";
  printLogs('Url $apiUrl');
  final request = resource.request ?? '';
  int maxLogSize = 1000;
  for (int i = 0; i <= request.length / maxLogSize; i++) {
    int start = i * maxLogSize;
    int end = (i + 1) * maxLogSize;
    end = end > request.length ? request.length : end;
    printLogs('Request params: ${request.substring(start, end)}');
  }
  var encrypt = resource.url.contains('encrypt')
      ? encryptParams == true
          ? true
          : false
      : false;
  switch (requestType) {
    case RequestType.GET:
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: _defaultApiHeaders,
      );
      print("Response : ${response.body}");
      return decryptResponse ? response.body.decrypt : response.body;
      break;
    case RequestType.PUT:
      final response = await http.put(Uri.parse(apiUrl),
          headers: _defaultApiHeaders,
          body: encrypt ? resource.request.encrypt : resource.request);
      print("Response : ${response.body}");
      return decryptResponse ? response.body.decrypt : response.body;
      break;
    default:
      final response = await http.post(Uri.parse(apiUrl),
          headers: _defaultApiHeaders,
          body: encrypt ? resource.request.encrypt : resource.request);
      print("Response : ${response.body}");
      return decryptResponse ? response.body.decrypt : response.body;
  }
}

extension APIHelpers on String {
  get encrypt {
    if (this != null && this.isNotEmpty) {
      final key = Encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');
      final iv = Encrypt.IV.fromUtf8("1234567887654321");

      final encrypter =
          Encrypt.Encrypter(Encrypt.AES(key, mode: Encrypt.AESMode.cbc));

      final encrypted = encrypter.encrypt(this, iv: iv);
      printLogs("Encrypted Params: ${encrypted.base64}");
      return encrypted.base64;
    } else {
      return this ?? "";
    }
  }

  get decrypt {
    if (this != null && this.isNotEmpty) {
      final key = Encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');
      final iv = Encrypt.IV.fromUtf8("1234567887654321");

      final encrypter =
          Encrypt.Encrypter(Encrypt.AES(key, mode: Encrypt.AESMode.cbc));

      final encrypted = encrypter.encrypt(this, iv: iv);
      final decrypted = encrypter.decrypt(encrypted, iv: iv);

      printLogs("Decrypted Response: $decrypted");
      return decrypted;
    } else {
      return this;
    }
  }
}

void printLogs(Object object) {
  const bool isProduction = bool.fromEnvironment('dart.vm.product');
  if (!isProduction) {
    print("$object");
  }
}

Future<OrderDetailsResponse> getOrderDetails<T>(Resource<T> resource) async {
  final response = await httpRequest(resource: resource);
  return orderDetailsResponseFromJson(response);
}

Future<OrderDetailsResponse> morderDetails<T>(Resource<T> resource) async {
  final response = await httpRequest(resource: resource);
  return orderDetailsResponseFromJson(response);
}

Future<UserAppointmentDetailsResponse> appointmentDetails<T>(
    Resource<T> resource) async {
  final response =
      await httpRequest(resource: resource, requestType: RequestType.GET);
  return userAppointmentDetailsResponseFromJson(response);
}

OrderDetailsResponse orderDetailsResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return OrderDetailsResponse.fromJson(jsonData);
}
