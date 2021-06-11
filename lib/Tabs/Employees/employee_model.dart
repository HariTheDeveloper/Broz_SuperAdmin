import 'dart:io';

import 'package:broz_admin/List/employeeCell.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:broz_admin/Utitlity/Constants.dart';

var _defaultApiHeaders = {
  HttpHeaders.contentTypeHeader: 'application/json',
  HttpHeaders.authorizationHeader: '',
  'api-token': 'dGhpc2lzYWNvbW1vbnRva2VuXzE='
};

Future<List<EmployeeJson>> _getEmployeeList(int pageNumber) async {
  var params = jsonEncode(<String, dynamic>{
    'pageNumber': pageNumber,
    'pageSize': 10,
    'userId': Constants.userID,
    'userType': Constants.userType,
    'outletId': Constants.outletID
  });
  print('request params $params ** http://user.brozapp.com/api/UserDetails ');
  final data =
      await http.post(Uri.parse("http://user.brozapp.com/api/UserDetails"),
          headers: _defaultApiHeaders,
          body: jsonEncode(<String, dynamic>{
            'pageNumber': pageNumber,
            'pageSize': 10,
            'userId': Constants.userID,
            'userType': Constants.userType,
            'outletId': Constants.outletID
          }));

  var json = await jsonDecode(data.body);
  print("API Response:$json");
  if (json["status"] == 1) {
    final Iterable employeeList = json['responseData'];
    if (employeeList.length > 0) {
      return employeeList.map((e) => EmployeeJson.fromJson(e)).toList();
    } else {
      return List<EmployeeJson>.empty(growable: true);
    }
  }
  return List<EmployeeJson>.empty(growable: true);
}

class EmployeeStreamModel {
  Stream<List<EmployeeJson>> stream;
  bool hasMore;
  int pageNumber;
  int totalCount;
  int pagelimit;
  bool isLoading;
  bool reachedBottom;
  List<EmployeeJson> _data;
  StreamController<List<EmployeeJson>> _controller;

  EmployeeStreamModel() {
    _data = List<EmployeeJson>.empty(growable: true);
    _controller = StreamController<List<EmployeeJson>>.broadcast();
    isLoading = false;
    pageNumber = 1;
    pagelimit = 15;
    stream = _controller.stream.map((List<EmployeeJson> data) {
      return data;
    });
    hasMore = true;
    reachedBottom = false;
    if (Constants.showData) {
      refresh();
    }
  }

  Future<void> refresh() {
    return loadMore(clearCachedData: true);
  }

  Future<void> loadMore(
      {bool clearCachedData = false, bool reachesBottom = false}) {
    if (clearCachedData) {
      _data = List<EmployeeJson>.empty(growable: true);
      pageNumber = 1;
      hasMore = true;
    }
    reachedBottom = reachesBottom;
    if (isLoading || !hasMore) {
      return Future.value();
    }
    isLoading = true;
    return _getEmployeeList(pageNumber).then((postsData) {
      isLoading = false;
      _data.addAll(postsData);
      pageNumber += 1;
      reachedBottom = false;
      hasMore = (postsData.length >= 10) || reachedBottom;
      _controller.add(_data);
    });
  }
}
