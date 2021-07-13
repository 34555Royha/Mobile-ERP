import 'package:bank/constance_routes/base_routes.dart';

//Base Routes
final String urladdnewovertime = "$httpMethod$baseApiUrl/overtime";
final String urlgetOvertimereq = "$httpMethod$baseApiUrl/overtime/requests";
final String urlgetOvertimeApp = "$httpMethod$baseApiUrl/overtime/authorizes";
final String urlgetEmployee = '$httpMethod$baseApiUrl/overtime/param';
final String urlovertimegetParams = "$httpMethod$baseApiUrl/overtime/param";
final String urlGetOvertimeReqByID = '$httpMethod$baseApiUrl/overtime/view?id=';
final String urlUpdateOvertime = '$httpMethod$baseApiUrl/overtime/update';
final String urlDeleteOvertime = '$httpMethod$baseApiUrl/overtime/delete';
final String urlApproveOvertime = '$httpMethod$baseApiUrl/overtime/approve';
final String urlRejectOvertime = '$httpMethod$baseApiUrl/overtime/reject';
final String urlgetSubmitTo = '$httpMethod$baseApiUrl/overtime/sup';
final String urlCalcHour = '$httpMethod$baseApiUrl/overtime/hour';
