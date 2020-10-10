import 'package:flutter/material.dart';
import 'package:push_notification/List/listcell.dart';
import 'package:push_notification/List/userlistcell.dart';
import 'package:push_notification/Tabs/UserDetail/user_detail.dart';
import 'package:push_notification/Tabs/UserLogs/user_logs_model.dart';
import 'package:push_notification/Utitlity/Constants.dart';

class UserLogsScreen extends StatefulWidget {
  @override
  _UserLogsScreenState createState() => _UserLogsScreenState();
}

class _UserLogsScreenState extends State<UserLogsScreen> {
  final scrollController = ScrollController();
  UserLogsStreamModel streamModel;

  @override
  void initState() {
    streamModel = UserLogsStreamModel();

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
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      controller: scrollController,
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: _snapshot.data.length + 1,
                      itemBuilder: (BuildContext _context, int index) {
                        if (index < _snapshot.data.length) {
                          return UserListCell(
                              ordersJson: _snapshot.data[index],
                              index: index,
                              enable: true,
                              parentAction: moveToOrderDetails);
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
                                  : SizedBox.shrink(),
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

  moveToOrderDetails(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserLogDetails(
                  userID: index,
                )));
  }
}
