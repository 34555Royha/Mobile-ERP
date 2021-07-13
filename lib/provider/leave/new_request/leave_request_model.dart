import 'dart:convert';

import 'package:bank/api_helper/http_services.dart';
import 'package:bank/app_utility/app_utilities.dart';
import 'package:bank/constance_routes/leave_routes.dart';
import 'package:bank/provider/leave/leave_page.dart';
import 'package:bank/provider/leave/new_request/leave_entitle_model.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LeaveRequestModel extends HttpService {
  String assignId;
  String employeeId;
  String endTime;
  String leaveFrom;
  String leaveTo;
  String ltypeId;
  String numReq;
  String numType;
  String reasonType;
  String remarks;
  String requestId;
  int schClassId;
  String startTime;
  String valueDate;

  LeaveRequestModel({
    this.assignId,
    this.employeeId,
    this.leaveFrom,
    this.leaveTo,
    this.ltypeId,
    this.numReq,
    this.numType,
    this.reasonType,
    this.remarks,
    this.requestId,
    this.schClassId,
    this.startTime,
    this.endTime,
    this.valueDate,
  });

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) {
    return LeaveRequestModel(
      assignId: json["assignID"],
      employeeId: json["employeeID"],
      leaveFrom: json["leaveFrom"],
      leaveTo: json["leaveTo"],
      ltypeId: json["ltypeID"],
      numReq: json["numReq"],
      numType: json["numType"],
      reasonType: json["reasonType"],
      remarks: json["remarks"],
      requestId: json["requestID"],
      schClassId: json["schClassID"],
      startTime: json["startTime"],
      endTime: json["endTime"],
      valueDate: json["valueDate"],
    );
  }

  Map<String, dynamic> toMap() => {
        "assignID": assignId,
        "employeeID": employeeId,
        "leaveFrom": leaveFrom,
        "leaveTo": leaveTo,
        "ltypeID": ltypeId,
        "numReq": numReq,
        "numType": numType,
        "reasonType": reasonType,
        "remarks": remarks,
        "requestID": requestId,
        "schClassID": schClassId,
        "startTime": startTime,
        "endTime": endTime,
        "valueDate": valueDate,
      };

  Future<http.Response> create(String jsonBody) async {
    return await post(
      urlCreateLeaveRequest,
      jsonBody,
    );
  }

  Future<EntitleModel> postGetLeaveReqHis(
      String leaveTypeId, BuildContext context) async {
    var empId = await getUserLoginId();
    var body = jsonEncode({
      "employeeId": empId,
      "lTypeId": leaveTypeId,
    });
    http.Response rsp = await postAPI(uulGetEntitle, body, context);
    if (rsp.statusCode == 200) {
      EntitleModel entitleModel = new EntitleModel();
      entitleModel = EntitleModel.fromJson(jsonDecode(rsp.body));
      return entitleModel;
    } else {
      return new EntitleModel();
    }
  }

  Future<String> postGetLeaveReqDay(BuildContext context, String fDate,
      String tDate, String fTime, String tTime, String leaveTypeId) async {
    String retVal = '';
    var empId = await getUserLoginId();
    var body = jsonEncode({
      "employeeId": empId,
      "fromDate": fDate + 'T' + fTime,
      "leaveTypeId": leaveTypeId,
      "toDate": tDate + 'T' + tTime
    });
    http.Response rsp = await postAPI(urlGetLeaveReqDay, body, context);

    if (rsp.statusCode == 200) {
      return retVal = jsonDecode(rsp.body)['requstday'].toString();
    } else
      return retVal;
  }

  void postCreateLeave(
    BuildContext context,
    leaveTypeId,
    leaveFrom,
    leaveTo,
    numReq,
    numType,
    reasonType,
    remarks,
    sTime,
    eTime,
    assignId,
  ) async {
    var empId = await getUserLoginId();
    var valDate = AppUtilities.getCurrentDate();
    try {
      sTime = await AppUtilities.formatTimeTo24H(sTime);
      eTime = await AppUtilities.formatTimeTo24H(eTime);
    } catch (e) {
      print('Parse Time to 24 Hour got an Error: ' + e.toString());
    }

    LeaveRequestModel leaveRequestModel = new LeaveRequestModel(
      employeeId: empId,
      ltypeId: leaveTypeId,
      valueDate: valDate,
      leaveFrom: leaveFrom,
      leaveTo: leaveTo,
      numReq: numReq,
      numType: numType,
      reasonType: reasonType,
      remarks: remarks,
      startTime: sTime,
      endTime: eTime,
      assignId: assignId,
    );

    var body = jsonEncode(leaveRequestModel.toMap());

    // print(body);

    http.Response rsp = await postAPI(urlCreateLeaveRequest, body, context);

    if (rsp.statusCode == 200) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        title: 'Create',
        text: "Completed with successfully!",
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Leave(),
            ),
          );
        },
      );
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: "Submit",
        text: rsp.statusCode.toString() + ": " + rsp.body,
      );
    }
  }
}
