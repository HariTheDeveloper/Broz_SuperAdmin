import 'package:flutter/material.dart';

class OffersJson {
  final String offerId;
  final String customerName;
  final String userId;
  final String mobile;
  final String createdDate;
  final String updatedDate;
  final String email;
  final String type;
  final String offerName;
  OffersJson(
      {this.offerId,
      this.customerName,
      this.userId,
      this.mobile,
      this.createdDate,
      this.updatedDate,
      this.email,
      this.type,
      this.offerName});

  factory OffersJson.fromJson(Map<String, dynamic> jsonData) {
    return OffersJson(
        offerId: jsonData['offerId'].toString(),
        customerName: jsonData['name'],
        userId: jsonData['userId'].toString(),
        mobile: jsonData['mobile'].toString(),
        createdDate: jsonData['createdDate'],
        updatedDate: jsonData['updatedDate'],
        email: jsonData['email'],
        type: jsonData['type'].toString(),
        offerName: jsonData['offerName'].toString());
  }
}

class OffersCell extends StatelessWidget {
  final OffersJson offersJson;

  const OffersCell({Key key, @required this.offersJson})
      : assert(offersJson != null),
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
                    "${offersJson.userId}",
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
                  "${offersJson.customerName}",
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
                    "${offersJson.offerName}",
                    style: TextStyle(
                      color: Colors.green,
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
                    "${offersJson.createdDate}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  "Mobile: ${offersJson.mobile}",
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
