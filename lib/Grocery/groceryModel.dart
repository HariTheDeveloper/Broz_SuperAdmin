import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

var _defaultApiHeaders = {
  HttpHeaders.contentTypeHeader: 'application/json',
  HttpHeaders.authorizationHeader: '',
  'api-token': 'dGhpc2lzYWNvbW1vbnRva2VuXzE='
};

class OrdersJson {
  final String outletName;
  final String vendorLogo;
  final String orderKeyFormated;
  final String paymentMode;
  final String placedOn;
  final String total;
  OrdersJson(
      {this.outletName,
      this.vendorLogo,
      this.orderKeyFormated,
      this.paymentMode,
      this.placedOn,
      this.total});

  factory OrdersJson.fromJson(Map<String, dynamic> jsonData) {
    return OrdersJson(
        outletName: jsonData['outletName'],
        vendorLogo: jsonData['vendorLogo'],
        orderKeyFormated: jsonData['orderKeyFormated'],
        paymentMode: jsonData['paymentMode'],
        placedOn: jsonData['placedOn'],
        total: jsonData['total']);
  }
}

Future<List<OrdersJson>> _getOrdersList(int pageNumber) async {
  final data = await http.post("https://brozapp.com/api/morderDetails",
      headers: _defaultApiHeaders,
      body: jsonEncode(
          <String, dynamic>{'pageNumber': pageNumber, 'pageSize': 10}));
  var json = jsonDecode(data.body);
  print("API Response:$json");
  if (json["status"] == 200) {
    final Iterable orderDataList = json['orderDataList'];
    if (orderDataList.length > 0) {
      return orderDataList.map((e) => OrdersJson.fromJson(e)).toList();
    } else {
      return List<OrdersJson>();
    }
  }
  return List<OrdersJson>();
}

class StreamModel {
  Stream<List<OrdersJson>> stream;
  bool hasMore;
  int pageNumber;
  int pagelimit;
  bool isLoading;
  bool reachedBottom;
  List<OrdersJson> _data;
  StreamController<List<OrdersJson>> _controller;

  StreamModel() {
    _data = List<OrdersJson>();
    _controller = StreamController<List<OrdersJson>>.broadcast();
    isLoading = false;
    pageNumber = 1;
    pagelimit = 15;
    stream = _controller.stream.map((List<OrdersJson> postsData) {
      return postsData;
    });
    hasMore = true;
    reachedBottom = false;
    refresh();
  }

  Future<void> refresh() {
    return loadMore(clearCachedData: true);
  }

  Future<void> loadMore(
      {bool clearCachedData = false, bool reachesBottom = false}) {
    if (clearCachedData) {
      _data = List<OrdersJson>();
      pageNumber = 1;
      hasMore = true;
    }
    reachedBottom = reachesBottom;
    if (isLoading || !hasMore) {
      return Future.value();
    }
    isLoading = true;
    return _getOrdersList(pageNumber).then((postsData) {
      isLoading = false;
      _data.addAll(postsData);
      pageNumber += 1;
      reachedBottom = false;
      hasMore = pageNumber == 1 ? false : postsData.length > 0;
      _controller.add(_data);
    });
  }
}
