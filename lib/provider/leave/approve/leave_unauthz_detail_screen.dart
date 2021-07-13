import 'package:bank/app_utility/app_utilities.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'leave_unauthz_detail_model.dart';

class LeaveUnAuthDetailScreen extends StatefulWidget {
  final LeaveUnAuthByIdModel leaveUnAuth;

  LeaveUnAuthDetailScreen({Key key, @required this.leaveUnAuth})
      : super(key: key);

  @override
  _LeaveUnAuthDetailScreenState createState() =>
      _LeaveUnAuthDetailScreenState();
}

class _LeaveUnAuthDetailScreenState extends State<LeaveUnAuthDetailScreen> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final txtEmpName = TextFormField(
      initialValue: widget.leaveUnAuth.fullName,
      readOnly: true,
      decoration: AppUtilities.textFormFieldDecoration('Employee Name'),
    );

    final txtLeaveType = TextFormField(
      initialValue: widget.leaveUnAuth.typeName,
      readOnly: true,
      decoration: AppUtilities.textFormFieldDecoration('Leave Type'),
    );

    final txtLeaveFrom = TextFormField(
      initialValue: widget.leaveUnAuth.leaveFrom,
      readOnly: true,
      decoration: AppUtilities.textFormFieldDecoration('Leave From'),
    );

    final txtLeaveTo = TextFormField(
      initialValue: widget.leaveUnAuth.leaveTo,
      readOnly: true,
      decoration: AppUtilities.textFormFieldDecoration('Leave To'),
    );

    final txtReqNo = TextFormField(
      initialValue: widget.leaveUnAuth.numReq,
      readOnly: true,
      decoration: AppUtilities.textFormFieldDecoration('Request Number'),
    );

    final txtReqType = TextFormField(
      initialValue: widget.leaveUnAuth.numTypeDesc,
      readOnly: true,
      decoration: AppUtilities.textFormFieldDecoration('Request Type'),
    );

    final txtRemark = TextFormField(
      initialValue: widget.leaveUnAuth.remarks,
      readOnly: true,
      decoration: AppUtilities.textFormFieldDecoration('Remark'),
    );

    final btnApprove = AppUtilities.raisedButton(
      'Approve',
      color: Colors.blue[900],
      onPressed: () {
        LeaveUnAuthByIdModel().postLeaveApp(
          context,
          widget.leaveUnAuth.assignId,
          widget.leaveUnAuth.requestId,
        );
      },
    );

    final btnReject = AppUtilities.raisedButton(
      'Reject',
      color: Colors.red[900],
      onPressed: () {
        LeaveUnAuthByIdModel().postLeaveRej(
          context,
          widget.leaveUnAuth.assignId,
          widget.leaveUnAuth.requestId,
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Leave Unauthorize"),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(20.0), //Border Items Space
          children: <Widget>[
            txtEmpName,
            SizedBox(height: 10.0),
            txtLeaveType,
            SizedBox(height: 10.0),
            txtLeaveFrom,
            SizedBox(height: 10.0),
            txtLeaveTo,
            SizedBox(height: 10.0),
            txtReqNo,
            SizedBox(height: 10.0),
            txtReqType,
            SizedBox(height: 10.0),
            txtRemark,
            Row(
              children: <Widget>[
                Expanded(child: btnApprove),
                SizedBox(width: 5.0),
                Expanded(child: btnReject),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
