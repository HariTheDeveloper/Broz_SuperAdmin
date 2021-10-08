import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:broz_admin/Data/user_logs_data.dart';
import 'dart:convert';
import 'dart:io';

import 'package:broz_admin/Utitlity/Constants.dart';

var _defaultApiHeaders = {
  HttpHeaders.contentTypeHeader: 'application/json',
  HttpHeaders.authorizationHeader: '',
  'api-token': 'dGhpc2lzYWNvbW1vbnRva2VuXzE='
};

Future<List<UsersLogs>> _getUserDetailsLogs(int withPage, int userID) async {
  final data =
      await http.post(Uri.parse("http://user.brozapp.com/api/userLogDetails"),
          headers: _defaultApiHeaders,
          body: jsonEncode(<String, dynamic>{
            "pageNumber": withPage,
            "pageSize": 10,
            'userId': userID,
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
  print(
      'request params ${params} ** http://user.brozapp.com/api/userLogDetails');

  var json = jsonDecode(data.body);
  print("API Response:$json");
  if (json["status"] == 1) {
    final Iterable userLogList = json['responseData'];
    if (userLogList.length > 0) {
      return userLogList.map((e) => UsersLogs.fromJson(e)).toList();
    } else {
      return List<UsersLogs>.empty(growable: true);
    }
  }
  return List<UsersLogs>.empty(growable: true);
}

class UserDetailsStreamModel {
  Stream<List<UsersLogs>> stream;
  bool hasMore;
  int pageNumber;
  final int userID;
  bool _isLoading;
  bool reachedBottom;
  List<UsersLogs> _data;
  StreamController<List<UsersLogs>> _controller;

  UserDetailsStreamModel({this.userID}) {
    _data = List<UsersLogs>();
    _controller = StreamController<List<UsersLogs>>.broadcast();
    _isLoading = false;
    pageNumber = 1;
    stream = _controller.stream.map((List<UsersLogs> postsData) {
      return postsData;
    });
    hasMore = true;
    if (Constants.showData && userID != null) {
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
    return _getUserDetailsLogs(pageNumber, userID).then((postsData) {
      _isLoading = false;
      _data.addAll(postsData);
      pageNumber += 1;
      reachedBottom = false;
      hasMore = (postsData.length > 0) || reachedBottom;
      _controller.add(_data);
    });
  }
}
