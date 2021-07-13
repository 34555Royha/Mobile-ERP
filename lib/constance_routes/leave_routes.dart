//Navigator
import 'package:bank/constance_routes/base_routes.dart';

final String urlGetLeaveRequest =
    '$httpMethod$baseApiUrl/leave/requests'; //get all leave requests
final String urlCreateLeaveRequest = '$httpMethod$baseApiUrl/leave';
final String urlReject = '$httpMethod$baseApiUrl/leave/reject';
final String urlLeaveDelete = '$httpMethod$baseApiUrl/leave';
final String urlApprove = '$httpMethod$baseApiUrl/leave/approve';
final String urlGetLeaveReqById = '$httpMethod$baseApiUrl/leave/';
final String uulGetEntitle = '$httpMethod$baseApiUrl/leave/entitle';
final String urlGetLeaveReqDay = '$httpMethod$baseApiUrl/leave/leaveday';

//Leave => UnAuths
final String urlLeaveUnAuthGetById = '$httpMethod$baseApiUrl/leave/';
final String urlDeleteLeaveRequest = '$httpMethod$baseApiUrl/api/leave/delete';
final String urlLeaveUnAuths = '$httpMethod$baseApiUrl/leave/unauthorizes';
