import 'dart:convert';

import 'package:bank/provider/leave/leave_page.dart';
import 'package:bank/provider/myovertime/myovertime_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import 'menu_model.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _menu = new Menu();
  // var _menus = new List<Menu>();
  List<Menu> _menus = [];
  List<Menu> _menusearch = [];

  //Local Method
  void menuClick(String id) {
    if (id == "myleave") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Leave()));
    } else if (id == "myovertime") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyOverTime()));
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Unknown App'),
        ),
      );
    }
  }

  //Local Method for Perfoming Data from API
  Future getData() async {
    http.Response response = await _menu.getMenu("");

    Iterable list = json.decode(response.body);

    // setState(() {
    _menus = list.map((model) => Menu.fromJson(model)).toList();
    // });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Container(
            child: TextField(
              onChanged: (text) {
                setState(() {
                  _menusearch = _menus
                      .where((element) => element.funcDesc
                          .toLowerCase()
                          .contains(text.toLowerCase()))
                      .toList();
                });
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                // labelText: 'd',
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.white),
                focusColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                fillColor: Colors.white,
                border: InputBorder.none,
              ),
            ),
          )),
      body: _buildBody,
    );
  }

  get _buildBody {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Snapshot Error : ${snapshot.error}'),
          );
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            if (_menusearch.isEmpty) {
              return Container(
                child: Center(
                  child: Text('Search Not Found'),
                ),
              );
            } else {
              return Container(
                // color: Colors.grey[350],
                child: GridView.count(
                  crossAxisCount: 2, //2 => 2D
                  padding: EdgeInsets.all(16.0),
                  childAspectRatio: 8.0 / 9.0,
                  children: List.generate(
                    _menusearch.length, //Cound menu list
                    (index) => Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        splashColor: Colors.blue,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 18.0 / 11.0,
                              // child: Image.asset('assets/diamond.png'),
                              child: Icon(Icons.time_to_leave_sharp),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //Set Text Menu
                                  Text(_menusearch[index].funcDesc),
                                  // SizedBox(height: 8.0),
                                  Text('Secondary Text'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          menuClick(_menusearch[index].webModule);
                        },
                      ),
                    ),
                  ),
                ),
              );
            }
          } else {
            return Container(
              color: Colors.grey[350],
              child: Center(
                child: SpinKitCircle(
                  color: Colors.red[900],
                  size: 50,
                ),
              ),
            );
          }
        }
      },
    );
  }
}
