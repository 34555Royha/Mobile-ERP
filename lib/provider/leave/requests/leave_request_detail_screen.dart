import 'dart:convert';

import 'package:bank/api_helper/get_code.dart';
import 'package:bank/api_helper/http_services.dart';
import 'package:bank/app_utility/app_utilities.dart';
import 'package:bank/provider/leave/new_request/leave_entitle_model.dart';
import 'package:bank/provider/leave/requests/leave_delete_model.dart';
import 'package:bank/provider/leave/requests/leave_request_detail_model.dart';
import 'package:bank/provider/leave/requests/leave_update_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class LeaveRequestDetailScreen extends StatefulWidget {
  //Constructor
  final LeaveRequestDetailModel leaveRequestDetailModel;
  final String codeName;

  const LeaveRequestDetailScreen(
      {Key key, this.leaveRequestDetailModel, this.codeName})
      : super(key: key);

  @override
  _LeaveRequestDetailScreenState createState() =>
      _LeaveRequestDetailScreenState();
}

class _LeaveRequestDetailScreenState extends State<LeaveRequestDetailScreen>
    with HttpService {
  final _formKey = GlobalKey<FormState>();

  @required
  void initState() {
    super.initState();
    dataLeaveReq();
  }

  //Lists of Model
  var leaveTypes = new List<CodeName>();
  var reasonTypes = new List<CodeName>();
  var submitTos = new List<CodeName>();
  var reqTypes = new List<CodeName>();

  String _drdLeaveType, _drdReason, _drdSubTo, _drdReqType;

  var _dtpLeaveFrom = new TextEditingController();
  var _dtpLeaveTo = new TextEditingController();
  var _dtpFromTime = new TextEditingController();
  var _dtpToTime = new TextEditingController();
  var _txtUpToDateBalDay = new TextEditingController();
  var _txtTakenBalDay = new TextEditingController();
  var _txtReqDay = new TextEditingController();
  var _txtMaxBalDay = new TextEditingController();
  var _txtRemark = new TextEditingController();

  void dataLeaveReq() async {
    //
    var x = widget.leaveRequestDetailModel;
    var wCNs = widget.codeName;

    //Set TextValue
    _dtpLeaveFrom.text = x.leaveFrom;
    _dtpLeaveTo.text = x.leaveTo;
    _dtpFromTime.text = x.startTime;
    _dtpToTime.text = x.endTime;
    _txtUpToDateBalDay.text = x.balance;
    _txtTakenBalDay.text = x.taken;
    _txtMaxBalDay.text = x.entitlement;
    _dtpLeaveFrom.text = x.leaveFrom;
    _dtpLeaveTo.text = x.leaveTo;
    _dtpFromTime.text = await AppUtilities.formatDateTimeTo12H(x.startTime);
    _dtpToTime.text = await AppUtilities.formatDateTimeTo12H(x.endTime);
    _txtReqDay.text = x.numReq;
    _txtRemark.text = x.remarks;

    //Set Value for dropDownValue
    _drdLeaveType = x.ltypeId;
    _drdReason = x.reasonType;
    _drdSubTo = x.assignId;
    _drdReqType = x.numType;

    setState(() {
      leaveTypes = CodeName().jsonList(jsonDecode(wCNs), 'leaveType');
      reasonTypes = CodeName().jsonList(jsonDecode(wCNs), 'reason');
      submitTos = CodeName().jsonList(jsonDecode(wCNs), 'submitTo');
      reqTypes = CodeName().jsonList(jsonDecode(wCNs), 'requestType');
    });
  }

  void getLeaveReqHis(String lTypeId) async {
    EntitleModel x = new EntitleModel();
    x = await x.getLeaveHis(context, lTypeId);

    setState(() {
      _txtUpToDateBalDay.text = x.balance == null ? '' : x.balance;
      _txtTakenBalDay.text = x.taken == null ? '' : x.taken;
      _txtMaxBalDay.text = x.entitle == null ? '' : x.entitle;
    });
  }

  void getLeaveBalDay(pFDate, pTDate, pFTime, pTTime, pLType) async {
    EntitleModel x = new EntitleModel();
    var rsp =
        await x.getLeaveBalDay(context, pFDate, pTDate, pFTime, pTTime, pLType);
    setState(() {
      _txtReqDay.text = rsp;
    });
  }

  void updateLeaveReq() async {
    //
    LeaveUpdateModel leaveUpdateModel = new LeaveUpdateModel(
      assignId: _drdSubTo,
      leaveFrom: _dtpLeaveFrom.text +
          'T' +
          await AppUtilities.formatTimeTo24H(_dtpFromTime.text),
      leaveTo: _dtpLeaveTo.text +
          'T' +
          await AppUtilities.formatTimeTo24H(_dtpToTime.text),
      ltypeId: _drdLeaveType,
      numReq: _txtReqDay.text,
      numType: _drdReqType,
      reasonType: _drdReason,
      remarks: _txtRemark.text,
      requestId: widget.leaveRequestDetailModel.requestId,
      schClassId: widget.leaveRequestDetailModel.schClassId,
      valueDate: widget.leaveRequestDetailModel.valueDate,
    );

    var body = jsonEncode(leaveUpdateModel.toJson());

    leaveUpdateModel.updateLeaveReq(context, body);
  }

  @override
  Widget build(BuildContext context) {
    //Create new object for widget
    var leaves = widget.leaveRequestDetailModel;

    final drdLeaveType = AppUtilities.dropdownSearch(
      'Leave Type *',
      showSearchBox: true,
      validate: true,
      selectedItem: _drdLeaveType == null
          ? leaves.typeName
          : AppUtilities.getValueFromLst(
              leaveTypes, false, true, _drdLeaveType),
      items: List.generate(
        leaveTypes.length,
        (index) => leaveTypes[index].name,
      ),
      onChanged: (value) {
        setState(() {
          _drdLeaveType = value == null
              ? null
              : AppUtilities.getValueFromLst(leaveTypes, true, false, value);
          leaves.typeName = _drdLeaveType;
          getLeaveReqHis(_drdLeaveType);
          getLeaveBalDay(
            _dtpLeaveFrom.text,
            _dtpLeaveTo.text,
            _dtpFromTime.text,
            _dtpToTime.text,
            _drdLeaveType,
          );
        });
      },
    );

    final txtUpToDateBalDay = AppUtilities.textBox(
      _txtUpToDateBalDay,
      'Up-to-Date Bal. *',
      readOnly: true,
    );

    final txtTakenBalDay = AppUtilities.textBox(
      _txtTakenBalDay,
      'Taken Bal',
      readOnly: true,
    );

    final txtMaxBalDay = AppUtilities.textBox(
      _txtMaxBalDay,
      'Maximum Bal',
      readOnly: true,
    );

    final dtpLeaveFrom = AppUtilities.textBox(
      _dtpLeaveFrom,
      'Leave From *',
      readOnly: true,
      onTap: () async {
        DateTime value = DateTime.now();
        value = await datePicker(context, value);
        setState(() {
          _dtpLeaveFrom.text = DateFormat('yyyy-MM-dd').format(value);

          //Get Leave Req Day
          getLeaveBalDay(
            _dtpLeaveFrom.text,
            _dtpLeaveTo.text,
            _dtpFromTime.text,
            _dtpToTime.text,
            _drdLeaveType,
          );
        });
      },
    );

    final dtpLeaveTo = AppUtilities.textBox(
      _dtpLeaveTo,
      'Leave To *',
      readOnly: true,
      onTap: () async {
        DateTime value = DateTime.now();
        value = await datePicker(context, value);
        setState(() {
          _dtpLeaveTo.text = DateFormat('yyyy-MM-dd').format(value);
          getLeaveBalDay(
            _dtpLeaveFrom.text,
            _dtpLeaveTo.text,
            _dtpFromTime.text,
            _dtpToTime.text,
            _drdLeaveType,
          );
        });
      },
    );

    final dtpFromTime = AppUtilities.textBox(
      _dtpFromTime,
      'Leave From *',
      readOnly: true,
      onTap: () async {
        var t = TimeOfDay.now();
        t = await selectTime(context, t);
        setState(() {
          _dtpFromTime.text = "${(t.format(context))}";
        });
        getLeaveBalDay(
          _dtpLeaveFrom.text,
          _dtpLeaveTo.text,
          _dtpFromTime.text,
          _dtpToTime.text,
          _drdLeaveType,
        );
      },
    );

    final dtpToTime = AppUtilities.textBox(
      _dtpToTime,
      'To Time *',
      readOnly: true,
      onTap: () async {
        var t = TimeOfDay.now();
        t = await selectTime(context, t);
        setState(() {
          _dtpToTime.text = "${(t.format(context))}";
        });
      },
    );

    final txtReqDay = AppUtilities.textBox(
      _txtReqDay,
      'From Time *',
      readOnly: true,
    );

    final drdReason = AppUtilities.dropdownSearch(
      'Reason *',
      showSearchBox: true,
      validate: true,
      selectedItem: _drdReason == null
          ? leaves.reasonDesc
          : AppUtilities.getValueFromLst(reasonTypes, false, true, _drdReason),
      items: List.generate(
        reasonTypes.length,
        (index) => reasonTypes[index].name,
      ),
      onChanged: (value) {
        setState(() {
          _drdReason = value == null
              ? null
              : AppUtilities.getValueFromLst(reasonTypes, true, false, value);
          leaves.reasonDesc = _drdReason;
        });
      },
    );
    final drdSubTo = AppUtilities.dropdownSearch(
      'Submit To *',
      showSearchBox: true,
      validate: true,
      selectedItem: _drdSubTo == null
          ? leaves.assignName
          : AppUtilities.getValueFromLst(submitTos, false, true, _drdSubTo),
      items: List.generate(
        submitTos.length,
        (index) => submitTos[index].name,
      ),
      onChanged: (value) {
        setState(() {
          _drdSubTo = value == null
              ? null
              : AppUtilities.getValueFromLst(submitTos, true, false, value);

          leaves.assignName = _drdSubTo;
        });
      },
    );
    final drdReqType = AppUtilities.dropdownSearch(
      'Request Num Type *',
      validate: true,
      selectedItem: _drdReqType == null
          ? leaves.numTypeDesc
          : AppUtilities.getValueFromLst(reqTypes, false, true, _drdReqType),
      items: List.generate(
        reqTypes.length,
        (index) => reqTypes[index].name,
      ),
      onChanged: (value) {
        setState(() {
          _drdReqType = value == null
              ? null
              : AppUtilities.getValueFromLst(reqTypes, true, false, value);
          leaves.numTypeDesc = _drdReqType;
        });
      },
    );

    final txtRemark = AppUtilities.textBox(
      _txtRemark,
      'Remark',
    );

    final btnUpdate = AppUtilities.raisedButton(
      'Update',
      color: Colors.blue[900],
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          updateLeaveReq();
        }
      },
    );

    final btnDelete = AppUtilities.raisedButton(
      'Delete',
      color: Colors.red[900],
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          var id = widget.leaveRequestDetailModel.requestId;
          LeaveDeleteModel().deleteLeaveReq(context, id);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Request Detail'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: <Widget>[
            drdLeaveType,
            SizedBox(height: 10.0),
            txtUpToDateBalDay,
            SizedBox(height: 10.0),
            txtTakenBalDay,
            SizedBox(height: 10.0),
            txtMaxBalDay,
            SizedBox(height: 10.0),
            dtpLeaveFrom,
            SizedBox(height: 10.0),
            dtpLeaveTo,
            SizedBox(height: 10.0),
            dtpFromTime,
            SizedBox(height: 10.0),
            dtpToTime,
            SizedBox(height: 10.0),
            txtReqDay,
            SizedBox(height: 10.0),
            drdReason,
            SizedBox(height: 10.0),
            drdSubTo,
            SizedBox(height: 10.0),
            drdReqType,
            SizedBox(height: 10.0),
            txtRemark,
            Row(
              children: <Widget>[
                Expanded(child: btnUpdate),
                SizedBox(width: 5.0),
                Expanded(child: btnDelete),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
