import 'dart:convert';
import 'package:bank/api_helper/get_code.dart';
import 'package:bank/api_helper/http_services.dart';
import 'package:bank/app_utility/app_utilities.dart';
import 'package:bank/provider/leave/new_request/leave_request_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewLeave extends StatefulWidget {
  final String codeNames;

  const NewLeave({Key key, this.codeNames}) : super(key: key);

  @override
  _NewLeaveState createState() => _NewLeaveState();
}

class _NewLeaveState extends State<NewLeave> {
  //Global Key
  // final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  //Set State
  @override
  void initState() {
    super.initState();
    parseJsonToList();
  }

  //DropDown
  CodeName codeNameModel = new CodeName();

  var leaveTypes = new List<CodeName>();
  var reasonTypes = new List<CodeName>();
  var submitTos = new List<CodeName>();
  var numTypes = new List<CodeName>();

  //Controls
  final LeaveRequestModel leaveRequestModel = new LeaveRequestModel();

  var _dtpLeaveFrom =
      TextEditingController(text: AppUtilities.getCurrentDate());
  var _dtpLeaveTo = TextEditingController(text: AppUtilities.getCurrentDate());
  var _dtpFromTime = TextEditingController();
  var _dtpToTime = TextEditingController();
  var _txtUpToDateBalDay = TextEditingController();
  var _txtTakenBal = TextEditingController();
  var _txtMax = TextEditingController();
  var _txtReqDay = TextEditingController();
  var _txtRemark = TextEditingController();
  var _drdLeaveType;

  var _drdReason;
  var _drdSubTo;
  var _drdReqType;

  //Get Leave Param
  Future parseJsonToList() async {
    //1. Read data from widget.codeNames
    var x = widget.codeNames;

    //2. Parse to List
    if (x != null) {
      setState(() {
        leaveTypes = codeNameModel.jsonList(jsonDecode(x), "leaveType");
        reasonTypes = codeNameModel.jsonList(jsonDecode(x), "reason");
        submitTos = codeNameModel.jsonList(jsonDecode(x), "submitTo");
        numTypes = codeNameModel.jsonList(jsonDecode(x), "requestType");
      });
    } else {
      leaveTypes = new List<CodeName>();
      reasonTypes = new List<CodeName>();
      submitTos = new List<CodeName>();
      numTypes = new List<CodeName>();
    }
  }

  Future getLiveReqHis(String pVal) async {
    if (pVal == null || pVal == '') {
      setState(() {
        _txtUpToDateBalDay.text = '';
        _txtTakenBal.text = '';
        _txtMax.text = '';
      });
      return;
    }
    var leaveHis = await LeaveRequestModel().postGetLeaveReqHis(pVal, context);
    if (leaveHis != null) {
      _txtUpToDateBalDay.text = leaveHis.balance;
      _txtTakenBal.text = leaveHis.taken;
      _txtMax.text = leaveHis.entitle;
    } else {
      getLiveReqHis('');
    }
  }

  Future getLeaveDay(String pFromDate, String pToDate, String pFromTime,
      String pToTime, String pLeaveType) async {
    if (pFromDate == null ||
        pToDate == null ||
        pFromTime == null ||
        pToTime == null ||
        pLeaveType == null) {
      setState(() {
        _txtReqDay.text = '';
      });
      return;
    }

    try {
      pFromTime = await AppUtilities.formatTimeTo24H(pFromTime);
      pToTime = await AppUtilities.formatTimeTo24H(pToTime);
    } catch (e) {
      print(e);
    }

    var x = await LeaveRequestModel().postGetLeaveReqDay(
      context,
      pFromDate,
      pToDate,
      pFromTime,
      pToTime,
      pLeaveType,
    );

    setState(() {
      _txtReqDay.text = x;
    });
  }

  @override
  Widget build(BuildContext context) {
    final drdLeaveType = AppUtilities.dropdownSearch(
      'Leave Type *',
      validate: true,
      showSearchBox: true,
      selectedItem:
          AppUtilities.getValueFromLst(leaveTypes, false, true, _drdLeaveType),
      items: List.generate(
        leaveTypes.length,
        (index) => leaveTypes[index].name ?? [],
      ),
      onChanged: (value) {
        setState(() {
          _drdLeaveType =
              AppUtilities.getValueFromLst(leaveTypes, true, false, value);
        });
        getLiveReqHis(_drdLeaveType);
        getLeaveDay(
          _dtpLeaveFrom.text,
          _dtpLeaveTo.text,
          _dtpFromTime.text,
          _dtpToTime.text,
          _drdLeaveType,
        );
      },
    );

    final txtUpToDateBalDay = AppUtilities.textBox(
      _txtUpToDateBalDay,
      'Up-to-Date Ba',
      readOnly: true,
    );

    final txtTakenBalDay = AppUtilities.textBox(
      _txtTakenBal,
      'Taken Bal',
      readOnly: true,
    );

    final txtMaxBalDay = AppUtilities.textBox(
      _txtMax,
      'Maximum Bal',
      readOnly: true,
    );

    final dtpLeaveFrom = AppUtilities.textBox(
      _dtpLeaveFrom,
      'Leave From *',
      readOnly: true,
      onTap: () async {
        DateTime value = DateTime.now();
        value = await HttpService().datePicker(context, value);

        setState(() {
          _dtpLeaveFrom.text = DateFormat('yyyy-MM-dd').format(value);
        });
        getLeaveDay(
          _dtpLeaveFrom.text,
          _dtpLeaveTo.text,
          _dtpFromTime.text,
          _dtpToTime.text,
          _drdLeaveType,
        );
      },
    );

    final dtpLeaveTo = AppUtilities.textBox(
      _dtpLeaveTo,
      'Leave To *',
      readOnly: true,
      onTap: () async {
        DateTime value = DateTime.now();
        value = await HttpService().datePicker(context, value);
        setState(() {
          _dtpLeaveTo.text = DateFormat('yyyy-MM-dd').format(value);
        });
        getLeaveDay(
          _dtpLeaveFrom.text,
          _dtpLeaveTo.text,
          _dtpFromTime.text,
          _dtpToTime.text,
          _drdLeaveType,
        );
      },
    );

    final dtpFromTime = AppUtilities.textBox(
      _dtpFromTime,
      'From Time *',
      readOnly: true,
      validate: true,
      onTap: () async {
        var t = AppUtilities.formatTimeToTimeOfDay(_dtpFromTime.text);
        t = await HttpService().selectTime(context, t);
        setState(() {
          _dtpFromTime.text = "${(t.format(context))}";
        });
        getLeaveDay(
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
      validate: true,
      onTap: () async {
        var t = AppUtilities.formatTimeToTimeOfDay(_dtpToTime.text);

        t = await HttpService().selectTime(context, t);
        setState(() {
          _dtpToTime.text = "${(t.format(context))}";
        });
        getLeaveDay(
          _dtpLeaveFrom.text,
          _dtpLeaveTo.text,
          _dtpFromTime.text,
          _dtpToTime.text,
          _drdLeaveType,
        );
      },
    );

    final txtReqDay = AppUtilities.textBox(
      _txtReqDay,
      'Request Day No *',
      readOnly: true,
    );

    final drdReason = AppUtilities.dropdownSearch(
      'Reason *',
      validate: true,
      showSearchBox: true,
      selectedItem:
          AppUtilities.getValueFromLst(reasonTypes, false, true, _drdReason),
      items: List.generate(
        reasonTypes.length,
        (index) => reasonTypes[index].name,
      ),
      onChanged: (value) {
        setState(() {
          _drdReason =
              AppUtilities.getValueFromLst(reasonTypes, true, false, value);
        });
      },
    );

    var drdSubTo = AppUtilities.dropdownSearch(
      'Submit To *',
      validate: true,
      showSearchBox: true,
      selectedItem:
          AppUtilities.getValueFromLst(submitTos, false, true, _drdSubTo),
      items: List.generate(
        submitTos.length,
        (index) => submitTos[index].name,
      ),
      onChanged: (value) {
        setState(() {
          _drdSubTo =
              AppUtilities.getValueFromLst(submitTos, true, false, value);
        });
      },
    );
    var drdReqType = AppUtilities.dropdownSearch(
      'Request Num Type *',
      validate: true,
      selectedItem:
          AppUtilities.getValueFromLst(numTypes, false, true, _drdReqType),
      items: List.generate(
        numTypes.length,
        (index) => numTypes[index].name,
      ),
      onChanged: (value) {
        setState(() {
          _drdReqType =
              AppUtilities.getValueFromLst(numTypes, true, false, value);
        });
      },
    );

    final txtRemark = AppUtilities.textBox(
      _txtRemark,
      'Remark',
    );

    var btnSubmit = AppUtilities.raisedButton(
      'Submit',
      color: Colors.blue[900],
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          LeaveRequestModel().postCreateLeave(
            context,
            _drdLeaveType,
            _dtpLeaveFrom.text,
            _dtpLeaveTo.text,
            _txtReqDay.text,
            _drdReqType,
            _drdReason,
            _txtRemark.text,
            _dtpFromTime.text,
            _dtpToTime.text,
            _drdSubTo,
          );
        }
      },
    );

    var btnCancel = AppUtilities.raisedButton(
      'Cancel',
      color: Colors.red[900],
      onPressed: () {},
    );

    //Scaffold
    double _height = 10.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Request'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            drdLeaveType,
            SizedBox(height: _height),
            txtUpToDateBalDay,
            SizedBox(height: _height),
            txtTakenBalDay,
            SizedBox(height: _height),
            txtMaxBalDay,
            SizedBox(height: _height),
            dtpLeaveFrom,
            SizedBox(height: _height),
            dtpLeaveTo,
            SizedBox(height: _height),
            dtpFromTime,
            SizedBox(height: _height),
            dtpToTime,
            SizedBox(height: _height),
            txtReqDay,
            SizedBox(height: _height),
            drdReason,
            SizedBox(height: _height),
            drdSubTo,
            SizedBox(height: _height),
            drdReqType,
            SizedBox(height: _height),
            txtRemark,
            Row(
              children: <Widget>[
                Expanded(child: btnSubmit),
                SizedBox(width: 5.0),
                Expanded(child: btnCancel),
              ],
            )
          ],
        ),
      ),
    );
  }
}
