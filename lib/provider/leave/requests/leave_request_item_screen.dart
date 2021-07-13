import 'package:bank/api_helper/get_code.dart';
import 'package:bank/app_utility/app_utilities.dart';
import 'package:bank/provider/leave/requests/leave_request_detail_model.dart';
import 'package:bank/provider/leave/requests/leave_request_detail_screen.dart';
import 'package:bank/provider/leave/requests/leave_request_item_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// ignore: must_be_immutable
class LeaveReqItemScreen extends StatefulWidget {
  LeaveRequestDetailModel leaveReqDetailModel;
  String codeName;
  // const LeaveReqItemScreen({Key key, this.leaveReqDetailModel}) : super(key: key);
  LeaveReqItemScreen({
    Key key,
    this.leaveReqDetailModel,
    this.codeName,
  }) : super(key: key);
  @override
  _LeaveReqItemScreenState createState() => _LeaveReqItemScreenState();
}

class _LeaveReqItemScreenState extends State<LeaveReqItemScreen> {
  // var _formKey = GlobalKey<FormState>();
  var leaveReqItems = new List<LeaveReqModel>();
  var leaveReqItemsFileter = [];
  List<String> reqType = ['Request', 'Reject', 'Acknowledge'];

  @override
  void initState() {
    super.initState();
    getLeavesInitState();
  }

  ///Get Leave Req and then push to detail screen
  ///
  Future getLeaveReqDetail(String id) async {
    //Get data
    var x = await LeaveRequestDetailModel().getLeave(context, id);
    var codeName = await CodeName().getCodeNameJson(context);

    widget.leaveReqDetailModel = x;
    widget.codeName = codeName;

    // Push to Detail Screen and setState for refresh
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LeaveRequestDetailScreen(
          leaveRequestDetailModel: widget.leaveReqDetailModel,
          codeName: widget.codeName,
        ),
      ),
    ).then((value) {
      setState(() {
        //refresh page of state one
      });
    });
  }

  /// Get for InitState
  Future getLeavesInitState() async {
    var rsp = await LeaveReqModel().getLeaveReqs();
    setState(() {
      leaveReqItems = rsp;
      leaveReqItemsFileter = leaveReqItems.toList();
    });
  }

  /// For Filter Local List
  List<dynamic> fielterLeaveReqItems({String reqStatus = 'All'}) {
    // print(reqStatus);
    if ((reqStatus == null ? 'All' : reqStatus) != 'All') {
      leaveReqItemsFileter = [];
      return leaveReqItemsFileter = leaveReqItems
          .where((element) => element.requestStatus == reqStatus)
          .toList();
    }
    return leaveReqItemsFileter = leaveReqItems.toList();
  }

  /// For Future Builder
  Future getLeaveItemsFuture() async {
    return leaveReqItems;
  }

  String _drdReqType;

  @override
  Widget build(BuildContext context) {
    final drdReqType = DropdownSearch<String>(
      selectedItem: _drdReqType == null ? 'All' : _drdReqType,
      maxHeight: 300.0,
      mode: Mode.DIALOG,
      showClearButton: _drdReqType == null ? false : true,
      items: reqType,
      onChanged: (value) {
        setState(() {
          _drdReqType = value;
          fielterLeaveReqItems(reqStatus: value);
        });
      },
      dropdownSearchDecoration: AppUtilities.dropdownSearchDecoration(),
    );

    return FutureBuilder(
      key: UniqueKey(),
      future: getLeaveItemsFuture(),
      builder: (context, snapshot) {
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
                    _drdReqType = null;
                    leaveReqItemsFileter = snapshot.data;
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
                        controller: ScrollController(),
                        physics: BouncingScrollPhysics(),
                        itemCount: leaveReqItemsFileter.length,
                        itemBuilder: (context, index) {
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
                                )
                              ],
                              dismissal: SlidableDismissal(
                                child: SlidableDrawerDismissal(),
                              ),
                              child: ListTile(
                                leading: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundColor: col(
                                          leaveReqItemsFileter[index]
                                              .requestStatus),
                                    )
                                  ],
                                ),
                                isThreeLine: true,
                                title: Text(
                                    leaveReqItemsFileter[index].requestType),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('From date: ' +
                                        leaveReqItemsFileter[index]
                                            .requestFrom),
                                    Text('To date: ' +
                                        leaveReqItemsFileter[index].requestTo),
                                    Text('Req. day: ' +
                                        leaveReqItemsFileter[index]
                                            .requestDay
                                            .toString()),
                                    Text('Status: ' +
                                        leaveReqItemsFileter[index]
                                            .requestStatus),
                                    Text('Id: ' +
                                        leaveReqItemsFileter[index]
                                            .id
                                            .toString()),
                                  ],
                                ),
                                onTap: () => getLeaveReqDetail(
                                  leaveReqItemsFileter[index].id.toString(),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
        }
      },
    );
  }

  Color col(String status) {
    var col = Colors.blue[900];
    switch (status) {
      case 'Request':
        {
          col = Colors.yellow;
        }
        break;
      case 'Reject':
        {
          col = Colors.red;
        }
        break;
    }

    return col;
  }
}
