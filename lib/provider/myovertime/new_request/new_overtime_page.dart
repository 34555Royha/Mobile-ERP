import 'dart:convert';
import 'package:bank/api_helper/error_response_model.dart';
import 'package:bank/api_helper/get_code.dart';
import 'package:bank/api_helper/http_services.dart';
import 'package:bank/app_utility/app_utilities.dart';
import 'package:bank/constance_routes/overtime_routes.dart';
import 'package:bank/provider/myovertime/new_request/emp_model.dart';
import 'package:bank/provider/myovertime/new_request/new_overtime_modeld.dart';
import 'package:bank/provider/myovertime/new_request/search_submitto.dart';
import 'package:bank/provider/myovertime/new_request/search_submitto_model.dart';
import 'package:bank/provider/myovertime/search/search_model.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../myovertime_page.dart';

// ignore: must_be_immutable
class NewOvertime extends StatefulWidget {
  final SearchSubmitToModel searchSubmitToModel;
  @override
  _NewOvertimeState createState() => _NewOvertimeState();
  SearchmodelS item;
  NewOvertime({this.item, this.searchSubmitToModel});
}

class _NewOvertimeState extends State<NewOvertime> with HttpService {
  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  SearchSubmitToModel _searchSubmitToModel = new SearchSubmitToModel();

  List<CodeName> _ottype = new List<CodeName>();
  List<CodeName> _reasontype = new List<CodeName>();
  // List<CodeName> _submitto = new List<CodeName>();
  CodeName _codeName = new CodeName();

  // Employee employees = new Employee();
  //TextEditingController
  TextEditingController _txtEmployeeid = TextEditingController();
  TextEditingController _txtEmployeename = TextEditingController();
  TextEditingController _fromdate = TextEditingController();
  TextEditingController _starttime = TextEditingController();
  TextEditingController _todate = TextEditingController();
  TextEditingController _endtime = TextEditingController();
  var _numberofhour = TextEditingController();
  // TextEditingController _type = TextEditingController();
  // TextEditingController _reasion = TextEditingController();
  TextEditingController _remarks = TextEditingController();
  TextEditingController _txtSubmitTo = TextEditingController();

  String codeOTtype;
  String codeReasontype;
  String codeSubmitTo;

  var starttimes;
  var endtimes;

  Future getData() async {
    http.Response response = await _codeName.getCodeName(urlovertimegetParams);

    if (response.statusCode == 200) {
      setState(() {
        _ottype = _codeName.jsonList(json.decode(response.body), "ottype");

        // print(_ottype.length);

        _reasontype =
            _codeName.jsonList(json.decode(response.body), "reasonType");
        // _submitto = _codeName.jsonList(json.decode(response.body), "submitTo");
      });
    } else {
      throw Exception(ErrorResponse);
    }
  }

  Future calcHOur(String dtFromdate, String dtStartTime, String dtTodate,
      String dtEndTime) async {
    if (dtFromdate.isEmpty ||
        dtStartTime.isEmpty ||
        dtTodate.isEmpty ||
        dtEndTime.isEmpty) {
      setState(() {
        _numberofhour.text = '';
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
      http.Response response = await post(urlCalcHour, body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          _numberofhour.text = data['EmployeeID'];
        });
      } else {}
    } catch (e) {
      throw Exception(e);
    }
  }

  Future getEmployies() async {
    EmpModel empModel = EmpModel();
    //get data
    http.Response rsp = await get('$urlgetEmployee');
    if (rsp.statusCode == 200) {
      var result = jsonDecode(rsp.body);

      empModel = EmpModel.fromJson(result['employee']);

      _txtEmployeeid.text = empModel.employeeId;
      _txtEmployeename.text = empModel.fullName;
    } else {}

    return empModel;
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
    setPrefs('assignName', '');
    setPrefs('assignID', '');
    setState(() {
      _txtSubmitTo.text = '';
    });
  }

  @override
  void initState() {
    clearSubmit();
    getData();
    getEmployies();
    _searchSubmitToModel = widget.searchSubmitToModel;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NewOvertime oldWidget) {
    print(oldWidget.searchSubmitToModel);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    codenamesubmitTo();
    final TextFormField sbumitTo = TextFormField(
      controller: _txtSubmitTo,
      readOnly: true,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: AppUtilities.textFormFieldDecoration('Submit To'),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SubmitTo()));
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter submit to';
        } else {
          return null;
        }
      },
    );

    final TextFormField employeeid = TextFormField(
        controller: _txtEmployeeid,
        keyboardType: TextInputType.text,
        autofocus: false,
        enabled: false,
        decoration: AppUtilities.textFormFieldDecoration('Employee ID'));
    final TextFormField employeename = TextFormField(
      controller: _txtEmployeename,
      keyboardType: TextInputType.text,
      autofocus: false,
      enabled: false,
      decoration: AppUtilities.textFormFieldDecoration('Employee Name'),
    );
    final TextFormField fromdate = TextFormField(
      controller: _fromdate,
      keyboardType: TextInputType.datetime,
      autofocus: false,
      readOnly: true,
      decoration: AppUtilities.textFormFieldDecorationPrefixIcon(
          labelText: 'From date', prefixIcon: Icon(Icons.date_range)),
      onTap: () async {
        DateTime value = DateTime.now();
        value = await datePicker(context, value);

        setState(() {
          _fromdate.text = DateFormat('yyyy-MM-dd').format(value);
        });
        calcHOur(
          _fromdate.text,
          _starttime.text,
          _todate.text,
          _endtime.text,
        );
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter from date';
        } else {
          return null;
        }
      },
    );

    final starttime = TextFormField(
      controller: _starttime,
      keyboardType: TextInputType.datetime,
      autofocus: false,
      readOnly: true,
      decoration: AppUtilities.textFormFieldDecorationPrefixIcon(
          labelText: 'Start Time', prefixIcon: Icon(Icons.access_time)),
      onTap: () async {
        TimeOfDay t = TimeOfDay.now();
        t = await selectTime(context, t);
        setState(() {
          _starttime.text = t.format(context);
        });
        calcHOur(
          _fromdate.text,
          _starttime.text,
          _todate.text,
          _endtime.text,
        );
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter start time';
        } else {
          return null;
        }
      },
    );

    final endTIme = TextFormField(
      controller: _endtime,
      keyboardType: TextInputType.datetime,
      autofocus: false,
      readOnly: true,
      decoration: AppUtilities.textFormFieldDecorationPrefixIcon(
          labelText: 'End Time', prefixIcon: Icon(Icons.access_time)),
      onTap: () async {
        TimeOfDay t = TimeOfDay.now();
        t = await selectTime(context, t);
        setState(() {
          _endtime.text = t.format(context);
        });
        calcHOur(
          _fromdate.text,
          _starttime.text,
          _todate.text,
          _endtime.text,
        );
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter end time';
        } else {
          return null;
        }
      },
    );
    final TextFormField todate = TextFormField(
      controller: _todate,
      keyboardType: TextInputType.datetime,
      autofocus: false,
      readOnly: true,
      decoration: AppUtilities.textFormFieldDecorationPrefixIcon(
          labelText: 'To date', prefixIcon: Icon(Icons.date_range)),
      onTap: () async {
        DateTime value = DateTime.now();
        value = await datePicker(context, value);
        setState(() {
          _todate.text = DateFormat('yyyy-MM-dd').format(value);
        });
        calcHOur(
          _fromdate.text,
          _starttime.text,
          _todate.text,
          _endtime.text,
        );
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter to date';
        } else {
          return null;
        }
      },
    );
    final TextFormField numberofhour = TextFormField(
      controller: _numberofhour,
      readOnly: true,
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration: AppUtilities.textFormFieldDecorationPrefixIcon(
          labelText: 'Number of hour', prefixIcon: Icon(Icons.access_time)),
    );

    final ottype = DropdownSearch<String>(
      hint: 'OT Type',
      mode: Mode.DIALOG,
      showClearButton: true,
      label: 'Ot Type',
      showSearchBox: true,
      items: List.generate(_ottype.length, (index) => _ottype[index].name),
      onChanged: (value) {
        if (value != null) {
          codeOTtype =
              _ottype.where((element) => element.name == value).first.code;
        } else {
          codeOTtype = '';
        }
      },
      validator: (String item) {
        if (item == null)
          return "Please select OT Type";
        else
          return null;
      },
      autoValidateMode: AutovalidateMode.onUserInteraction,
      searchBoxDecoration: AppUtilities.searchBoxDecoration(),
      dropdownSearchDecoration: AppUtilities.dropdownSearchDecoration(),
    );

    final reasontype = DropdownSearch<String>(
      hint: 'Reason Type',
      mode: Mode.DIALOG,
      label: 'Reason Type',
      showClearButton: true,
      showSearchBox: true,
      items:
          List.generate(_reasontype.length, (index) => _reasontype[index].name),
      onChanged: (value) {
        print('onchange');
        if (value != null) {
          codeReasontype =
              _reasontype.where((element) => element.name == value).first.code;
        } else {
          codeReasontype = '';
        }
      },
      validator: (String item) {
        if (item == null)
          return "Please select Reason Type";
        else
          return null;
      },
      autoValidateMode: AutovalidateMode.onUserInteraction,
      searchBoxDecoration: AppUtilities.searchBoxDecoration(),
      dropdownSearchDecoration: AppUtilities.dropdownSearchDecoration(),
    );
    final TextFormField remarks = TextFormField(
      controller: _remarks,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: AppUtilities.textFormFieldDecoration('Remarks'),
    );

    final Padding submitButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: AppUtilities.borderRadius(),
        ),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            NewOvertimeModel newOvertimeModel = new NewOvertimeModel(
                assignId: assignID,
                employeeId: _txtEmployeeid.text,
                employeeName: _txtEmployeename.text,
                hourType: codeOTtype.toString(),
                numHour: _numberofhour.text,
                reasonType: codeReasontype.toString(),
                remarks: _remarks.text,
                startDateTime: "${_fromdate.text}T" +
                    await AppUtilities.formatTimeTo24H(_starttime.text) +
                    ":00.914Z",
                endDateTime: "${_todate.text}T" +
                    await AppUtilities.formatTimeTo24H(_endtime.text) +
                    ":00.914Z");
            http.Response response = await post(
              urladdnewovertime,
              jsonEncode(newOvertimeModel.toJson()),
            );
            print(newOvertimeModel.toJson());
            // print(codeOTtype.toString());
            if (response.statusCode == 200) {
              print("success");
              CoolAlert.show(
                  context: context,
                  type: CoolAlertType.success,
                  title: "Success",
                  text: "Request Overtime successful",
                  onConfirmBtnTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
            } else {
              print("Filed");
              CoolAlert.show(
                context: context,
                type: CoolAlertType.error,
                title: "Oops...",
                text: response.body,
              );
            }
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.blue[900],
        child: Text('Submit', style: TextStyle(color: Colors.white)),
      ),
    );
    final Padding cancelButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: AppUtilities.borderRadius(),
        ),
        onPressed: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyOverTime()));
        },
        padding: EdgeInsets.all(12),
        color: Colors.red[900],
        child: Text('Cancel', style: TextStyle(color: Colors.white)),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("New Overtime"),
        backgroundColor: Colors.blue[900],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
          children: <Widget>[
            SizedBox(height: 10.0),
            employeeid,
            SizedBox(height: 10.0),
            employeename,
            SizedBox(height: 10.0),
            fromdate,
            SizedBox(height: 10.0),
            starttime,
            SizedBox(height: 10.0),
            todate,
            SizedBox(height: 10.0),
            endTIme,
            SizedBox(height: 10.0),
            numberofhour,
            SizedBox(height: 10.0),
            ottype,
            SizedBox(height: 10.0),
            reasontype,
            SizedBox(height: 10.0),
            sbumitTo,
            SizedBox(height: 10.0),
            remarks,
            Row(
              children: <Widget>[
                Expanded(child: submitButton),
                SizedBox(width: 10.0),
                Expanded(child: cancelButton),
              ],
            )
          ],
        ),
      ),
    );
  }
}
