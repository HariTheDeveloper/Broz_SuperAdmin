import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:push_notification/Tabs/Barber/barber.dart';
import 'package:push_notification/Tabs/CustomerProfiles/customer_show_screen.dart';
import 'package:push_notification/Tabs/Grocery/grocery.dart';
import 'package:push_notification/Tabs/Laundry/laundry.dart';
import 'package:push_notification/Tabs/Maid/maid.dart';
import 'package:push_notification/Tabs/OfferLogs/offers.dart';
import 'package:push_notification/Tabs/Restaurant/restaurant.dart';
import 'package:push_notification/Push/push.dart';
import 'package:push_notification/Tabs/UserLogs/user_logs.dart';
import 'package:push_notification/Utitlity/Constants.dart';
import 'package:push_notification/main.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllServicesPage extends StatefulWidget {
  @override
  _AllServicesPageState createState() => _AllServicesPageState();
}

class _AllServicesPageState extends State<AllServicesPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> tabsArray = [
    {"title": "Supermarket", "id": 1},
    {"title": "Restaurant", "id": 5},
    {"title": "Hair&Beauty", "id": 2},
    {"title": "Laundry", "id": 4},
    {"title": "Home Cleaning", "id": 3},
    {"title": "User Logs", "id": 6},
    {"title": "Offer Logs", "id": 7},
    {"title": "Customer Logs", "id": 8}
  ];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Constants.showData = Constants.userType == 0
        ? true
        : tabsArray[selectedIndex]['id'] == Constants.userType
            ? true
            : false;
  }

  @override
  Widget build(BuildContext context) {
    tabsArray = [
      {
        "title": "Supermarket",
        "id": Constants.grocery,
        "icon": Image.asset(
          "assets/grocery.png",
          width: 24,
          height: 24,
          color: selectedIndex == 0 ? Colors.green : Colors.grey,
        )
      },
      {
        "title": "Restaurant",
        "id": Constants.restaurant,
        "icon": Image.asset(
          "assets/restaurant.png",
          width: 24,
          height: 24,
          color: selectedIndex == 1 ? Colors.green : Colors.grey,
        )
      },
      {
        "title": "Hair&Beauty",
        "id": Constants.barber,
        "icon": Image.asset(
          "assets/barber.png",
          width: 24,
          height: 24,
          color: selectedIndex == 2 ? Colors.green : Colors.grey,
        )
      },
      {
        "title": "Laundry",
        "id": Constants.laundry,
        "icon": Image.asset(
          "assets/laundry.png",
          width: 24,
          height: 24,
          color: selectedIndex == 3 ? Colors.green : Colors.grey,
        )
      },
      {
        "title": "Home Cleaning",
        "id": Constants.maid,
        "icon": Image.asset(
          "assets/maid.png",
          width: 24,
          height: 24,
          color: selectedIndex == 4 ? Colors.green : Colors.grey,
        )
      },
      {
        "title": "User Logs",
        "id": Constants.userLogs,
        "icon": Image.asset(
          "assets/logs.png",
          width: 24,
          height: 24,
          color: selectedIndex == 5 ? Colors.green : Colors.grey,
        )
      },
      {
        "title": "Offer Logs",
        "id": Constants.offerLogs,
        "icon": Image.asset(
          "assets/offer.png",
          width: 24,
          height: 24,
          color: selectedIndex == 6 ? Colors.green : Colors.grey,
        )
      },
      {
        "title": "Customer Logs",
        "id": Constants.userLogs,
        "icon": Container(
          height: 24,
          width: 24,
          child: Icon(Icons.group),
        )
      }
    ];
    return WillPopScope(
        child: bottomTabViewSetup(context),
        onWillPop: () => SystemNavigator.pop());
  }

  Widget bottomTabViewSetup(BuildContext context) {
    var title = tabsArray[selectedIndex];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: tabsArray.length,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(
              "${title["title"]}",
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
                icon: Image.asset(
                  "assets/user-3.png",
                  width: 50,
                  height: 50,
                ),
                onPressed: () {
                  Alert(
                    style: AlertStyle(
                      isCloseButton: false,
                    ),
                    context: context,
                    type: AlertType.none,
                    title: "Broz",
                    desc: "Are you sure you want to logout ?",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Yes",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _clearDefaultsAndProceed();
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
                }),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShareTokenPage()));
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: Text(
                    "Share Token",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 0.8),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ],
            backgroundColor: Colors.green,
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              GroceryScreen(),
              RestaurantScreen(),
              BarberScreen(),
              LaundryScreen(),
              MaidScreen(),
              UserLogsScreen(),
              OffersScreen(),
              ShowCustomersScreen()
            ],
          ),
          bottomNavigationBar: Padding(
            padding: Platform.isIOS
                ? MediaQuery.of(context).size.height >= 812
                    ? EdgeInsets.only(bottom: 34)
                    : EdgeInsets.only(bottom: 0)
                : EdgeInsets.all(0),
            child: TabBar(
              isScrollable: true,
              onTap: (value) {
                setState(() {
                  selectedIndex = value;
                  Constants.showData = Constants.userType == 0
                      ? true
                      : tabsArray[value]['id'] == Constants.userType
                          ? true
                          : false;
                });
              },
              tabs: _getTabs(),
              labelColor: Colors.green,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.all(5.0),
              indicatorColor: Colors.transparent,
            ),
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

//Generating tabs used in the bottom dynamically
  List<Tab> _getTabs() {
    List tabs = List<Tab>();
    for (var i = 0; i < tabsArray.length; i++) {
      tabs.add(Tab(
        icon: tabsArray[i]["icon"],
        text: tabsArray[i]["title"],
      ));
    }
    return tabs;
  }

  _clearDefaultsAndProceed() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("loginStatus", false);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage()));
  }
}
