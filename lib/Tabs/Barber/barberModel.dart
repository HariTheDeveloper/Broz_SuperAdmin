import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:push_notification/List/listcell.dart';
import 'package:push_notification/Utitlity/Constants.dart';

var _defaultApiHeaders = {
  HttpHeaders.contentTypeHeader: 'application/json',
  HttpHeaders.authorizationHeader: '',
  'api-token': 'dGhpc2lzYWNvbW1vbnRva2VuXzE='
};

Future<List<OrderJson>> _getBarberOrdersList(int withPage) async {
  //barber.pasutech
  final data =
      await http.post("http://barber.brozapp.com/api/past/appointment/list",
          headers: _defaultApiHeaders,
          body: jsonEncode(<String, dynamic>{
            "pageNumber": withPage,
            "pageSize": 10,
            "clientId": Constants.userID,
            'userType': Constants.userType,
            'outletId': Constants.outletID
          }));
  var json = jsonDecode(data.body);
  print("API Response:$json");
  if (json["httpCode"] == 200) {
    final Iterable orderDataList = json['responseData']["appointments"];
    if (orderDataList.length > 0) {
      return orderDataList.map((e) => OrderJson.fromJson(e)).toList();
    } else {
      return List<OrderJson>();
    }
  } else {
    return List<OrderJson>();
  }
}

class BarberStreamModel {
  Stream<List<OrderJson>> stream;
  bool hasMore;
  int pageNumber;
  bool isLoading;
  bool reachedBottom;
  List<OrderJson> _data;

  StreamController<List<OrderJson>> _controller;

  BarberStreamModel() {
    _data = List<OrderJson>();
    _controller = StreamController<List<OrderJson>>.broadcast();
    isLoading = false;
    pageNumber = 1;
    stream = _controller.stream.map((List<OrderJson> postsData) {
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
      _data = List<OrderJson>();
      pageNumber = 1;
      hasMore = true;
    }
    reachedBottom = reachesBottom;
    if (isLoading || !hasMore) {
      return Future.value();
    }
    isLoading = true;
    return _getBarberOrdersList(pageNumber).then((postsData) {
      isLoading = false;
      _data.addAll(postsData);
      pageNumber += 1;
      reachedBottom = false;
      hasMore = (postsData.length > 0) || reachedBottom;
      _controller.add(_data);
    });
  }
}
