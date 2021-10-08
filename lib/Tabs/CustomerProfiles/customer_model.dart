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

Future<List<CustomerLogs>> _getCustomersList(
    int withPage, String searchText) async {
  final data =
      await http.post(Uri.parse("http://user.brozapp.com/api/userCallLogs"),
          headers: _defaultApiHeaders,
          body: jsonEncode(<String, dynamic>{
            'userType': Constants.userType,
            "pageNumber": withPage,
            "pageSize": 10,
            "searchText": searchText
          }));
  var params = jsonEncode(<String, dynamic>{
    'userType': Constants.userType,
    "pageNumber": withPage,
    "pageSize": 10,
    "searchText": searchText
  });
  print('request params $params ** http://user.brozapp.com/api/userCallLogs');
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
  String searchText;
  List<CustomerLogs> _data;
  StreamController<List<CustomerLogs>> _controller;

  CustomersStreamModel() {
    _data = List<CustomerLogs>();
    _controller = StreamController<List<CustomerLogs>>.broadcast();
    _isLoading = false;
    pageNumber = 1;
    searchText = "";
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
    return _getCustomersList(pageNumber, searchText).then((postsData) {
      _isLoading = false;
      _data.addAll(postsData);
      pageNumber += 1;
      reachedBottom = false;
      hasMore = (postsData.length >= 10) || reachedBottom;
      _controller.add(_data);
    });
  }
}
