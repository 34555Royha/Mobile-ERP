import 'dart:convert';

import 'package:bank/api_helper/http_services.dart';
import 'package:bank/constance_routes/overtime_routes.dart';
import 'package:bank/provider/myovertime/approve/overtime_approve_item_model.dart';
import 'package:bank/provider/myovertime/requests/overtime_request_detail_model.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import 'overtime_approve_detail_screen.dart';
import 'overtime_qpprove_detail_model.dart';

// ignore: non_constant_identifier_names
var OvertimeAppkeys = GlobalKey<_OvertimeAppState>();

// ignore: must_be_immutable
class OvertimeApp extends StatefulWidget {
  Key key = OvertimeAppkeys;
  OvertimeApprovetDetailModel overtimeApprovetDetailModel;
  OvertimeApp({Key key, this.overtimeApprovetDetailModel}) : super(key: key);
  @override
  _OvertimeAppState createState() => _OvertimeAppState();
}

class _OvertimeAppState extends State<OvertimeApp> with HttpService {
  List<OvertimeModel> _overtimemodel = [];

  // ignore: missing_return
  Future<List> _getData() async {
    http.Response response = await get(urlgetOvertimeApp);
    if (response.statusCode == 200) {
      return compute(overtimeModelFromMap, response.body);
    } else {
      alertRsp(context, response);
      // throw Exception("Error ${response.statusCode}");
    }
  }

  // Function Reject
  Future<void> functionReject(String id) async {
    final overtimeRequestDetailModel = new OvertimeRequestDetailModel();

    http.Response rsp = await overtimeRequestDetailModel.getOvertimeRequest(id);

    if (rsp.statusCode == 200) {
      final Map map = jsonDecode(rsp.body);
      widget.overtimeApprovetDetailModel =
          OvertimeApprovetDetailModel.fromJson(map);
    }

    return await CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      confirmBtnColor: Colors.red[800],
      title: "Reject",
      text: "Would you like to Reject?",
      onConfirmBtnTap: () async {
        Navigator.pop(context, true); //Close Current Dialog
        var body = json.encode({
          "requestId": widget.overtimeApprovetDetailModel.requestId,
          "assignId": widget.overtimeApprovetDetailModel.assignId,
        });
        http.Response rsp = await post(urlRejectOvertime, body);
        if (rsp.statusCode == 200) {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            title: "Reject",
            text: "Completed Successfully!",
            onConfirmBtnTap: () {
              Navigator.pop(context);
              setState(() {
                _getData();
              });
            },
          );
          //Success => should route to list screen
        } else {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: "Reject",
            text: rsp.statusCode.toString(),
          );
        }
      },
    );
  }

  ScrollController _scollController = ScrollController();
  void gotoTop() {
    _scollController.animateTo(0,
        duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  // @override
  // void initState() {
  //   try {} catch (e) {}
  //   super.initState();
  // }
  // GetData to Detail Screen

  Future getOvertimeReqDetail(String id) async {
    final overtimeRequestDetailModel = new OvertimeRequestDetailModel();
    http.Response rsp = await overtimeRequestDetailModel.getOvertimeRequest(id);
    if (rsp.statusCode == 200) {
      final Map map = jsonDecode(rsp.body);
      widget.overtimeApprovetDetailModel =
          OvertimeApprovetDetailModel.fromJson(map);
      //Navigate to Detail Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OvertimeApproveDetailScreen(
            overtimeApprovetDetailModel: widget.overtimeApprovetDetailModel,
          ),
        ),
      ).then(
        (value) => {
          setState(
            () {
              // print('hello world for test');
            },
          )
        },
      );
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: 'Reponse',
        text: rsp.body,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error snashot : ${snapshot.error}"),
          );
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            _overtimemodel = snapshot.data;
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _overtimemodel = snapshot.data;
                });
              },
              child: ListView.builder(
                controller: _scollController,
                physics: BouncingScrollPhysics(),
                itemCount: _overtimemodel.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ViewPage(
                      //               overtimeModel: _overtime[index],
                      //             )));
                    },
                    child: Card(
                      child: Slidable(
                        key: ValueKey(index),
                        actionPane: SlidableDrawerActionPane(),
                        actions: <Widget>[
                          // IconSlideAction(
                          //   caption: 'Submit To',
                          //   color: Colors.indigo,
                          //   icon: Icons.verified_outlined,
                          //   onTap: () {},
                          // ),
                          IconSlideAction(
                            caption: 'Reject',
                            color: Colors.red,
                            icon: Icons.clear,
                            onTap: () {
                              functionReject(_overtimemodel[index].id);
                            },
                          ),
                        ],
                        dismissal: SlidableDismissal(
                          child: SlidableDrawerDismissal(),
                        ),
                        child: ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                // backgroundImage: AssetImage('assets/sun.jpg'),
                                backgroundColor: Colors.blue[900],
                              ),
                            ],
                          ),
                          isThreeLine: true,
                          title: Text(_overtimemodel[index].requesttype),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Req Hour: ' +
                                  _overtimemodel[index].requestHour),
                              Text('Status: ' +
                                  _overtimemodel[index].requestStatus),
                              Text('ID: ' + _overtimemodel[index].id),
                            ],
                          ),
                          onTap: () {
                            getOvertimeReqDetail(_overtimemodel[index].id);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(
              child: SpinKitCircle(
                color: Colors.red[900],
                size: 50,
              ),
              // child: CircularProgressIndicator(),
            );
          }
        }
      },
    );
  }
}
