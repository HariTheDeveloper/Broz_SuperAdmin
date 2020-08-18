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

// class OrdersJson {
//   final String outletName;
//   final String vendorLogo;
//   final String orderKeyFormated;
//   final String paymentMode;
//   final String placedOn;
//   final String total;
//   final String statusName;
//   OrdersJson(
//       {this.outletName,
//       this.vendorLogo,
//       this.orderKeyFormated,
//       this.paymentMode,
//       this.placedOn,
//       this.total,
//       this.statusName});

//   factory OrdersJson.fromJson(Map<String, dynamic> jsonData) {
//     return OrdersJson(
//         outletName: jsonData['outletName'],
//         vendorLogo: jsonData['vendorLogo'],
//         orderKeyFormated: jsonData['orderKeyFormated'],
//         paymentMode: jsonData['paymentMode'],
//         placedOn: jsonData['placedOn'],
//         total: jsonData['total'],
//         statusName: jsonData['statusName']);
//   }
// }

Future<List<OrderJson>> _getOrdersList(int pageNumber) async {
  final data = await http.post("https://brozapp.com/api/morderDetails",
      headers: _defaultApiHeaders,
      body: jsonEncode(<String, dynamic>{
        'pageNumber': pageNumber,
        'pageSize': 10,
        'userId': Constants.userID,
        'userType': Constants.userType,
        'outletId': Constants.outletID
      }));
print('request params ${data.body} ** ');
  var json = jsonDecode(data.body);
  print("API Response:$json");
  if (json["status"] == 200) {
    final Iterable orderDataList = json['orderDataList'];
    if (orderDataList.length > 0) {
      return orderDataList.map((e) => OrderJson.fromJson(e)).toList();
    } else {
      return List<OrderJson>();
    }
  }
  return List<OrderJson>();
}

class StreamModel {
  Stream<List<OrderJson>> stream;
  bool hasMore;
  int pageNumber;
  int pagelimit;
  bool isLoading;
  bool reachedBottom;
  List<OrderJson> _data;
  StreamController<List<OrderJson>> _controller;

  StreamModel() {
    _data = List<OrderJson>();
    _controller = StreamController<List<OrderJson>>.broadcast();
    isLoading = false;
    pageNumber = 1;
    pagelimit = 15;
    stream = _controller.stream.map((List<OrderJson> postsData) {
      return postsData;
    });
    hasMore = true;
    reachedBottom = false;
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
    return _getOrdersList(pageNumber).then((postsData) {
      isLoading = false;
      _data.addAll(postsData);
      pageNumber += 1;
      reachedBottom = false;
      hasMore = (postsData.length > 0) && reachedBottom;
      _controller.add(_data);
    });
  }
}
