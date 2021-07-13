import 'dart:convert';

import 'package:bank/provider/leave/approve/leave_unauthz_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import 'leave_unauthz_detail_model.dart';
import 'leave_unauthz_item_model.dart';

// ignore: must_be_immutable
class LeaveUnAuthzItemScreen extends StatefulWidget {
  LeaveUnAuthByIdModel leaveUnAuthIds;

  LeaveUnAuthzItemScreen({Key key, this.leaveUnAuthIds}) : super(key: key);

  @override
  _LeaveUnAuthzItemScreenState createState() => _LeaveUnAuthzItemScreenState();
}

class _LeaveUnAuthzItemScreenState extends State<LeaveUnAuthzItemScreen> {
  @override
  void initState() {
    super.initState();
    leaveInit();
  }

  final _leaveUnAuthModel = new LeaveUnAuthsModel();
  var _leaveUnAuths = [];

  Future<List> leaveInit() async {
    var rsp = await _leaveUnAuthModel.getLeaveUnAuths();

    setState(() {
      _leaveUnAuths = (jsonDecode(rsp.body) as List)
          .map((e) => LeaveUnAuthsModel.fromJson(e))
          .toList();
    });
    return _leaveUnAuths;
  }

  Future leaveFuture() async {
    return _leaveUnAuths;
  }

  Future getLeaveReqDetail(String id) async {
    final _leaveUnAuthByIdModel = new LeaveUnAuthByIdModel();

    http.Response rsp = await _leaveUnAuthByIdModel.getLeaveUnAuthsByID(id);

    final Map parsed = json.decode(rsp.body);

    widget.leaveUnAuthIds = LeaveUnAuthByIdModel.fromJson(parsed);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LeaveUnAuthDetailScreen(leaveUnAuth: widget.leaveUnAuthIds),
      ),
    ).then((value) => {setState(() {})});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: UniqueKey(),
      future: leaveFuture(),
      builder: (context, snapshot) {
        //Check Connection
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: SpinKitCircle(
                color: Colors.red[900],
                size: 50,
              ),
            );
            break;
          default:
            if (snapshot.hasError) {
              Center(
                child: SpinKitCircle(
                  color: Colors.red[900],
                  size: 50,
                ),
              );
              if (snapshot.data == null) {
                return Text('Data not found!');
              } else {
                return Text('Error: ${snapshot.error}');
              }
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _leaveUnAuths = snapshot.data;
                  });
                },
                child: ListView.builder(
                  controller: ScrollController(),
                  itemCount: _leaveUnAuths.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Slidable(
                        key: ValueKey(index),
                        actionPane: SlidableDrawerActionPane(),
                        actions: [
                          IconSlideAction(
                            caption: 'Reject',
                            color: Colors.red,
                            icon: Icons.clear,
                            onTap: () {},
                          )
                        ],
                        dismissal: SlidableDismissal(
                          child: SlidableDrawerDismissal(),
                        ),
                        child: ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.blue,
                              )
                            ],
                          ),
                          isThreeLine: true,
                          title:
                              Text(_leaveUnAuths[index].requestType.toString()),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('From: ' + _leaveUnAuths[index].requestFrom),
                              Text('To: ' + _leaveUnAuths[index].requestTo),
                              Text('Req. Amt.: ' +
                                  _leaveUnAuths[index].requestDay.toString()),
                              Text('Status: ' +
                                  _leaveUnAuths[index].requestStatus),
                              Text('Trn ID: ' +
                                  _leaveUnAuths[index].id.toString()),
                            ],
                          ),
                          onTap: () => {
                            getLeaveReqDetail(
                                _leaveUnAuths[index].id.toString()),
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            }
        }
      },
    );
  }

  // Widget stackBehindDimiss() {
  //   return Container(
  //     alignment: Alignment.centerRight,
  //     padding: EdgeInsets.only(right: 20.0),
  //     color: Colors.red,
  //     child: Icon(
  //       Icons.delete,
  //       color: Colors.white,
  //     ),
  //   );
  // }
}
