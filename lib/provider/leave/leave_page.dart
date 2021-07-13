import 'package:bank/api_helper/get_code.dart';
import 'package:bank/provider/leave/approve/leave_unauthz_item_screen.dart';
import 'package:bank/provider/leave/new_request/new_leave_page.dart';
import 'package:bank/provider/leave/requests/leave_request_item_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Leave extends StatefulWidget {
  String codeNames;
  Leave({Key key, this.codeNames}) : super(key: key);
  @override
  _Leave createState() => new _Leave();
}

class _Leave extends State<Leave> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  final _widgetOptions = <Widget>[
    // new LeaveRequestItem(),
    new LeaveReqItemScreen(),
    new LeaveUnAuthzItemScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Leave'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: null);
              }),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                //Get Leave Param for new leave and set to Model
                String res = await CodeName().getCodeNameJson(context);

                if (res == null) {
                  res = await CodeName().getCodeNameJson(context);
                }
                widget.codeNames = res;
                //Then pass value by using Constructure parameter
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewLeave(
                      codeNames: widget.codeNames,
                    ),
                  ),
                ).then((value) => () async {
                      setState(() {
                        // print('lol => object');
                      });
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
