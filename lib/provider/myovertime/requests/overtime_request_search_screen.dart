import 'dart:convert';

import 'package:bank/api_helper/http_services.dart';
import 'package:bank/constance_routes/overtime_routes.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import 'overtime_request_detail_model.dart';
import 'overtime_request_detail_screen.dart';
import 'overtime_request_item_model.dart';

// ignore: must_be_immutable
class OvertimeSearch extends StatefulWidget {
  OvertimeRequestDetailModel overtimeRequestDetailModel;
  OvertimeSearch({Key key, this.overtimeRequestDetailModel}) : super(key: key);
  @override
  _OvertimeSearchState createState() => _OvertimeSearchState();
}

class _OvertimeSearchState extends State<OvertimeSearch> with HttpService {
  List<OvertimeReqmodel> _overtimeReqmodel = [];
  List<OvertimeReqmodel> searchOvertimeReq = [];
  //GetData
  Future<List> get getData async {
    http.Response response = await get(urlgetOvertimereq);
    if (response.statusCode == 200) {
      return compute(overtimeReqmodelFromMap, response.body);
    } else {
      throw Exception("Response Error ${response.statusCode}");
    }
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          alignment: Alignment.centerLeft,
          height: 40,
          //  margin: EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            onChanged: (String text) {
              setState(() {
                if (text.replaceAll(' ', '').length <= 0) {
                  searchOvertimeReq = [];
                } else {
                  searchOvertimeReq = _overtimeReqmodel
                      .where((element) => element.requesttype
                          .toLowerCase()
                          .contains(text.toLowerCase()))
                      .toList();
                }
              });
            },
            decoration: InputDecoration(
              hintText: "Search Overtime Request...",
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      body: _buildBody,
    );
  }

  get _buildBody {
    return FutureBuilder<List>(
        future: getData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Snapshot Error = ${snapshot.error}"),
            );
          } else {
            if (snapshot.connectionState == ConnectionState.done) {
              _overtimeReqmodel = snapshot.data;
              if (searchOvertimeReq.length == 0) {
                return Container(
                  color: Colors.grey[350],
                  child: Center(
                    child: Text('Search Not Found'),
                  ),
                );
              } else {
                // ignore: missing_required_param
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: Container(
                    color: Colors.grey[350],
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: searchOvertimeReq.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Slidable(
                            key: ValueKey(index),
                            actionPane: SlidableDrawerActionPane(),
                            actions: <Widget>[
                              IconSlideAction(
                                caption: 'Submit To',
                                color: Colors.indigo,
                                icon: Icons.verified_outlined,
                                onTap: () {},
                              ),
                              IconSlideAction(
                                caption: 'Reject',
                                color: Colors.red,
                                icon: Icons.clear,
                                onTap: () {},
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
                                    backgroundColor: Colors.lightBlue,
                                  ),
                                ],
                              ),
                              isThreeLine: true,
                              title: Text(searchOvertimeReq[index].requesttype),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Req Hour: ' +
                                      searchOvertimeReq[index].requestHour),
                                  Text('Status: ' +
                                      searchOvertimeReq[index].requestStatus),
                                  Text('ID: ' + searchOvertimeReq[index].id),
                                ],
                              ),
                              onTap: () {
                                getOvertimeReqDetail(
                                    searchOvertimeReq[index].id);
                              },
                            ),
                          ),
                        );
                      },
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
        });
  }
}
