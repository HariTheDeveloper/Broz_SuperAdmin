import 'package:flutter/material.dart';

class EmployeeJson {
  final String name;
  final String designation;
  final String walletAmount;

  EmployeeJson({this.name, this.designation, this.walletAmount});
  factory EmployeeJson.fromJson(Map<String, dynamic> jsonData) {
    return EmployeeJson(
        name: jsonData['name'].toString(),
        designation: jsonData['name'].toString(),
        walletAmount: jsonData['name'].toString());
  }
}

class EmployeeCell extends StatelessWidget {
  final EmployeeJson employeeJson;

  const EmployeeCell({Key key, @required this.employeeJson})
      : assert(employeeJson != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(
                    "${employeeJson.name}",
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
                  "${employeeJson.designation}",
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
                    "${employeeJson.walletAmount}",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  " ${employeeJson.walletAmount}",
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
                    "${employeeJson.walletAmount}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  "Mobile: ${employeeJson.walletAmount}",
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
}
