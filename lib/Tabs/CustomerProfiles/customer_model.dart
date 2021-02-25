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

Future<List<CustomerLogs>> _getCustomersList(int withPage) async {
  final data = await http.post("http://user.brozapp.com/api/userCallLogs",
      headers: _defaultApiHeaders,
      body: jsonEncode(<String, dynamic>{
        'userType': Constants.userType,
      }));

  var json = jsonDecode(data.body);
  print("API Response:$json");
  if (json["status"] == 1) {
    if (json['responseData'] != null) {
      final Iterable orderDataList = json['responseData'];
      if (orderDataList.length > 0) {
        return orderDataList.map((e) => CustomerLogs.fromJson(e)).toList();
      } else {
        return List<CustomerLogs>();
      }
    }
  }
  return List<CustomerLogs>();
}

class CustomersStreamModel {
  Stream<List<CustomerLogs>> stream;
  bool hasMore;
  int pageNumber;
  bool _isLoading;
  bool reachedBottom;
  List<CustomerLogs> _data;
  StreamController<List<CustomerLogs>> _controller;

  CustomersStreamModel() {
    _data = List<CustomerLogs>();
    _controller = StreamController<List<CustomerLogs>>.broadcast();
    _isLoading = false;
    pageNumber = 1;
    stream = _controller.stream.map((List<CustomerLogs> postsData) {
      return postsData;
    });
    hasMore = false;
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
      _data = List<CustomerLogs>();
      pageNumber = 1;
      hasMore = true;
    }
    reachedBottom = reachesBottom;
    if (_isLoading || !hasMore) {
      return Future.value();
    }
    _isLoading = true;
    return _getCustomersList(pageNumber).then((postsData) {
      _isLoading = false;
      _data.addAll(postsData);
      pageNumber += 1;
      reachedBottom = false;
      hasMore = reachedBottom;
      _controller.add(_data);
    });
  }
}
