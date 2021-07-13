import 'package:bank/api_helper/http_services.dart';
import 'package:bank/constance_routes/leave_routes.dart';
import 'package:http/http.dart' as http;

class LeaveUnAuthsModel extends HttpService {
  int id;
  String requestDate;
  String requestType;
  String requestFrom;
  String requestTo;
  double requestDay;
  String requestStatus;

  LeaveUnAuthsModel({
    this.id,
    this.requestDate,
    this.requestType,
    this.requestFrom,
    this.requestTo,
    this.requestDay,
    this.requestStatus,
  });

  factory LeaveUnAuthsModel.fromJson(Map<String, dynamic> json) =>
      LeaveUnAuthsModel(
        id: json["ID"] as int,
        requestDate: json["RequestDate"],
        requestType: json["RequestType"],
        requestFrom: json["RequestFrom"],
        requestTo: json["RequestTo"],
        requestDay: json["RequestDay"] as double,
        requestStatus: json["RequestStatus"],
      );

  Future<http.Response> getLeaveUnAuths() async {
    return await get(urlLeaveUnAuths);
  }
}
