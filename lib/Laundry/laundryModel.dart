import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:push_notification/List/listcell.dart';

var _defaultApiHeaders = {
  HttpHeaders.contentTypeHeader: 'application/json',
  HttpHeaders.authorizationHeader: '',
  'api-token': 'dGhpc2lzYWNvbW1vbnRva2VuXzE='
};

Future<List<OrderJson>> _getLaundryOrdersList(int withPage) async {
  // laundry.pasubot.com

  final data = await http.post(
      "http://laundry.brozapp.com/api/past/appointment/list",
      headers: _defaultApiHeaders,
      body: jsonEncode(
          <String, dynamic>{"pageSize": 10, "pageNumber": withPage}));
  var json = jsonDecode(data.body);
  print("API Response:$json");
  if (json["httpCode"] == 200) {
    final Iterable orderDataList = json["responseData"]['appointments'];
    if (orderDataList.length > 0) {
      return orderDataList.map((e) => OrderJson.fromJson(e)).toList();
    } else {
      return List<OrderJson>();
    }
  }
  return List<OrderJson>();
}

class LaundryStreamModel {
  Stream<List<OrderJson>> stream;
  bool hasMore;
  int pageNumber;
  bool _isLoading;
  bool reachedBottom;
  List<OrderJson> _data;
  StreamController<List<OrderJson>> _controller;

  LaundryStreamModel() {
    _data = List<OrderJson>();
    _controller = StreamController<List<OrderJson>>.broadcast();
    _isLoading = false;
    pageNumber = 1;
    stream = _controller.stream.map((List<OrderJson> postsData) {
      return postsData;
    });
    hasMore = true;
    refresh();
  }

  Future<void> refresh() {
    return loadMore(clearCachedData: true);
  }

  Future<void> loadMore(
      {bool clearCachedData = false, bool reachesBottom = false}) {
    if (clearCachedData) {
      _data = List<OrderJson>();
      pageNumber = 1;
      hasMore = true;
    }
    reachedBottom = reachesBottom;
    if (_isLoading || !hasMore) {
      return Future.value();
    }
    _isLoading = true;
    return _getLaundryOrdersList(pageNumber).then((postsData) {
      _isLoading = false;
      _data.addAll(postsData);
      pageNumber += 1;
      reachedBottom = false;
      hasMore = postsData.length > 0;
      _controller.add(_data);
    });
  }
}
