import 'package:flutter/material.dart';
import 'package:push_notification/Utitlity/Constants.dart';

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
  OrderJson(
      {this.outletName,
      this.customerName,
      this.appointmentId,
      this.paymentMode,
      this.createdDate,
      this.appointmentDate,
      this.totalCost,
      this.statusId,
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
        statusName: jsonData['statusName'] ?? "");
  }
}

class ListCell extends StatelessWidget {
  final OrderJson ordersJson;

  const ListCell({Key key, @required this.ordersJson})
      : assert(ordersJson != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: orderProcessed(ordersJson.statusName.replaceAll(" ", ""))
          ? Colors.white
          : Colors.red,
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
                      color: orderProcessed(
                              ordersJson.statusName.replaceAll(" ", ""))
                          ? Colors.green
                          : Colors.white,
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
}
