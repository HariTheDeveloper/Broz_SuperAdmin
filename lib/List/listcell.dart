import 'package:flutter/material.dart';
import 'package:broz_admin/OrderDetail/order_detail.dart';
import 'package:broz_admin/OrderDetail/order_detail_model.dart';
import 'package:broz_admin/Utitlity/Constants.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderJson {
  final String outletName;
  final String customerName;
  final String appointmentId;
  final String paymentMode;
  final String createdDate;
  final String appointmentDate;
  final String totalCost;
  final String statusName;
  final int statusId;
  final String outletManagerName;
  final String storeNumber;
  final String outletManagerNumber;
  final String customerNumber;
  final String customerID;
  final String orderID;
  OrderJson(
      {this.outletName,
      this.customerName,
      this.appointmentId,
      this.paymentMode,
      this.createdDate,
      this.appointmentDate,
      this.totalCost,
      this.statusId,
      this.outletManagerName,
      this.outletManagerNumber,
      this.storeNumber,
      this.customerNumber,
      this.customerID,
      this.orderID,
      this.statusName});

  factory OrderJson.fromJson(Map<String, dynamic> jsonData) {
    return OrderJson(
        outletName: jsonData['outletName'],
        customerName: jsonData['customerName'],
        appointmentId: jsonData['appointmentId'].toString(),
        paymentMode: jsonData['paymentMode'].toString(),
        createdDate: jsonData['createdDate'],
        appointmentDate: jsonData['appointmentDate'],
        totalCost: jsonData['totalCost'],
        statusId: jsonData['statusId'] ?? 0,
        statusName: jsonData['statusName'] ?? "",
        outletManagerName: jsonData["outletManagerName"].toString() ?? "",
        outletManagerNumber: jsonData["outletManagerNumber"].toString() ?? "",
        storeNumber: jsonData["storeNumber"].toString() ?? "",
        customerNumber: jsonData['customerNumber'].toString() ?? "",
        orderID: jsonData['appointmentId'].toString() ?? "",
        customerID: jsonData['customerId'].toString() ?? "");
  }
}

class CallOptions {
  final String name;
  final String number;

  CallOptions({this.name, this.number});
}

class ListCell extends StatelessWidget {
  final OrderJson ordersJson;
  final OrderedService service;
  const ListCell({Key key, @required this.ordersJson, @required this.service})
      : assert(ordersJson != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    var darkBg = orderProcessed(ordersJson.statusName.replaceAll(" ", ""));
    return Container(
      color: darkBg ? Colors.white : Colors.red,
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(
                    "${ordersJson.outletName}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(
                  "${ordersJson.customerName}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
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
                    "${ordersJson.createdDate}",
                    style: TextStyle(
                      color: darkBg ? Colors.green : Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  " ${ordersJson.appointmentDate}",
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
                    "${ordersJson.appointmentId}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  "${ordersJson.statusName}",
                  style: TextStyle(
                    color: getColorForStatus(
                        ordersJson.statusName.replaceAll(" ", "")),
                    fontWeight: getFontWeight(
                        ordersJson.statusName.replaceAll(" ", "")),
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
                    "${ordersJson.totalCost}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  "${ordersJson.paymentMode}",
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
            padding: const EdgeInsets.only(
              top: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      moveToOrderDetails(context, ordersJson);
                    },
                    child: Text(
                      'View Detail',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: !darkBg ? Colors.white : Colors.green,
                      ),
                    )),
                InkWell(
                  onTap: () {
                    showOrderOptionsBottomSheet(context, true, ordersJson);
                  },
                  child: Container(
                    width: 80,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            offset: Offset(0, 1)),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Call",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool orderProcessed(String status) {
    switch (status.toLowerCase()) {
      case DELIEVERD:
      case CANCELLED:
      case DISPATCHED:
      case COMPLETED:
        return true;
      default:
        return false;
    }
  }

  Color getColorForStatus(String status) {
    switch (status.toLowerCase()) {
      case DELIEVERD:
      case COMPLETED:
        return Colors.green;
      case CANCELLED:
        return Colors.red;
      case DISPATCHED:
        return Colors.blueAccent;
      default:
        return Colors.black;
    }
  }

  FontWeight getFontWeight(String status) {
    switch (status.toLowerCase()) {
      case DELIEVERD:
      case COMPLETED:
      case CANCELLED:
      case DISPATCHED:
        return FontWeight.bold;
      default:
        return FontWeight.normal;
    }
  }

  Future<void> showOrderOptionsBottomSheet(
      BuildContext context, bool isToMakeCall, OrderJson orderJson) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return SafeArea(bottom: true, child: _bodyWidget(orderJson));
        },
        context: context);
  }

  Widget _bodyWidget(OrderJson orderJson) {
    var title = "";
    return Container(
      height: 220,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Text(
              "Select an option to make a call",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 25,
            ),
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) {
                return Divider(
                  thickness: 1,
                );
              },
              shrinkWrap: true,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    title = "Outlet Manager";
                    break;
                  case 1:
                    title = "Store";
                    break;

                  default:
                    title = "Customer";
                }
                return GestureDetector(
                  onTap: () {
                    switch (index) {
                      case 0:
                        launch(('tel://${orderJson.outletManagerNumber}'));
                        break;
                      case 1:
                        launch(('tel://${orderJson.storeNumber}'));
                        break;
                      default:
                        launch(('tel://${orderJson.customerNumber}'));
                        break;
                    }
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    height: 40,
                  ),
                );
              },
              itemCount: 3,
            ),
            SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  moveToOrderDetails(BuildContext context, OrderJson orderJson) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderDetailWidget(
                  orderDetailArguments: OrderDetailArguments(
                    orderID: ordersJson.orderID ?? "",
                    orderedService: service,
                    userId: ordersJson.customerID ?? "",
                  ),
                )));
  }
}
