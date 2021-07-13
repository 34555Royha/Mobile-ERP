import 'dart:convert';

import 'package:bank/api_helper/http_services.dart';
import 'package:bank/constance_routes/overtime_routes.dart';
import 'package:bank/provider/myovertime/approve/overtime_approve_item.dart';
import 'package:bank/provider/myovertime/new_request/search_submitto_model.dart';
import 'package:bank/provider/myovertime/requests/overtime_request_item.dart';
import 'package:bank/provider/myovertime/requests/overtime_request_item_model.dart';
import 'package:bank/provider/myovertime/requests/overtime_request_search_screen.dart';
import 'package:bank/provider/myovertime/search/search_model.dart';
import 'package:flutter/material.dart';
import 'new_request/new_overtime_page.dart';
import 'package:http/http.dart' as http;

class MyOverTime extends StatefulWidget {
  MyOverTimeState createState() => MyOverTimeState();
}

class MyOverTimeState extends State<MyOverTime> with HttpService {
  List<SearchmodelS> searchlistbytext = [];
  List<OvertimeReqmodel> overtimeReqmodel = [];
  SearchSubmitToModel searchSubmitToModel = new SearchSubmitToModel();

  Future getData() async {
    http.Response rsp = await get(urlgetOvertimereq);
    if (rsp.statusCode == 200) {
      overtimeReqmodel = (jsonDecode(rsp.body) as List)
          .map((e) => OvertimeReqmodel.fromMap(e))
          .toList();
      print(overtimeReqmodel[1].requestHour);
    } else {
      // leaveReqItems = new List<LeaveReqModel>();
    }

    // return leaveReqItems;
  }

  // OvertimeReq d = new OvertimeReq(overtimeReqmodel: overtimeReqmodel);
  OvertimeApp overtimeApp = OvertimeApp();
  OvertimeReq overtimeReq = OvertimeReq();

  List<Widget> pageMyOvertime = [];

  final _widgetOptions = <Widget>[
    new OvertimeReq(),
    new OvertimeApp(),
  ];

  int _selectedIndex = 0;
  int _prevIndex = -1;

  void _onItemTapped(int index) {
    setState(() {
      _prevIndex = _selectedIndex;
      _selectedIndex = index;
      if (_prevIndex == _selectedIndex) {
        switch (_selectedIndex) {
          case 0:
            OvertimeReqkey.currentState.gotoTop();
            break;
          case 1:
            OvertimeAppkeys.currentState.gotoTop();
            break;
        }
      }
    });
  }

  Future body() async {
    return Center(
      child: _widgetOptions.elementAt(_selectedIndex),
    );
  }

  @override
  void initState() {
    super.initState();
    Test().getData();
    getData();
    pageMyOvertime.add(overtimeReq);
    pageMyOvertime.add(overtimeApp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Overtime'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OvertimeSearch()));
              }),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewOvertime(
                              searchSubmitToModel: searchSubmitToModel,
                            ))).then((value) => {
                      setState(() {}),
                    });
              })
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.table_view),
            label: 'Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_outlined),
            label: 'Approve',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[900],
        onTap: _onItemTapped,
      ),
    );
  }
}
