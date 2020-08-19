import 'package:flutter/material.dart';
import 'package:push_notification/List/userlistcell.dart';
import 'package:push_notification/Tabs/UserDetail/user_detail_model.dart';
import 'package:push_notification/Utitlity/Constants.dart';

class UserLogDetails extends StatefulWidget {
  final int userID;

  const UserLogDetails({Key key, this.userID}) : super(key: key);

  @override
  _UserLogDetailsState createState() => _UserLogDetailsState();
}

class _UserLogDetailsState extends State<UserLogDetails> {
  final scrollController = ScrollController();
  UserDetailsStreamModel streamModel;
  @override
  void initState() {
    streamModel = UserDetailsStreamModel();
    streamModel.userID = widget.userID;
    streamModel.loadMore(reachesBottom: true);
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
            appBar: AppBar(
              title: Text(
                "User Details",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.green,
            ),
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
                            enable: false,
                          );
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
                              child: _snapshot.data.length > 6
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
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                "User Details",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.green,
            ),
            body: Center(
                child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'You are not authorized to view this.\nPlease contact admin !',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )));
  }
}
