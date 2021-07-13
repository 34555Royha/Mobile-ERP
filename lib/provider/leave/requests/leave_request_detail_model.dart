import 'dart:convert';

import 'package:bank/api_helper/http_services.dart';
import 'package:bank/constance_routes/leave_routes.dart';
import 'package:http/http.dart' as http;

class LeaveRequestDetailModel extends HttpService {
  String typeName;
  String id;
  String employeeId;
  String ltypeId;
  String valueDate;
  String leaveFrom;
  String leaveTo;
  String numReq;
  String schClassId;
  String requestId;
  String assignId;
  String reasonType;
  String endTime;
  String startTime;
  String fullName;
  String remarks;
  String numType;
  String numTypeDesc;
  String taken;
  String balance;
  String reasonDesc;
  String assignName;
  String entitlement;

  LeaveRequestDetailModel({
    this.typeName,
    this.id,
    this.employeeId,
    this.ltypeId,
    this.valueDate,
    this.leaveFrom,
    this.leaveTo,
    this.numReq,
    this.schClassId,
    this.requestId,
    this.assignId,
    this.reasonType,
    this.endTime,
    this.startTime,
    this.fullName,
    this.remarks,
    this.numType,
    this.numTypeDesc,
    this.taken,
    this.balance,
    this.reasonDesc,
    this.assignName,
    this.entitlement,
  });

  factory LeaveRequestDetailModel.fromJson(Map<String, dynamic> json) =>
      LeaveRequestDetailModel(
        typeName: json["typeName"],
        id: json["id"],
        employeeId: json["employeeID"],
        ltypeId: json["ltypeID"],
        valueDate: json["valueDate"],
        leaveFrom: json["leaveFrom"],
        leaveTo: json["leaveTo"],
        numReq: json["numReq"],
        schClassId: json["schClassID"],
        requestId: json["requestID"],
        assignId: json["assignID"],
        reasonType: json["reasonType"],
        endTime: json["endTime"],
        startTime: json["startTime"],
        fullName: json["fullName"],
        remarks: json["remarks"],
        numType: json["numType"],
        numTypeDesc: json["numTypeDesc"],
        taken: json["taken"],
        balance: json["balance"],
        reasonDesc: json["reasonDesc"],
        assignName: json["assignName"],
        entitlement: json["entitlement"],
      );

  Map<String, dynamic> toJson() => {
        "typeName": typeName,
        "id": id,
        "employeeID": employeeId,
        "ltypeID": ltypeId,
        "valueDate": valueDate,
        "leaveFrom": leaveFrom,
        "leaveTo": leaveTo,
        "numReq": numReq,
        "schClassID": schClassId,
        "requestID": requestId,
        "assignID": assignId,
        "reasonType": reasonType,
        "endTime": endTime,
        "startTime": startTime,
        "fullName": fullName,
        "remarks": remarks,
        "numType": numType,
        "numTypeDesc": numTypeDesc,
        "taken": taken,
        "balance": balance,
        "reasonDesc": reasonDesc,
        "assignName": assignName,
        "entitlement": entitlement,
      };

  Future<LeaveRequestDetailModel> getLeave(context, id) async {
    http.Response rsp = await getAPI(urlGetLeaveReqById + id, context);

    //parse rsp to map
    if (rsp.statusCode == 200) {
      final Map map = jsonDecode(rsp.body);
      return LeaveRequestDetailModel.fromJson(map);
    } else {
      return new LeaveRequestDetailModel();
    }
  }
}
