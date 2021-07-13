import 'dart:convert';

import 'package:bank/api_helper/http_services.dart';
import 'package:bank/constance_routes/leave_routes.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LeaveUnAuthByIdModel extends HttpService {
  String startTime;
  String leaveFrom;
  String employeeId;
  String leaveTo;
  String numReq;
  String schClassId;
  String remarks;
  String valueDate;
  String numType;
  String reasonType;
  String endTime;
  String assignId;
  String requestId;
  String ltypeId;
  String fullName;
  String typeName;
  String numTypeDesc;
  String id;

  LeaveUnAuthByIdModel({
    this.startTime,
    this.leaveFrom,
    this.employeeId,
    this.leaveTo,
    this.numReq,
    this.schClassId,
    this.remarks,
    this.valueDate,
    this.numType,
    this.reasonType,
    this.endTime,
    this.assignId,
    this.requestId,
    this.ltypeId,
    this.fullName,
    this.typeName,
    this.numTypeDesc,
    this.id,
  });

  factory LeaveUnAuthByIdModel.fromJson(Map<String, dynamic> json) {
    return LeaveUnAuthByIdModel(
      startTime: json["startTime"],
      leaveFrom: json["leaveFrom"],
      employeeId: json["employeeID"],
      leaveTo: json["leaveTo"],
      numReq: json["numReq"],
      schClassId: json["schClassID"],
      remarks: json["remarks"],
      valueDate: json["valueDate"],
      numType: json["numType"],
      reasonType: json["reasonType"],
      endTime: json["endTime"],
      assignId: json["assignID"],
      requestId: json["requestID"],
      ltypeId: json["ltypeID"],
      fullName: json["fullName"],
      typeName: json["typeName"],
      numTypeDesc: json["numTypeDesc"],
      id: json["id"],
    );
  }

  Future<http.Response> getLeaveUnAuthsByID(String pId) async {
    return await get(urlLeaveUnAuthGetById + pId);
  }

  void postLeaveApp(BuildContext context, String assignId, String reqId) async {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      title: "Approve",
      text: "Would you like to Approve?",
      onConfirmBtnTap: () async {
        Navigator.pop(context, true); //Close Current Dialog
        var body = jsonEncode({
          "assignID": assignId,
          "requestID": reqId,
        });

        var rsp = await postAPI(urlApprove, body, context);

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

  void postLeaveRej(BuildContext context, String assignId, String reqId) async {
    var body = jsonEncode({
      "assignID": assignId,
      "requestID": reqId,
    });

    print(body);

    var rsp = await postAPI(urlReject, body, context);

    print(rsp.body);

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
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: "Reject",
        text: rsp.body,
        onConfirmBtnTap: () {
          Navigator.pop(context); //close currend dialog
          Navigator.pop(context); //close corrent screen
          // Navigator.canPop(context);
        },
      );
    }
  }
}
