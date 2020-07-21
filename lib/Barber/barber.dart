import 'package:flutter/material.dart';
import 'package:push_notification/List/listcell.dart';
import 'package:push_notification/Barber/barberModel.dart';

class BarberScreen extends StatefulWidget {
  @override
  _BarberScreenState createState() => _BarberScreenState();
}

class _BarberScreenState extends State<BarberScreen> {
  final scrollController = ScrollController();
  BarberStreamModel streamModel;

  @override
  void initState() {
    streamModel = BarberStreamModel();
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
      body: StreamBuilder(
        stream: streamModel.stream,
        builder: (BuildContext _context, AsyncSnapshot _snapshot) {
          if (!_snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.green[300])));
          } else if (_snapshot.data.length > 0) {
            return RefreshIndicator(
              onRefresh: streamModel.refresh,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                controller: scrollController,
                separatorBuilder: (context, index) => Divider(),
                itemCount: _snapshot.data.length + 1,
                itemBuilder: (BuildContext _context, int index) {
                  if (index < _snapshot.data.length) {
                    return ListCell(ordersJson: _snapshot.data[index]);
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
                        child: Text('Nothing more to load !'),
                        alignment: Alignment.center,
                      ),
                    );
                  }
                },
              ),
            );
          } else {
            return Center(child: Text('No data found !'));
          }
        },
      ),
    );
  }
}
