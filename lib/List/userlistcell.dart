import 'package:flutter/material.dart';
import 'package:broz_admin/Data/user_logs_data.dart';

class UserListCell extends StatelessWidget {
  final UsersLogs ordersJson;
  final ValueChanged<int> parentAction;
  final int index;
  final bool enable;
  const UserListCell(
      {Key key,
      @required this.ordersJson,
      this.enable,
      this.parentAction,
      this.index})
      : assert(ordersJson != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (enable) {
          parentAction(ordersJson.userId);
        }
      },
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      "${ordersJson.userName}",
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
                    "${ordersJson.userPhone}",
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
                        color: Colors.green,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    " ${ordersJson.deviceModel}",
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
                      "ID: ${ordersJson.userId}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    getStatusLabelAndColor(ordersJson.deviceStatus).status,
                    style: TextStyle(
                      color: getStatusLabelAndColor(ordersJson.deviceStatus)
                          .statusColor,
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
                      "Volume: ${ordersJson.deviceVolume}",
                      style: TextStyle(
                        color: double.parse('${ordersJson.deviceVolume}') < 3
                            ? Colors.red
                            : Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    "Battery: ${ordersJson.deviceBattery}",
                    style: TextStyle(
                      color: double.parse('${ordersJson.deviceBattery}') < 40
                          ? Colors.red
                          : Colors.black,
                      fontWeight: FontWeight.normal,
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

StatusAndLabelColor getStatusLabelAndColor(int status) {
  switch (status) {
    case 1:
    case 4:
      return StatusAndLabelColor(status: "Open", statusColor: Colors.green);
    case 2:
      return StatusAndLabelColor(status: "Closed", statusColor: Colors.red);
    default:
      return StatusAndLabelColor(
          status: "Minimized", statusColor: Colors.orange);
  }
}

class StatusAndLabelColor {
  final String status;
  final Color statusColor;

  StatusAndLabelColor({this.status, this.statusColor});
}
