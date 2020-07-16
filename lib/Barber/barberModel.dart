import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

var _defaultApiHeaders = {
  HttpHeaders.contentTypeHeader: 'application/json',
  HttpHeaders.authorizationHeader: '',
  'api-token': 'dGhpc2lzYWNvbW1vbnRva2VuXzE='
};

class BarberOrderJson {
  final String outletName;
  final String vendorLogo;
  final int orderKeyFormated;
  final int paymentMode;
  final String placedOn;
  final String total;
  BarberOrderJson(
      {this.outletName,
      this.vendorLogo,
      this.orderKeyFormated,
      this.paymentMode,
      this.placedOn,
      this.total});

  factory BarberOrderJson.fromJson(Map<String, dynamic> jsonData) {
    return BarberOrderJson(
        outletName: jsonData['outletName'],
        vendorLogo: jsonData['vendorLogo'],
        orderKeyFormated: jsonData['appointmentId'],
        paymentMode: jsonData['paymentMode'],
        placedOn: jsonData['appointmentDate'],
        total: jsonData['totalCost']);
  }
}

Future<List<BarberOrderJson>> _getBarberOrdersList(int withPage) async {
  final data = await http.post(
      "http://barber.pasutech.in/api/past/appointment/list",
      headers: _defaultApiHeaders,
      body: jsonEncode(
          <String, dynamic>{"pageNumber": withPage, "pageSize": 10}));
  var json = jsonDecode(data.body);
  print("API Response:$json");
  if (json["httpCode"] == 200) {
    final Iterable orderDataList = json['responseData']["appointments"];
    if (orderDataList.length > 0) {
      return orderDataList.map((e) => BarberOrderJson.fromJson(e)).toList();
    } else {
      return List<BarberOrderJson>();
    }
  } else {
    return List<BarberOrderJson>();
  }
}

class BarberStreamModel {
  Stream<List<BarberOrderJson>> stream;
  bool hasMore;
  int pageNumber;
  bool isLoading;
  bool reachedBottom;
  List<BarberOrderJson> _data;
  StreamController<List<BarberOrderJson>> _controller;

  BarberStreamModel() {
    _data = List<BarberOrderJson>();
    _controller = StreamController<List<BarberOrderJson>>.broadcast();
    isLoading = false;
    pageNumber = 1;
    stream = _controller.stream.map((List<BarberOrderJson> postsData) {
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
      _data = List<BarberOrderJson>();
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
      hasMore = postsData.length > 0;
      _controller.add(_data);
    });
  }
}
