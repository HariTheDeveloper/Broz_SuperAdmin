import 'package:broz_admin/OrderDetail/order_detail_model.dart';
import 'package:broz_admin/Utitlity/safe_area_container.dart';
import 'package:broz_admin/Wallet/walet_logs_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class WalletLogsScreen extends StatefulWidget {
  final String userId;

  const WalletLogsScreen({Key key, this.userId}) : super(key: key);

  @override
  _WalletLogsScreenState createState() => _WalletLogsScreenState();
}

class _WalletLogsScreenState extends State<WalletLogsScreen> {
  Future<NewUserWalletResponse> _userWalletResponse;
  final _keyAlertDialog = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  int _pageNumber = 1;
  int _pageSize = 20;
  List<WalletHistory> _walletHistiry;
  bool _shouldAddList = false;
  int _selectedOfferIndex = 0;
  bool isRTL = false;
  final GlobalKey<State> _keyLoaderDialog = GlobalKey<State>();
  @override
  void initState() {
    _getUserWallet();
    super.initState();
  }

  void _getUserWallet() {
    _walletHistiry = List();
    _shouldAddList = true;
    _userWalletResponse = newUserWallet(
      Resource(
        url: 'http://user.brozapp.com/apiencrypt/newUserWallet',
        request: newUserWalletRequestToJson(
          NewUserWalletRequest(
              pageNumber: '$_pageNumber',
              pageSize: '$_pageSize',
              type: '1',
              userId: widget.userId.toString()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaContainer(child: _bodyWidgetWithAppbar(),);
  }

  _bodyWidgetWithAppbar() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Wallet Logs",
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
      body: _buildBodyWidget(),
    );
  }

  _buildBodyWidget() {
    return FutureBuilder<NewUserWalletResponse>(
      future: _userWalletResponse,
      builder: (context, snapshot) => _handleWalletSnapshot(snapshot),
    );
  }

  _handleWalletSnapshot(AsyncSnapshot<NewUserWalletResponse> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.done:
        if (snapshot.hasData) {
          if (_shouldAddList)
            _walletHistiry.addAll(snapshot.data.responseData.walletHistory);
          return _handleWalletResponse(snapshot.data);
        } else
          return noDataView("Oops ! something went wrong.");
        break;
      default:
        return loadingView();
    }
  }

  _handleWalletResponse(NewUserWalletResponse walletResponse) {
    switch (walletResponse.status) {
      case 1:
      case 2:
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!_isLoading &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              _loadData(walletResponse);
              return true;
            }
            return false;
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: _walletHistoryOrStartStoppingWidget(walletResponse),
          ),
        );
      default:
        return noDataView(walletResponse.message);
    }
  }

  _walletHistoryOrStartStoppingWidget(NewUserWalletResponse walletResponse) {
    if (walletResponse.responseData.walletHistory.isNotEmpty)
      return walletHistoryWidget(walletResponse.responseData);
    else {
      return noDataView("No History Found");
    }
  }

  _loadingWalletDesign() => Container(
        height: 300,
        child: Shimmer.fromColors(
          baseColor: Colors.white, //Colors.grey[100].withOpacity(0.75),
          highlightColor: Colors.grey[300],
          direction: ShimmerDirection.ltr,
          child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 5, 15),
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                  height: 22,
                                  width: 200,
                                  color: kWalletBgColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                height: 22,
                                width: 120,
                                color: kWalletBgColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                height: 22,
                                width: 150,
                                color: kWalletBgColor,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
      );

  Future _loadData(NewUserWalletResponse walletResponse) async {
    _shouldAddList = false;
    if ((_pageNumber * _pageSize) >= walletResponse.totalCount) {
      _isLoading
          ? setState(() {
              _isLoading = false;
            })
          : _isLoading = false;
    } else {
      setState(() {
        _pageNumber += 1;
        _isLoading = true;
      });

      newUserWallet(Resource(
        url: 'http://user.brozapp.com/apiencrypt/newUserWallet',
        request: newUserWalletRequestToJson(
          NewUserWalletRequest(
              pageNumber: '$_pageNumber',
              pageSize: '$_pageSize',
              type: '1',
              userId: widget.userId),
        ),
      )).then((walletHistoryResponse) {
        if (walletHistoryResponse.status == 1) {
          setState(() {
            _walletHistiry
                .addAll(walletHistoryResponse.responseData.walletHistory);
            _isLoading = false;
          });
        } else
          setState(() {
            _isLoading = false;
          });
      }).catchError((onError) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  walletHistoryWidget(ResponseData responseData) {
    var data = responseData.walletHistory;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var walletData = _walletHistiry[index];

              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: kWalletLightTextColor,
                        spreadRadius: 0.1,
                        blurRadius: 0.1,
                        offset: Offset(0, 0),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 15, 5, 10),
                            child: Container(
                              child: walletData.walletType == 0 ||
                                      walletData.walletType == 2
                                  ? CachedNetworkImage(
                                      imageUrl: walletData.outletImage,
                                      fit: BoxFit.cover,
                                    )
                                  : walletData.walletType == 4
                                      ? Center(
                                          child: SvgPicture.asset(
                                            'assets/broz-cardWallet.svg',
                                            height: 30,
                                            width: 30,
                                          ),
                                        )
                                      : walletData.walletType == 1
                                          ? Center(
                                              child: SvgPicture.asset(
                                                'assets/broz-offer.svg',
                                                height: 30,
                                                width: 30,
                                              ),
                                            )
                                          : Center(
                                              child: SvgPicture.asset(
                                                'assets/broz-shop.svg',
                                                height: 30,
                                                width: 30,
                                              ),
                                            ),
                              width: 100,
                              height: 70,
                              decoration: BoxDecoration(
                                  color: kWalletBgColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 15, 15, 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${walletData.description}",
                                          style: TextStyle(
                                              color: kWalletLightTextColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 15, 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'AED ${walletData.amount}',
                                          style: TextStyle(
                                              color: walletData.credit == 1
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 15, 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          walletData.date,
                                          style: TextStyle(
                                            color: kWalletLightTextColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                ),
              );
            },
            itemCount: _walletHistiry.length,
          ),
          _isLoading ? _loadingWalletDesign() : SizedBox.shrink()
        ],
      ),
    );
  }
}

Widget noDataView(String msg) => SizedBox.expand(
      child: Center(
        child: Text(
          msg,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
    );

const kWalletBgColor = Color(0xFFFAFAFA);
const kWalletLightTextColor = Color(0xFFA6ACC7);

Widget loadingView() => Center(
      child: SizedBox(
        width: 45.0,
        height: 45.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.green[300]),
        ),
      ),
    );
