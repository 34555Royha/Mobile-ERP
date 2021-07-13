import 'dart:convert';

import 'package:bank/api_helper/http_services.dart';
import 'package:bank/app_utility/app_utilities.dart';
import 'package:bank/constance_routes/leave_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class EntitleModel with HttpService {
  String seniority;
  String taken;
  String balance;
  String yearlyday;
  String annualentitle;
  String entitle;
  String fiscalstart;
  String fiscalend;
  String baldate;
  String currentdate;
  String typename;
  String startdate;
  String enddate;
  String leavedate;

  EntitleModel({
    this.seniority,
    this.taken,
    this.balance,
    this.yearlyday,
    this.annualentitle,
    this.entitle,
    this.fiscalstart,
    this.fiscalend,
    this.baldate,
    this.currentdate,
    this.typename,
    this.startdate,
    this.enddate,
    this.leavedate,
  });

  factory EntitleModel.fromJson(Map<String, dynamic> json) => EntitleModel(
        seniority: json["seniority"],
        taken: json["taken"],
        balance: json["balance"],
        yearlyday: json["yearlyday"],
        annualentitle: json["annualentitle"],
        entitle: json["entitle"],
        fiscalstart: json["fiscalstart"],
        fiscalend: json["fiscalend"],
        baldate: json["baldate"],
        currentdate: json["currentdate"],
        typename: json["typename"],
        startdate: json["startdate"],
        enddate: json["enddate"],
        leavedate: json["leavedate"],
      );

  Future<EntitleModel> getLeaveHis(BuildContext context, String ltypeid) async {
    EntitleModel entitleModel = new EntitleModel();

    if (ltypeid == null) {
      return entitleModel = new EntitleModel();
    }
    var empId = await getUserLoginId();
    var body = jsonEncode({
      "employeeId": empId,
      "lTypeId": ltypeid,
    });

    http.Response rsp = await postAPI(uulGetEntitle, body, context);

    if (rsp.statusCode == 200) {
      entitleModel = EntitleModel.fromJson(jsonDecode(rsp.body));
    }
    return entitleModel;
  }

  Future<String> getLeaveBalDay(
    BuildContext context,
    pFDate,
    pTDate,
    pFTime,
    pTTime,
    pLType,
  ) async {
    String retVal;
    if (pFDate == null ||
        pTDate == null ||
        pFTime == null ||
        pTTime == null ||
        pLType == null) {
      return retVal = null;
    }

    //Catch for parse datatime
    try {
      pFTime = await AppUtilities.formatDateTimeTo12H(pFTime);
      pTTime = await AppUtilities.formatDateTimeTo12H(pTTime);
    } catch (e) {
      alert(context, 'Parse DateTime got an Error: ' + e.toString());
      return retVal = null;
    }

    var empId = await getUserLoginId();
    var body = jsonEncode({
      "employeeId": empId,
      "fromDate": pFDate + 'T' + pFTime,
      "leaveTypeId": pLType,
      "toDate": pTDate + 'T' + pTTime
    });

    var rsp = await postAPI(urlGetLeaveReqDay, body, context);

    if (rsp.statusCode == 200) {
      retVal = jsonDecode(rsp.body)['requstday'];
    } else {
      return retVal = null;
    }
    return retVal;
  }
}
