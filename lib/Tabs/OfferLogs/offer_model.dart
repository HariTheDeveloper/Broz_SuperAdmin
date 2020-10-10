import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:push_notification/List/offerscell.dart';
import 'package:push_notification/Utitlity/Constants.dart';

var _defaultApiHeaders = {
  HttpHeaders.contentTypeHeader: 'application/json',
  HttpHeaders.authorizationHeader: '',
  'api-token': 'dGhpc2lzYWNvbW1vbnRva2VuXzE='
};

Future<List<OffersJson>> _getOffersList(int withPage) async {
  final data = await http.post("http://user.brozapp.com/api/offerSubscribeList",
      headers: _defaultApiHeaders,
      body: jsonEncode(<String, dynamic>{
        "pageNumber": withPage,
        "pageSize": 10,
        'userId': Constants.userID,
        'userType': Constants.userType,
        'outletId': Constants.outletID,
        'offerId': 93
      }));
  var json = jsonDecode(data.body);
  print("API Response:$json");
  if (json["status"] == 1) {
    final Iterable orderDataList = json['responseData'];
    if (orderDataList.length > 0) {
      return orderDataList.map((e) => OffersJson.fromJson(e)).toList();
    } else {
      return List<OffersJson>();
    }
  }
  return List<OffersJson>();
}

class OffersStreamModel {
  Stream<List<OffersJson>> stream;
  bool hasMore;
  int pageNumber;
  bool _isLoading;
  bool reachedBottom;
  List<OffersJson> _data;
  StreamController<List<OffersJson>> _controller;

  OffersStreamModel() {
    _data = List<OffersJson>();
    _controller = StreamController<List<OffersJson>>.broadcast();
    _isLoading = false;
    pageNumber = 1;
    stream = _controller.stream.map((List<OffersJson> postsData) {
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
      _data = List<OffersJson>();
      pageNumber = 1;
      hasMore = true;
    }
    reachedBottom = reachesBottom;
    if (_isLoading || !hasMore) {
      return Future.value();
    }
    _isLoading = true;
    return _getOffersList(pageNumber).then((postsData) {
      _isLoading = false;
      _data.addAll(postsData);
      pageNumber += 1;
      reachedBottom = false;
      hasMore = (postsData.length > 0) || reachedBottom;
      _controller.add(_data);
    });
  }
}
