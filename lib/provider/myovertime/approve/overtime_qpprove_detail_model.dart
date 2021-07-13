import 'package:bank/api_helper/http_services.dart';
import 'package:bank/constance_routes/overtime_routes.dart';
import 'package:http/http.dart' as http;

class OvertimeApprovetDetailModel extends HttpService {
  OvertimeApprovetDetailModel({
    this.id,
    this.endTime,
    this.startTime,
    this.reasonType,
    this.numHour,
    this.reasonDesc,
    this.assignId,
    this.requestId,
    this.remarks,
    this.periodId,
    this.requestDate,
    this.hourType,
    this.overtimeDate,
    this.startDateTime,
    this.endDateTime,
    this.employeeId,
    this.assignName,
    this.hourTypeDesc,
  });

  int id;
  String endTime;
  String startTime;
  String reasonType;
  double numHour;
  String reasonDesc;
  String assignId;
  String requestId;
  String remarks;
  String periodId;
  String requestDate;
  String hourType;
  String overtimeDate;
  String startDateTime;
  String endDateTime;
  String employeeId;
  String assignName;
  String hourTypeDesc;

  factory OvertimeApprovetDetailModel.fromJson(Map<String, dynamic> json) =>
      OvertimeApprovetDetailModel(
        id: json["id"] as int,
        endTime: json["endTime"],
        startTime: json["startTime"],
        reasonType: json["reasonType"],
        numHour: json["numHour"] as double,
        reasonDesc: json["reasonDesc"],
        assignId: json["assignID"],
        requestId: json["requestID"],
        remarks: json["remarks"],
        periodId: json["periodID"],
        requestDate: json["requestDate"],
        hourType: json["hourType"],
        overtimeDate: json["overtimeDate"],
        startDateTime: json["startDateTime"],
        endDateTime: json["endDateTime"],
        employeeId: json["employeeID"],
        assignName: json["assignName"],
        hourTypeDesc: json["hourTypeDesc"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "endTime": endTime,
        "startTime": startTime,
        "reasonType": reasonType,
        "numHour": numHour,
        "reasonDesc": reasonDesc,
        "assignID": assignId,
        "requestID": requestId,
        "remarks": remarks,
        "periodID": periodId,
        "requestDate": requestDate,
        "hourType": hourType,
        "overtimeDate": overtimeDate,
        "startDateTime": startDateTime,
        "endDateTime": endDateTime,
        "employeeID": employeeId,
        "assignName": assignName,
        "hourTypeDesc": hourTypeDesc,
      };
  Future<http.Response> getOvertimeRequest(String pId) async {
    return await get('$urlGetOvertimeReqByID' + pId);
  }
}
