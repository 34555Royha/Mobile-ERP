import 'dart:convert';

import 'package:bank/api_helper/http_services.dart';
import 'package:bank/constance_routes/overtime_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

List<OvertimeReqmodel> overtimeReqmodelFromMap(String str) =>
    List<OvertimeReqmodel>.from(
        json.decode(str).map((x) => OvertimeReqmodel.fromMap(x)));

String overtimeReqmodelToMap(List<OvertimeReqmodel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class OvertimeReqmodel extends HttpService {
  // HttpService httpService = new HttpService();
  OvertimeReqmodel({
    this.id,
    this.requestHour,
    this.requestStatus,
    this.requesttype,
  });

  String id;
  String requestHour;
  String requestStatus;
  String requesttype;

  factory OvertimeReqmodel.fromMap(Map<String, dynamic> json) =>
      OvertimeReqmodel(
        id: json["id"] == null ? "N/A" : json["id"],
        requestHour: json["requestHour"] == null ? "N/A" : json["requestHour"],
        requestStatus:
            json["requestStatus"] == null ? "N/A" : json["requestStatus"],
        requesttype: json["requesttype"] == null ? "N/A" : json["requesttype"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "requestHour": requestHour,
        "requestStatus": requestStatus,
        "requesttype": requesttype,
      };
  // HttpService httpService = new HttpService();
  // Future<List> getData() async {
  //   http.Response response = await httpService.get(urlgetOvertimereq);
  //   if (response.statusCode == 200) {
  //     return compute(overtimeReqmodelFromMap, response.body);
  //   } else {
  //     throw Exception("Response Error ${response.statusCode}");
  //   }
  // }
  Future<List<OvertimeReqmodel>> getovertimeReqs() async {
    http.Response rsp = await get(urlgetOvertimereq);
    if (rsp.statusCode == 200) {
      var result = (jsonDecode(rsp.body) as List)
          .map((e) => OvertimeReqmodel.fromMap(e))
          .toList();
      return result;
    } else {
      return new List<OvertimeReqmodel>();
    }
  }
}

class Test {
  HttpService httpService = new HttpService();
  Future<List> getData() async {
    http.Response response = await httpService.get(urlgetOvertimereq);
    if (response.statusCode == 200) {
      return compute(overtimeReqmodelFromMap, response.body);
    } else {
      throw Exception("Response Error ${response.statusCode}");
    }
  }
}
