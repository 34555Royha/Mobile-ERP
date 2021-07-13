import 'dart:convert';
import 'dart:ui';
import 'package:bank/api_helper/error_response_model.dart';
import 'package:bank/api_helper/get_code.dart';
import 'package:bank/api_helper/http_services.dart';
import 'package:bank/app_utility/app_utilities.dart';
import 'package:bank/constance_routes/overtime_routes.dart';
import 'package:bank/provider/myovertime/new_request/search_submitto.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'overtime_approve_model.dart';
import 'overtime_qpprove_detail_model.dart';

class OvertimeApproveDetailScreen extends StatefulWidget {
  final OvertimeApprovetDetailModel overtimeApprovetDetailModel;
  const OvertimeApproveDetailScreen({Key key, this.overtimeApprovetDetailModel})
      : super(key: key);
  @override
  _OvertimeApproveDetailScreenState createState() =>
      _OvertimeApproveDetailScreenState();
}

class _OvertimeApproveDetailScreenState
    extends State<OvertimeApproveDetailScreen> with HttpService {
  final _formKey = GlobalKey<FormState>();
  DateTime _overtimefromdate = DateTime.now();
  DateTime _overtimetodate = DateTime.now();

  CodeName codeNameModel = new CodeName();
  List<CodeName> otType = new List<CodeName>();
  List<CodeName> reasonType = new List<CodeName>();
  List<CodeName> submitTO = new List<CodeName>();

  //Get Data for each of above lists
  Future getData() async {
    http.Response rsp = await codeNameModel.getCodeName(urlovertimegetParams);

    if (rsp.statusCode == 200) {
      setState(() {
        otType = codeNameModel.jsonList(json.decode(rsp.body), "ottype");
        reasonType =
            codeNameModel.jsonList(json.decode(rsp.body), "reasonType");
        submitTO = codeNameModel.jsonList(json.decode(rsp.body), "submitTo");
      });
    } else {
      throw Exception(ErrorResponse);
    }
  }

  // ignore: unused_field
  String _drdOtType;
  // ignore: unused_field
  String _drdReasonType;
  // ignore: unused_field
  String _drdSubTo;

  var starttime;
  var endtime;
  var _txtEmployeeID = TextEditingController();
  // var _txtEmployeeName = TextEditingController();
  var _dtpFromdate = TextEditingController();
  var _dtpTodate = TextEditingController();
  var _dtpsarttime = TextEditingController();
  var _dtpendtime = TextEditingController();
  var _txtNumberHour = TextEditingController();
  var _txtRemarks = TextEditingController();
  var _txtSubmitTo = TextEditingController();

  void setValue() {
    setState(() async {
      _txtEmployeeID.text = widget.overtimeApprovetDetailModel.employeeId;
      _drdOtType = widget.overtimeApprovetDetailModel.hourType;
      _drdReasonType = widget.overtimeApprovetDetailModel.reasonType;
      _drdSubTo = widget.overtimeApprovetDetailModel.assignId;
      _dtpFromdate.text = widget.overtimeApprovetDetailModel.startDateTime;
      _dtpTodate.text = widget.overtimeApprovetDetailModel.endDateTime;
      _dtpsarttime.text = await AppUtilities.formatTimeTo12H(
          widget.overtimeApprovetDetailModel.startTime);
      _dtpendtime.text = await AppUtilities.formatTimeTo12H(
          widget.overtimeApprovetDetailModel.endTime);
      _txtNumberHour.text =
          widget.overtimeApprovetDetailModel.numHour.toString();
      _txtRemarks.text = widget.overtimeApprovetDetailModel.remarks;
      calcHOur(
          widget.overtimeApprovetDetailModel.startDateTime,
          widget.overtimeApprovetDetailModel.startTime,
          widget.overtimeApprovetDetailModel.endDateTime,
          widget.overtimeApprovetDetailModel.endTime);
    });
  }

  var assignID;
  void codenamesubmitTo() async {
    var assignName = await getPrefs('assignName');
    assignID = await getPrefs('assignID');
    setState(() {
      _txtSubmitTo.text = assignName;
    });
  }

  void clearSubmit() {
    setPrefs('assignName', widget.overtimeApprovetDetailModel.assignName);
    setPrefs('assignID', widget.overtimeApprovetDetailModel.assignId);
    setState(() {
      _txtSubmitTo.text = widget.overtimeApprovetDetailModel.assignName;
    });
  }

  //Set State for fullWidget
  @override
  void initState() {
    clearSubmit();
    try {
      getData();
      setValue();
    } catch (e) {}
    super.initState();
  }

  Future calcHOur(String dtFromdate, String dtStartTime, String dtTodate,
      String dtEndTime) async {
    if (dtFromdate.isEmpty ||
        dtStartTime.isEmpty ||
        dtTodate.isEmpty ||
        dtEndTime.isEmpty) {
      setState(() {
        _txtNumberHour.text = '';
      });
      return;
    }
    try {
      dtStartTime = await AppUtilities.formatTimeTo24H(dtStartTime);
      dtEndTime = await AppUtilities.formatTimeTo24H(dtEndTime);
      var body = jsonEncode(
        {
          "employeeID": await getUserLoginId(),
          "endTime": dtTodate + "T" + dtEndTime,
          "startTime": dtFromdate + "T" + dtStartTime,
        },
      );
      print('object' + body);
      http.Response response = await post(urlCalcHour, body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          _txtNumberHour.text = data['WorkHour'];
        });
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Function Reject
  Future<void> functionReject() async {
    return await CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      title: "Reject",
      text: "Would you like to Reject?",
      confirmBtnColor: Colors.red[800],
      onConfirmBtnTap: () async {
        //
        Navigator.pop(context, true); //Close Current Dialog
        var body = json.encode({
          "requestId": widget.overtimeApprovetDetailModel.requestId,
          "assignId": widget.overtimeApprovetDetailModel.assignId
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
              Navigator.pop(context);
            },
          );
          //Success => should route to list screen
        } else {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: "Reject",
            text: rsp.body,
          );
        }
      },
    );
  }

  // Function Approve
  Future<void> functionApprove() async {
    return await CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      title: "Approve",
      text: "Would you like to Approve?",
      onConfirmBtnTap: () async {
        // Model
        OvertimApproveModel overtimApproveModel = new OvertimApproveModel(
          requestId: widget.overtimeApprovetDetailModel.requestId,
          requestDate: _dtpFromdate.text +
              'T' +
              await AppUtilities.formatTimeTo24H(_dtpsarttime.text),
          paymentDate: "",
          overtimeDate: _dtpFromdate.text +
              'T' +
              await AppUtilities.formatTimeTo24H(_dtpsarttime.text),
          startTime: _dtpFromdate.text +
              'T' +
              await AppUtilities.formatTimeTo24H(_dtpsarttime.text),
          endTime: _dtpTodate.text +
              'T' +
              await AppUtilities.formatTimeTo24H(_dtpendtime.text),
          numHour: _txtNumberHour.text,
          hourType: _drdOtType.toString(),
          remarks: _txtRemarks.text,
          salType: "",
          salRate: null,
          assignId: assignID,
          nextTran: "",
          chgDeptId: "",
          reasonType: _drdReasonType.toString(),
        );
        Navigator.pop(context, true); //Close Current Dialog
        http.Response rsp = await post(
            urlApproveOvertime, jsonEncode(overtimApproveModel.toJson()));
        print(jsonEncode(overtimApproveModel.toJson()));

        if (rsp.statusCode == 200) {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            title: "Approve",
            text: "Completed Successfully!",
            onConfirmBtnTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
          //Set Current State
          setState(() {});

          //Success => should route to list screen
        } else {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: "Approve",
            text: rsp.body,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    codenamesubmitTo();
    final TextFormField txtEmployeeID = TextFormField(
      controller: _txtEmployeeID,
      enabled: false,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: AppUtilities.textFormFieldDecoration('Employee ID'),
    );
    final TextFormField txtFromdate = TextFormField(
      controller: _dtpFromdate,
      keyboardType: TextInputType.text,
      autofocus: false,
      readOnly: true,
      decoration: AppUtilities.textFormFieldDecorationPrefixIcon(
          labelText: 'From date', prefixIcon: Icon(Icons.date_range)),
      onTap: () async {
        calcHOur(
          _dtpFromdate.text,
          _dtpsarttime.text,
          _dtpTodate.text,
          _dtpendtime.text,
        );
        _overtimefromdate = await datePicker(context, _overtimefromdate);
        setState(() {
          _dtpFromdate.text =
              DateFormat('yyyy-MM-dd').format(_overtimefromdate);
        });
      },
    );
    final TextFormField txtStarttime = TextFormField(
      controller: _dtpsarttime,
      keyboardType: TextInputType.text,
      autofocus: false,
      readOnly: true,
      decoration: AppUtilities.textFormFieldDecorationPrefixIcon(
          labelText: 'Start Time', prefixIcon: Icon(Icons.access_time)),
      onTap: () async {
        calcHOur(
          _dtpFromdate.text,
          _dtpsarttime.text,
          _dtpTodate.text,
          _dtpendtime.text,
        );
        TimeOfDay time = TimeOfDay.now();
        time = await selectTime(context, time);
        setState(() {
          _dtpsarttime.text = time.format(context);
        });
      },
    );
    final TextFormField txtToDate = TextFormField(
      controller: _dtpTodate,
      keyboardType: TextInputType.text,
      autofocus: false,
      readOnly: true,
      decoration: AppUtilities.textFormFieldDecorationPrefixIcon(
          labelText: 'To date', prefixIcon: Icon(Icons.date_range)),
      onTap: () async {
        calcHOur(
          _dtpFromdate.text,
          _dtpsarttime.text,
          _dtpTodate.text,
          _dtpendtime.text,
        );
        _overtimetodate = await datePicker(context, _overtimetodate);
        setState(() {
          _dtpTodate.text = DateFormat('yyyy-MM-dd').format(_overtimetodate);
        });
      },
    );
    final TextFormField txtEndTime = TextFormField(
      controller: _dtpendtime,
      keyboardType: TextInputType.text,
      autofocus: false,
      readOnly: true,
      decoration: AppUtilities.textFormFieldDecorationPrefixIcon(
          labelText: 'End Time', prefixIcon: Icon(Icons.access_time)),
      onTap: () async {
        calcHOur(
          _dtpFromdate.text,
          _dtpsarttime.text,
          _dtpTodate.text,
          _dtpendtime.text,
        );
        TimeOfDay time = TimeOfDay.now();
        time = await selectTime(context, time);
        setState(() {
          _dtpendtime.text = time.format(context);
        });
      },
    );
    final TextFormField txtNumberHour = TextFormField(
      controller: _txtNumberHour,
      readOnly: true,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: AppUtilities.textFormFieldDecorationPrefixIcon(
          labelText: 'Number of hour', prefixIcon: Icon(Icons.access_time)),
    );
    // Dropdown
    final drdOtType = DropdownSearch<String>(
      selectedItem: widget.overtimeApprovetDetailModel.hourTypeDesc,
      hint: 'OT Type',
      mode: Mode.DIALOG,
      showClearButton: true,
      label: 'Ot Type',
      showSearchBox: true,
      items: List.generate(
        otType.length,
        (index) => otType[index].name,
      ),
      onChanged: (value) {
        if (value != null) {
          _drdOtType =
              otType.where((element) => element.name == value).first.code;
        } else {
          _drdOtType = '';
        }
      },
      validator: (String item) {
        if (item == null)
          return "Required field";
        else
          return null;
      },
      autoValidateMode: AutovalidateMode.onUserInteraction,
      searchBoxDecoration: AppUtilities.searchBoxDecoration(),
      dropdownSearchDecoration: AppUtilities.dropdownSearchDecoration(),
    );
    final drdReasonType = DropdownSearch<String>(
      selectedItem: widget.overtimeApprovetDetailModel.reasonDesc,
      hint: 'Reason Type',
      mode: Mode.DIALOG,
      label: 'Reason Type',
      showClearButton: true,
      showSearchBox: true,
      items:
          List.generate(reasonType.length, (index) => reasonType[index].name),
      onChanged: (value) {
        if (value != null) {
          _drdReasonType =
              reasonType.where((element) => element.name == value).first.code;
        } else {
          _drdReasonType = '';
        }
      },
      validator: (String item) {
        if (item == null)
          return "Required field";
        else
          return null;
      },
      autoValidateMode: AutovalidateMode.onUserInteraction,
      searchBoxDecoration: AppUtilities.searchBoxDecoration(),
      dropdownSearchDecoration: AppUtilities.dropdownSearchDecoration(),
    );
    final TextFormField subumitTo = TextFormField(
      controller: _txtSubmitTo,
      readOnly: true,
      keyboardType: TextInputType.text,
      autofocus: false,
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SubmitTo()));
      },
      decoration: AppUtilities.textFormFieldDecoration('Submit To'),
    );
    final TextFormField txtRemarks = TextFormField(
      controller: _txtRemarks,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: AppUtilities.textFormFieldDecoration('Remarks'),
    );
    final Padding btnApprve = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: AppUtilities.borderRadius(),
        ),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            functionApprove();
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.blue[900],
        child: Text('Approve', style: TextStyle(color: Colors.white)),
      ),
    );
    final Padding btnReject = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: AppUtilities.borderRadius(),
        ),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            functionReject();
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.red[900],
        child: Text('Reject', style: TextStyle(color: Colors.white)),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Overtime Approve Detail'),
        backgroundColor: Colors.blue[900],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20.0), //Border Items Space
          children: <Widget>[
            txtEmployeeID,
            SizedBox(
              height: 10,
            ),
            txtFromdate,
            SizedBox(
              height: 10,
            ),
            txtStarttime,
            SizedBox(
              height: 10,
            ),
            txtToDate,
            SizedBox(
              height: 10,
            ),
            txtEndTime,
            SizedBox(
              height: 10,
            ),
            txtNumberHour,
            SizedBox(
              height: 10,
            ),
            drdOtType,
            SizedBox(
              height: 10,
            ),
            drdReasonType,
            SizedBox(
              height: 10,
            ),
            subumitTo,
            SizedBox(
              height: 10,
            ),
            txtRemarks,
            Row(
              children: <Widget>[
                Expanded(child: btnApprve),
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
