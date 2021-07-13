import 'dart:convert';

List<OvertimeModel> overtimeModelFromMap(String str) =>
    List<OvertimeModel>.from(
        json.decode(str).map((x) => OvertimeModel.fromMap(x)));

String overtimeModelToMap(List<OvertimeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class OvertimeModel {
  OvertimeModel({
    this.id,
    this.requestStatus,
    this.requestHour,
    this.requesttype,
  });

  String id;
  String requestStatus;
  String requestHour;
  String requesttype;

  factory OvertimeModel.fromMap(Map<String, dynamic> json) => OvertimeModel(
        id: json["id"] == null ? "N/A" : json["id"],
        requestStatus:
            json["requestStatus"] == null ? "N/A" : json["requestStatus"],
        requestHour: json["requestHour"] == null ? "N/A" : json["requestHour"],
        requesttype: json["requesttype"] == null ? "N/A" : json["requesttype"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "requestStatus": requestStatus,
        "requestHour": requestHour,
        "requesttype": requesttype,
      };
}
