import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DarkCharacters {
  final String name;
  final String image;

  DarkCharacters(this.name, this.image);
}

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  Future<List<DarkCharacters>> _getcharactersList() async {
    var data = await http
        .get("http://www.json-generator.com/api/json/get/cefeApdRpe?indent=2");
    var json = jsonDecode(data.body);
    List<DarkCharacters> charactersJson = [];
    for (var casts in json) {
      charactersJson.add(DarkCharacters(casts["name"], casts["image"]));
    }
    return charactersJson;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users Liked"),
      ),
      body: Container(
        child: FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot snapShot) {
              if (snapShot.data == null) {
                return Container(
                    child: Center(
                  child: Text("Sic mundus creatus est..."),
                ));
              } else {
                return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(snapShot.data[index].image),
                        ),
                        title: Text(snapShot.data[index].name),
                      );
                    },
                    itemCount: snapShot.data.length);
              }
            },
            future: _getcharactersList()),
      ),
    );
  }
}
