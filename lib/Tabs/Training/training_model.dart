import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:broz_admin/List/listcell.dart';
import 'package:broz_admin/Utitlity/Constants.dart';

var _defaultApiHeaders = {
  HttpHeaders.contentTypeHeader: 'application/json',
  HttpHeaders.authorizationHeader: '',
  'api-token': 'dGhpc2lzYWNvbW1vbnRva2VuXzE='
};

Future<List<OrderJson>> _getTrainingAppointmentList(int withPage) async {
  final data = await http.post(Uri.parse("http://brozfit.tk/api/morderDetails"),
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

  print('request params $params ** http://brozfit.tk/api/morderDetails');
  var json = jsonDecode(data.body);
  print("API Response:$json");
  if (json["status"] == 1) {
    final Iterable orderDataList = json["responseData"]['appointments'];
    if (orderDataList.length > 0) {
      return orderDataList.map((e) => OrderJson.fromJson(e)).toList();
    } else {
      return List<OrderJson>.empty(growable: true);
    }
  } else {
    return List<OrderJson>.empty(growable: true);
  }
}

class TrainingStreamModel {
  Stream<List<OrderJson>> stream;
  bool hasMore;
  int pageNumber;
  bool _isLoading;
  bool reachedBottom;
  List<OrderJson> _data;
  StreamController<List<OrderJson>> _controller;

  TrainingStreamModel() {
    _data = List<OrderJson>.empty(growable: true);
    _controller = StreamController<List<OrderJson>>.broadcast();
    _isLoading = false;
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
      _data = List<OrderJson>.empty(growable: true);
      pageNumber = 1;
      hasMore = true;
    }
    reachedBottom = reachesBottom;
    if (_isLoading || !hasMore) {
      return Future.value();
    }
    _isLoading = true;
    return _getTrainingAppointmentList(pageNumber).then((postsData) {
      _isLoading = false;
      _data.addAll(postsData);
      pageNumber += 1;
      reachedBottom = false;
      hasMore = (postsData.length > 0) || reachedBottom;
      _controller.add(_data);
    });
  }
}
