import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:push_notification/Data/user_logs_data.dart';
import 'dart:convert';
import 'dart:io';

import 'package:push_notification/Utitlity/Constants.dart';

var _defaultApiHeaders = {
  HttpHeaders.contentTypeHeader: 'application/json',
  HttpHeaders.authorizationHeader: '',
  'api-token': 'dGhpc2lzYWNvbW1vbnRva2VuXzE='
};

Future<List<UsersLogs>> _getUsersLogList(int withPage) async {
  final data = await http.post("http://user.brozapp.com/api/userLogList",
      headers: _defaultApiHeaders,
      body: jsonEncode(<String, dynamic>{
        "pageNumber": withPage,
        "pageSize": 10,
        'userId': Constants.userID,
        'userType': Constants.userType,
        'outletId': Constants.outletID
      }));
  var params = jsonEncode(<String, dynamic>{
    "pageNumber": withPage,
    "pageSize": 10,
    'userId': Constants.userID,
    'userType': Constants.userType,
    'outletId': Constants.outletID
  });
  print('request params ${params} ** ');
  var json = jsonDecode(data.body);
  print("API Response:$json");
  if (json["status"] == 1) {
    final Iterable userLogList = json['responseData'];
    if (userLogList.length > 0) {
      return userLogList.map((e) => UsersLogs.fromJson(e)).toList();
    } else {
      return List<UsersLogs>();
    }
  }
  return List<UsersLogs>();
}

class UserLogsStreamModel {
  Stream<List<UsersLogs>> stream;
  bool hasMore;
  int pageNumber;
  bool _isLoading;
  bool reachedBottom;
  List<UsersLogs> _data;
  StreamController<List<UsersLogs>> _controller;

  UserLogsStreamModel() {
    _data = List<UsersLogs>();
    _controller = StreamController<List<UsersLogs>>.broadcast();
    _isLoading = false;
    pageNumber = 1;
    stream = _controller.stream.map((List<UsersLogs> postsData) {
      return postsData;
    });
    hasMore = true;
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
      _data = List<UsersLogs>();
      pageNumber = 1;
      hasMore = true;
    }
    reachedBottom = reachesBottom;
    if (_isLoading || !hasMore) {
      return Future.value();
    }
    _isLoading = true;
    return _getUsersLogList(pageNumber).then((postsData) {
      _isLoading = false;
      _data.addAll(postsData);
      pageNumber += 1;
      reachedBottom = false;
      hasMore = false;
      _controller.add(_data);
    });
  }
}
