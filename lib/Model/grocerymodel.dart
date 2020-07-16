import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:push_notification/Model/models.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class Groceries extends StatelessWidget {
  final GroceryModel grocery;

  const Groceries({Key key, @required this.grocery})
      : assert(grocery != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${grocery.status}"),
    );
  }
}

var _defaultApiHeaders = {
  HttpHeaders.contentTypeHeader: 'application/json',
  HttpHeaders.authorizationHeader: '',
  'api-token': 'dGhpc2lzYWNvbW1vbnRva2VuXzE='
};
final _params = jsonEncode({'orderId': '', 'language': '1', "userId": "2190"});
Future<List<Map>> _getExampleServerData() async {
  var url = 'https://brozapp.com/api/morders?stable_version=1';
  final response =
      await http.post(url, headers: _defaultApiHeaders, body: _params);
  return jsonDecode(response.body);
}

class GroceryModel {
  int status;
  List<Map<String, dynamic>> orderDataList;
  GroceryModel({this.status, this.orderDataList});
  factory GroceryModel.fromServerMap(Map data) {
    return GroceryModel(
      status: data['status'],
      orderDataList: data['orderDataList'],
    );
  }
}

class GroceriesModel {
  Stream<List<GroceryModel>> stream;
  bool hasMore;
  int pagenumber;
  int pageLimit;
  bool _isLoading;
  List<Map> _data;
  StreamController<List<Map>> _controller;

  GroceriesModel() {
    _data = List<Map>();
    _controller = StreamController<List<Map>>.broadcast();
    _isLoading = false;
    stream = _controller.stream.map((List<Map> orderDataList) {
      return orderDataList.map((Map postData) {
        return GroceryModel.fromServerMap(postData);
      }).toList();
    });
    hasMore = true;
    refresh();
  }

  Future<void> refresh() {
    return loadMore(clearCachedData: true);
  }

  Future<void> loadMore({bool clearCachedData = false}) {
    if (clearCachedData) {
      _data = List<Map>();
      hasMore = true;
    }
    if (_isLoading || !hasMore) {
      return Future.value();
    }
    _isLoading = true;
    return _getExampleServerData().then((postsData) {
      _isLoading = false;
      _data.addAll(postsData);
      hasMore = (_data.length < 30);
      _controller.add(_data);
    });
  }
}
