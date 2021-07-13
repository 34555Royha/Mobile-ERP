import 'dart:convert';

String newOvertimeModelToJson(NewOvertimeModel data) =>
    json.encode(data.toJson());

class NewOvertimeModel {
  NewOvertimeModel({
    this.assignId,
    this.employeeId,
    this.employeeName,
    this.hourType,
    this.numHour,
    this.reasonType,
    this.remarks,
    this.startDateTime,
    this.endDateTime,
  });

  String assignId;
  String employeeId;
  String employeeName;
  String hourType;
  String numHour;
  String reasonType;
  String remarks;
  String startDateTime;
  String endDateTime;

  Map<String, dynamic> toJson() => {
        "assignID": assignId,
        "employeeID": employeeId,
        "employeeName": employeeName,
        "hourType": hourType,
        "numHour": numHour,
        "reasonType": reasonType,
        "remarks": remarks,
        "startDateTime": startDateTime,
        "endDateTime": endDateTime,
      };
}
