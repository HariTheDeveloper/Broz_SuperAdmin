import 'package:flutter/material.dart';
import 'package:broz_admin/List/offerscell.dart';
import 'package:broz_admin/Tabs/OfferLogs/offer_model.dart';
import 'package:broz_admin/Utitlity/Constants.dart';

class OffersScreen extends StatefulWidget {
  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final scrollController = ScrollController();
  OffersStreamModel streamModel;

  @override
  void initState() {
    streamModel = OffersStreamModel();

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
                          return OffersCell(offersJson: _snapshot.data[index]);
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
}
