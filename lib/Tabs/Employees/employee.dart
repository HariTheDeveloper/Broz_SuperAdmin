import 'dart:async';

import 'package:broz_admin/Login/password/password_page.dart';
import 'package:broz_admin/Tabs/Employees/wallet_model.dart';
import 'package:broz_admin/Tabs/Employees/wallet_recharge.dart';
import 'package:broz_admin/Utitlity/safe_area_container.dart';
import 'package:broz_admin/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:broz_admin/List/employeeCell.dart';
import 'package:broz_admin/Tabs/Employees/employee_model.dart';
import 'package:broz_admin/OrderDetail/order_detail_model.dart' as Model;
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EmployeeWalletWidget extends StatefulWidget {
  const EmployeeWalletWidget({Key key}) : super(key: key);

  @override
  _EmployeeWalletWidgetState createState() => _EmployeeWalletWidgetState();
}

class _EmployeeWalletWidgetState extends State<EmployeeWalletWidget> {
  final scrollController = ScrollController();
  SearchEmployeeStreamModel searchStreamModel;
  TextEditingController walletController = TextEditingController();
  final GlobalKey<State> _keyAlertDialog = GlobalKey<State>();
  final GlobalKey<State> _keyLoaderDialog = GlobalKey<State>();
  final FocusNode _nodeText = FocusNode();
  int credit = 1;
  bool isLoading = true;
  bool isSearchData = false;
  bool showLinearLoader = false;
  Timer _searchOnStoppedTyping;
  bool _showClear = false;

  TextEditingController commentsController = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    searchStreamModel = SearchEmployeeStreamModel();
    searchStreamModel.stream.listen((data) {
      if (mounted)
        setState(() {
          isLoading = false;
          showLinearLoader = false;
        });
    });
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print("Bottom reached");
        searchStreamModel.loadMore(reachesBottom: true);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    walletController?.dispose();
    _searchController?.dispose();
    super.dispose();
  }

  /// Creates the [KeyboardActionsConfig] to hook up the fields
  /// and their focus nodes to our [FormKeyboardActions].
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
            focusNode: _nodeText,
            displayDoneButton: true,
            displayArrows: false),
      ],
    );
  }

  Widget bottomAppBar() {
    return isLoading
        ? PreferredSize(
            preferredSize: Size.fromHeight(0.0),
            child: SizedBox.shrink(),
          )
        : PreferredSize(
            child: Container(
                color: Colors.green,
                child: Column(
                  children: [
                    _searchBarWidget(),
                    PreferredSize(
                        child: showLinearLoader
                            ? Container(
                                height: showLinearLoader ? 2 : 0,
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.grey,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : SizedBox.shrink(),
                        preferredSize:
                            Size.fromHeight(showLinearLoader ? 2.0 : 0.0)),
                  ],
                )),
            preferredSize: Size.fromHeight(45.0));
  }

  onSearchTextChanged(String text) async {
    setState(() {
      _showClear = true;
      showLinearLoader = true;
    });

    const duration = Duration(
        milliseconds:
            800); // set the duration that you want call search() after that.
    if (_searchOnStoppedTyping != null) _searchOnStoppedTyping.cancel();
    setState(() => _searchOnStoppedTyping = new Timer(duration, () {
          searchStreamModel.searchData = text;
          if (scrollController.hasClients) {
            scrollController.animateTo(0,
                duration: Duration(milliseconds: 300), curve: Curves.easeIn);
          }

          searchStreamModel.refresh();
        }));
  }

  _searchBarWidget() {
    return Padding(
        padding: const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 5),
        child: Container(
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 22,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: TextField(
                      controller: _searchController,
                      onChanged: onSearchTextChanged,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search Employees",
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      )),
                ),
                _showClear
                    ? InkWell(
                        onTap: () {
                          _searchController.clear();
                          onSearchTextChanged('');
                          setState(() {
                            _showClear = false;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.clear,
                            size: 22,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Employee List",
            style: TextStyle(color: Colors.white),
          ),
          bottom: bottomAppBar(),
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
        body: SafeAreaContainer(
          child: StreamBuilder(
            stream: searchStreamModel.stream,
            builder: (BuildContext _context, AsyncSnapshot _snapshot) {
              if (!_snapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Colors.green[300])));
              } else if (_snapshot.data.length > 0) {
                return RefreshIndicator(
                  color: Colors.black,
                  onRefresh: searchStreamModel.refresh,
                  child: ListView.separated(
                    // padding: EdgeInsets.symmetric(vertical: 8.0),
                    controller: scrollController,
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: _snapshot.data.length + 1,
                    itemBuilder: (BuildContext _context, int index) {
                      if (index < _snapshot.data.length) {
                        return EmployeeCell(
                          employeeJson: _snapshot.data[index],
                          employeeToRecharge: (json) {
                            walletController.clear();
                            commentsController.clear();
                            FocusScope.of(context).requestFocus(FocusNode());
                            showReachargeWiget(
                                walletController: walletController,
                                commentsController: commentsController,
                                key: _keyAlertDialog,
                                mContext: context,
                                keyboardConfig: _buildConfig(context),
                                nodeText: _nodeText,
                                recharged: (recharge, debit) {
                                  if (recharge) {
                                    print("Reacharge me");
                                    credit = debit;
                                    _showAlert(json);
                                  }
                                });
                          },
                        );
                      } else if (searchStreamModel.hasMore) {
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
          ),
        ));
  }

  void addEmployeeWalletAmount(EmployeeJson json) {
    showLoaderDialog(context, _keyLoaderDialog);
    getString(kUserLoginInfo).then((managerNumber) {
      addNewUserWallet(Model.Resource(
          url: 'http://user.brozapp.com/api/editUserWallet',
          request: newAddUserWalletRequestToJson(AddNewUserWalletRequest(
            amount: '${double.tryParse(walletController.text.trim()) ?? 0}',
            credit: credit,
            managerNumber: managerNumber, //NTC
            description: commentsController.text.trim(),
            transactionId: "adminAppRecharge",
            userId: json.userId.toString(),
            walletType: 5,
          )))).then((value) {
        closeLoaderDialog(_keyLoaderDialog);
        switch (value.status) {
          case 1:
            ScaffoldMessenger.of(context).showSnackBar(showToast(
                "Wallet amount of ${json.name} updated successfully"));
            setState(() {
              searchStreamModel.refresh();
              scrollController.animateTo(0,
                  duration: Duration(milliseconds: 300), curve: Curves.easeIn);
            });
            break;
          default:
            ScaffoldMessenger.of(context)
                .showSnackBar(showToast("${value.message}"));
        }
      }).catchError((onError) {
        closeLoaderDialog(_keyLoaderDialog);
        ScaffoldMessenger.of(context).showSnackBar(
            showToast("Oops ! something went wrong. Please try again later"));
      });
    });
  }

  _showAlert(EmployeeJson json) {
    Alert(
      style: AlertStyle(
        isCloseButton: false,
      ),
      context: context,
      type: AlertType.none,
      title: "Broz",
      desc: "Are you sure you want to recharge ?",
      buttons: [
        DialogButton(
          child: Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            addEmployeeWalletAmount(json);
          },
          color: Colors.green,
        ),
        DialogButton(
          child: Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
        )
      ],
    ).show();
  }
}

showToast(String msg) => SnackBar(
      content: Text(
        msg,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
    );
