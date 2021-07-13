import 'dart:convert';
import 'package:bank/api_helper/http_services.dart';
import 'package:bank/app_utility/app_utilities.dart';
import 'package:bank/constance_routes/overtime_routes.dart';
import 'package:bank/provider/myovertime/requests/overtime_request_detail_model.dart';
import 'package:bank/provider/myovertime/requests/overtime_request_detail_screen.dart';
import 'package:bank/provider/myovertime/requests/overtime_request_item_model.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'overtime_request_item_model.dart';

// ignore: non_constant_identifier_names
var OvertimeReqkey = GlobalKey<_OvertimeReqState>();

// ignore: must_be_immutable
class OvertimeReq extends StatefulWidget {
  List<OvertimeReqmodel> overtimeReqmodel;
  Key key = OvertimeReqkey;
  OvertimeRequestDetailModel overtimeRequestDetailModel;
  OvertimeReq({Key key, this.overtimeRequestDetailModel, this.overtimeReqmodel})
      : super(key: key);

  @override
  _OvertimeReqState createState() => _OvertimeReqState();
}

class _OvertimeReqState extends State<OvertimeReq> with HttpService {
  // List<OvertimeReqmodel> _overtimeReqmodels = [];
  var _overtimeReqmodels = new List<OvertimeReqmodel>();
  var _overtimeReqmodelsfilter = [];
  List<String> reqType = [
    'All',
    'Review',
    'Rejected',
    'Authorize',
    'Acknowledge'
  ];

  //GetData

  ScrollController _scollController = ScrollController();
  gotoTop() {
    _scollController.animateTo(0,
        duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  Future<List> _getData() async {
    http.Response response = await get(urlgetOvertimereq);
    if (response.statusCode == 200) {
      return compute(overtimeReqmodelFromMap, response.body);
    } else {
      throw Exception("Response Error ${response.statusCode}");
    }
  }

  // Function Reject
  Future<void> functionDelete(String id) async {
    final overtimeRequestDetailModel = new OvertimeRequestDetailModel();
    http.Response rsp = await overtimeRequestDetailModel.getOvertimeRequest(id);
    if (rsp.statusCode == 200) {
      final Map map = jsonDecode(rsp.body);
      widget.overtimeRequestDetailModel =
          OvertimeRequestDetailModel.fromJson(map);
    }
    return await CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      confirmBtnColor: Colors.red[800],
      title: "Delete",
      text: "Would you like to Delete?",
      onConfirmBtnTap: () async {
        //
        Navigator.pop(context, true); //Close Current Dialog
        var body = json
            .encode({"requestId": widget.overtimeRequestDetailModel.requestId});
        http.Response rsp = await post(urlDeleteOvertime, body);

        if (rsp.statusCode == 200) {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            title: "Delete",
            text: "Completed Successfully!",
            onConfirmBtnTap: () {
              Navigator.pop(context);
              setState(() {
                _getData();
              });
            },
          );
        } else {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: "Delete",
            text: rsp.statusCode.toString(),
          );
        }
      },
    );
  }

  List<dynamic> filter({String text = 'All'}) {
    if ((text == null ? 'All' : text) != 'All') {
      // _overtimeReqmodelsfilter = _overtimeReqmodels
      //     .where((element) =>
      //         element.requestStatus.toLowerCase().contains(text.toLowerCase()))
      //     .toList();
      return _overtimeReqmodelsfilter = _overtimeReqmodels
          .where((x) => x.requestStatus.toLowerCase() == text.toLowerCase())
          .toList();
    }
    return _overtimeReqmodelsfilter = _overtimeReqmodels.toList();
  }

  Future getOTItemFuture() async {
    return _overtimeReqmodelsfilter;
  }

  /// Get for InitState
  Future getOTInitState() async {
    var rsp = await OvertimeReqmodel().getovertimeReqs();
    setState(() {
      _overtimeReqmodels = rsp;
      _overtimeReqmodelsfilter = _overtimeReqmodels.toList();
    });
  }

  Future getOTItemsFuture() async {
    return _overtimeReqmodelsfilter;
  }

  @override
  void initState() {
    super.initState();
    getOTInitState();
  }

// GetData to Detail Screen
  Future getOvertimeReqDetail(String id) async {
    final overtimeRequestDetailModel = new OvertimeRequestDetailModel();
    http.Response rsp = await overtimeRequestDetailModel.getOvertimeRequest(id);
    if (rsp.statusCode == 200) {
      final Map map = jsonDecode(rsp.body);
      widget.overtimeRequestDetailModel =
          OvertimeRequestDetailModel.fromJson(map);
      //Navigate to Detail Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OvertimeRequestDetailScreen(
            overtimeRequestDetailModel: widget.overtimeRequestDetailModel,
          ),
        ),
      ).then((value) => {
            setState(() {
              // print('hello world for test');
            })
          });
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: 'Reponse',
        text: rsp.body,
      );
    }
  }

  String _drdReqTyped;

  @override
  Widget build(BuildContext context) {
    final drdReqType = DropdownSearch<String>(
      selectedItem: _drdReqTyped == null ? 'All' : _drdReqTyped,
      maxHeight: 300.0,
      mode: Mode.MENU,
      showClearButton: _drdReqTyped == null ? false : true,
      items: reqType,
      onChanged: (value) {
        setState(() {
          _drdReqTyped = value;
          filter(text: value);
        });
      },
      dropdownSearchDecoration: AppUtilities.dropdownSearchDecoration(),
    );
    return FutureBuilder<List>(
      future: _getData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Snapshot Error = ${snapshot.error}"),
          );
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            _overtimeReqmodels = snapshot.data;
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _overtimeReqmodels = snapshot.data;
                });
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      child: drdReqType,
                      // child: Text('data'),
                      // color: Colors.red,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scollController,
                      physics: BouncingScrollPhysics(),
                      itemCount: _overtimeReqmodelsfilter.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
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
                                caption: 'Delete',
                                color: Colors.red,
                                icon: Icons.clear,
                                onTap: () {
                                  functionDelete(
                                      _overtimeReqmodelsfilter[index].id);
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
                                    backgroundColor: col(
                                        _overtimeReqmodelsfilter[index]
                                            .requestStatus),
                                  ),
                                ],
                              ),
                              isThreeLine: true,
                              title: Text(
                                  _overtimeReqmodelsfilter[index].requesttype),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Req Hour: ' +
                                      _overtimeReqmodelsfilter[index]
                                          .requestHour),
                                  Text('Status: ' +
                                      _overtimeReqmodelsfilter[index]
                                          .requestStatus),
                                  Text('ID: ' +
                                      _overtimeReqmodelsfilter[index].id),
                                ],
                              ),
                              onTap: () {
                                getOvertimeReqDetail(
                                    _overtimeReqmodelsfilter[index].id);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: SpinKitCircle(
                color: Colors.red[900],
                size: 50,
              ),
            );
            // enableLoading(context);
          }
        }
      },
    );
  }

  Color col(String status) {
    var col = Colors.blue[900];
    switch (status) {
      case 'Review':
        {
          col = Colors.yellow[400];
        }
        break;
      case 'Rejected':
        {
          col = Colors.red;
        }
        break;
      case 'Authorize':
        {
          col = Colors.green[400];
        }
        break;
    }

    return col;
  }
}
