import 'package:flutter/material.dart';
import 'package:broz_admin/List/employeeCell.dart';
import 'package:broz_admin/Tabs/Employees/employee_model.dart';
import 'package:broz_admin/Utitlity/Constants.dart';

class EmployeeWalletWidget extends StatefulWidget {
  const EmployeeWalletWidget({Key key}) : super(key: key);

  @override
  _EmployeeWalletWidgetState createState() => _EmployeeWalletWidgetState();
}

class _EmployeeWalletWidgetState extends State<EmployeeWalletWidget> {
  final scrollController = ScrollController();
  EmployeeStreamModel streamModel;
  @override
  void initState() {
    streamModel = EmployeeStreamModel();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print("Bottom reached");
        streamModel.loadMore(reachesBottom: true);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Employee List",
            style: TextStyle(color: Colors.white),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: Colors.green,
        ),
        backgroundColor: Colors.white,
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
                child: ListView.separated(
                  // padding: EdgeInsets.symmetric(vertical: 8.0),
                  controller: scrollController,
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: _snapshot.data.length + 1,
                  itemBuilder: (BuildContext _context, int index) {
                    if (index < _snapshot.data.length) {
                      return EmployeeCell(
                        employeeJson: _snapshot.data[index],
                      );
                    } else if (streamModel.hasMore) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                        child: Center(
                            child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
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
              );
            } else {
              return Center(
                  child: Text(
                'No data found !',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ));
            }
          },
        ));
  }
}
