import 'dart:convert';

import 'package:bank/api_helper/http_services.dart';
import 'package:bank/constance_routes/leave_routes.dart';
import 'package:http/http.dart' as http;

class LeaveReqModel extends HttpService {
  int id;
  String requestDate;
  String requestType;
  String requestFrom;
  String requestTo;
  double requestDay;
  String requestStatus;

  LeaveReqModel({
    this.id,
    this.requestDate,
    this.requestType,
    this.requestFrom,
    this.requestTo,
    this.requestDay,
    this.requestStatus,
  });

  factory LeaveReqModel.fromJson(Map<String, dynamic> json) => LeaveReqModel(
        id: json["ID"],
        requestDate: json["RequestDate"],
        requestType: json["RequestType"] == null ? 'N/A' : json["RequestType"],
        requestFrom: json["RequestFrom"],
        requestTo: json["RequestTo"],
        requestDay: json["RequestDay"] as double,
        requestStatus:
            json["RequestStatus"] == null ? 'N/A' : json["RequestStatus"],
      );

  Future<List<LeaveReqModel>> getLeaveReqs() async {
    http.Response rsp = await post(urlGetLeaveRequest, '');
    if (rsp.statusCode == 200) {
      var result = (jsonDecode(rsp.body) as List)
          .map((e) => LeaveReqModel.fromJson(e))
          .toList();
      return result;
    } else {
      return new List<LeaveReqModel>();
    }
  }
}
