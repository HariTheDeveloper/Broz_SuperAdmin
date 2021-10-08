import 'dart:async';

import 'package:broz_admin/Tabs/CustomerProfiles/customer_show_screen.dart';
import 'package:flutter/material.dart';

class CustomerSearchBar extends StatefulWidget {
  final ValueChanged<String> onSearchTextChanged;
  const CustomerSearchBar({Key key, @required this.onSearchTextChanged})
      : super(key: key);

  @override
  _CustomerSearchBarState createState() => _CustomerSearchBarState();
}

class _CustomerSearchBarState extends State<CustomerSearchBar> {
  bool isLoading = true;
  bool isSearchData = false;
  bool showLinearLoader = false;
  Timer _searchOnStoppedTyping;
  bool _showClear = false;
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        child: Container(
            color: Colors.green,
            child: Column(
              children: [
                _searchBarWidget(),
                StreamBuilder<Object>(
                    stream: processRunning,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data) {
                          return PreferredSize(
                              child: Container(
                                height: 2,
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.grey,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              preferredSize: Size.fromHeight(2.0));
                        } else {
                          return SizedBox.shrink();
                        }
                      } else {
                        return SizedBox.shrink();
                      }
                    }),
              ],
            )),
        preferredSize: Size.fromHeight(45.0));
  }

  _searchBarWidget() {
    return Padding(
        padding: const EdgeInsets.all(8),
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
                        hintText: "Search Customers",
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      )),
                ),
              ],
            )));
  }

  onSearchTextChanged(String text) async {
    isProcessRunning.add(true);

    const duration = Duration(
        milliseconds:
            800); // set the duration that you want call search() after that.
    if (_searchOnStoppedTyping != null) _searchOnStoppedTyping.cancel();
    setState(() => _searchOnStoppedTyping = new Timer(duration, () {
          widget.onSearchTextChanged(text);
        }));
  }
}
