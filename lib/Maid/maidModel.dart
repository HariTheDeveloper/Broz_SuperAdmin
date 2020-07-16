import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

var _defaultApiHeaders = {
  HttpHeaders.contentTypeHeader: 'application/json',
  HttpHeaders.authorizationHeader: '',
  'api-token': 'dGhpc2lzYWNvbW1vbnRva2VuXzE='
};

class MaidOrderJson {
  final String outletName;
  final String vendorLogo;
  final int orderKeyFormated;
  final String paymentMode;
  final String placedOn;
  final String total;
  MaidOrderJson(
      {this.outletName,
      this.vendorLogo,
      this.orderKeyFormated,
      this.paymentMode,
      this.placedOn,
      this.total});

  factory MaidOrderJson.fromJson(Map<String, dynamic> jsonData) {
    return MaidOrderJson(
        outletName: jsonData['outletName'],
        vendorLogo: jsonData['vendorLogo'],
        orderKeyFormated: jsonData['appointmentId'],
        paymentMode: jsonData['paymentMode'],
        placedOn: jsonData['appointmentDate'],
        total: jsonData['totalCost']);
  }
}

Future<List<MaidOrderJson>> _getMaidOrdersList(int withPage) async {
  final data = await http.post(
      "http://barber.pasubot.com/api/past/appointment/list",
      headers: _defaultApiHeaders,
      body: jsonEncode(
          <String, dynamic>{"pageNumber": withPage, "pageSize": 10}));
  var json = jsonDecode(data.body);
  print("API Response:$json");
  if (json["httpCode"] == 200) {
    final Iterable orderDataList = json["responseData"]['appointments'];
    if (orderDataList.length > 0) {
      return orderDataList.map((e) => MaidOrderJson.fromJson(e)).toList();
    } else {
      return List<MaidOrderJson>();
    }
  }
  return List<MaidOrderJson>();
}

class MaidStreamModel {
  Stream<List<MaidOrderJson>> stream;
  bool hasMore;
  int pageNumber;
  bool _isLoading;
  bool reachedBottom;
  List<MaidOrderJson> _data;
  StreamController<List<MaidOrderJson>> _controller;

  MaidStreamModel() {
    _data = List<MaidOrderJson>();
    _controller = StreamController<List<MaidOrderJson>>.broadcast();
    _isLoading = false;
    pageNumber = 1;
    stream = _controller.stream.map((List<MaidOrderJson> postsData) {
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
      _data = List<MaidOrderJson>();
      pageNumber = 1;
      hasMore = true;
    }
    reachedBottom = reachesBottom;
    if (_isLoading || !hasMore) {
      return Future.value();
    }
    _isLoading = true;
    return _getMaidOrdersList(pageNumber).then((postsData) {
      _isLoading = false;
      _data.addAll(postsData);
      pageNumber += 1;
      reachedBottom = false;
      hasMore = postsData.length > 0;
      _controller.add(_data);
    });
  }
}
