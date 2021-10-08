import 'package:broz_admin/Tabs/CustomerProfiles/customer_search_widget.dart';
import 'package:flutter/material.dart';
import 'package:broz_admin/Data/update_customer_data.dart';
import 'package:broz_admin/Data/user_logs_data.dart';
import 'package:broz_admin/Tabs/CustomerProfiles/customer_model.dart';
import 'package:broz_admin/Utitlity/Constants.dart';
import 'package:broz_admin/WebService/webservice.dart';
import 'package:broz_admin/app_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/subjects.dart';
import 'package:url_launcher/url_launcher.dart';

final isProcessRunning = BehaviorSubject<bool>();
Stream<bool> get processRunning => isProcessRunning.stream;

class ShowCustomersScreen extends StatefulWidget {
  @override
  _ShowCustomersScreenState createState() => _ShowCustomersScreenState();
}

class _ShowCustomersScreenState extends State<ShowCustomersScreen> {
  final scrollController = ScrollController();
  final GlobalKey<State> _keyAlertDialog = GlobalKey<State>();
  CustomersStreamModel streamModel;

  @override
  void initState() {
    super.initState();
    _callCustomerStream();
  }

  _callCustomerStream() {
    streamModel = CustomersStreamModel();

    streamModel.stream.listen((event) {
      if (event != null) isProcessRunning.add(false);
    });
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print("Bottom reached");
        streamModel.loadMore(reachesBottom: true);
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void updateCustomerApi(int userId) {
    showLoaderDialog(context, _keyAlertDialog);
    updateCustomer(Resource(
      url: '${BaseUrl}updateUserCall',
      request: updateCustomerRequestToJson(
        UpdateCustomerRequest(userId: userId),
      ),
    )).then((value) {
      closeLoaderDialog(_keyAlertDialog);
      setState(() {
        streamModel.refresh();
        if (scrollController.hasClients) {
          scrollController.animateTo(0,
              duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        }
        _showToast(value.message);
      });
    }).catchError((onError) {
      closeLoaderDialog(_keyAlertDialog);
      _showToast("Oops ! something went wrong.");
    });
  }

  _showToast(String msg) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Constants.showData
        ? Scaffold(
            body: StreamBuilder(
              stream: streamModel.stream,
              builder: (BuildContext _context, AsyncSnapshot _snapshot) {
                if (!_snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Colors.green[300])));
                } else if (_snapshot.data.length > 0) {
                  return RefreshIndicator(
                    color: Colors.black,
                    onRefresh: streamModel.refresh,
                    child: Column(
                      children: [
                        CustomerSearchBar(
                          onSearchTextChanged: (searchText) {
                            streamModel.searchText = searchText;
                            if (scrollController.hasClients) {
                              scrollController.animateTo(0,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                            }
                            streamModel.refresh();
                          },
                        ),
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            controller: scrollController,
                            separatorBuilder: (context, index) => Divider(),
                            itemCount: _snapshot.data.length + 1,
                            itemBuilder: (BuildContext _context, int index) {
                              if (index < _snapshot.data.length) {
                                return _showCustomerWidget(
                                    _snapshot.data[index]);
                              } else if (streamModel.hasMore) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 32.0),
                                  child: Center(
                                      child: CircularProgressIndicator(
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  Colors.green[300]))),
                                );
                              } else {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 32.0),
                                  child: Align(
                                    child: _snapshot.data.length > 4
                                        ? Text('Nothing more to load !')
                                        : Container(),
                                    alignment: Alignment.center,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      CustomerSearchBar(
                        onSearchTextChanged: (searchText) {
                          streamModel.searchText = searchText;
                          if (scrollController.hasClients) {
                            scrollController.animateTo(0,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeIn);
                          }
                          streamModel.refresh();
                        },
                      ),
                      Expanded(
                        child: Center(
                            child: Text(
                          'No data found !',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                      ),
                    ],
                  );
                }
              },
            ),
          )
        : Center(
            child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'You are not authorized to view this.\nPlease contact admin !',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ));
  }

  _launchCaller(String mobileNo) async {
    var url = "tel:$mobileNo";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _showCustomerWidget(CustomerLogs offersJson) {
    return InkWell(
      onTap: () {
        _launchCaller(offersJson.userPhone);
      },
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                  child: Text(
                    "${offersJson.userId}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      "${offersJson.userName}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "${offersJson.createdDate}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    " ${offersJson.email}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Mobile: ${offersJson.userPhone}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  offersJson.introStatus == '1'
                      ? Text(
                          "Called",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            print(offersJson.userId);
                            updateCustomerApi(offersJson.userId);
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              "Mark as Called",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
