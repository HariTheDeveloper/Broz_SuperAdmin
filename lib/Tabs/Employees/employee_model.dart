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


Future<List<EmployeeJson>> _searchEmployeeList(
    int pageNumber, String searchData) async {
  var params = jsonEncode(<String, dynamic>{
    'pageNumber': pageNumber,
    'pageSize': 10,
    'name': searchData,
  });
  print('request params $params ** http://user.brozapp.com/api/userSearch ');
  final data =
      await http.post(Uri.parse("http://user.brozapp.com/api/userSearch"),
          headers: _defaultApiHeaders,
          body: jsonEncode(<String, dynamic>{
            'pageNumber': pageNumber,
            'pageSize': 10,
            'name': searchData,
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

class SearchEmployeeStreamModel {
  Stream<List<EmployeeJson>> stream;
  bool hasMore;
  int pageNumber;
  int totalCount;
  int pagelimit;
  String searchData;
  bool isLoading;
  bool reachedBottom;
  List<EmployeeJson> _data;
  StreamController<List<EmployeeJson>> _controller;

  SearchEmployeeStreamModel() {
    _data = List<EmployeeJson>.empty(growable: true);
    _controller = StreamController<List<EmployeeJson>>.broadcast();
    isLoading = false;
    pageNumber = 1;
    searchData = '';
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
    return _searchEmployeeList(pageNumber, searchData).then((postsData) {
      isLoading = false;
      _data.addAll(postsData);
      pageNumber += 1;
      reachedBottom = false;
      hasMore = (postsData.length >= 10) || reachedBottom;
      _controller.add(_data);
    });
  }
}
