import 'package:broz_admin/Wallet/wallet_logs.dart';
import 'package:flutter/material.dart';

class EmployeeJson {
  final int userId;
  final String name;
  final String designation;
  final String walletAmount;

  EmployeeJson({this.name, this.userId, this.designation, this.walletAmount});
  factory EmployeeJson.fromJson(Map<String, dynamic> jsonData) {
    return EmployeeJson(
        userId: jsonData['userId'],
        name: jsonData['name'].toString(),
        designation: jsonData['designation'].toString(),
        walletAmount: jsonData['WalletAmount'].toString());
  }
}

class EmployeeCell extends StatelessWidget {
  final EmployeeJson employeeJson;
  final Function(EmployeeJson) employeeToRecharge;
  const EmployeeCell(
      {Key key, @required this.employeeJson, this.employeeToRecharge})
      : assert(employeeJson != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WalletLogsScreen(
                userId: employeeJson.userId.toString() ?? "",
              ),
            ));
      },
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                InkWell(
                  onTap: () {
                    employeeToRecharge(employeeJson);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              offset: Offset(0.0, 0.5)),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Recharge",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
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
                      "Designation :",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    " ${employeeJson.designation}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
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
                      "Wallet Amount :",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    "AED ${employeeJson.walletAmount}",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
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
