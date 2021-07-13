import 'package:bank/api_helper/http_services.dart';
import 'package:bank/constance_routes/leave_routes.dart';
import 'package:bank/provider/leave/leave_page.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LeaveDeleteModel extends HttpService {
  String requestId;
  String userId;

  LeaveDeleteModel({
    this.requestId,
    this.userId,
  });

  factory LeaveDeleteModel.fromJson(Map<String, dynamic> json) =>
      LeaveDeleteModel(
        requestId: json["requestID"],
        userId: json["userID"],
      );
  Map<String, dynamic> toJson() => {
        "requestID": requestId,
        "userID": userId,
      };

  void deleteLeaveReq(BuildContext context, String id) async {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      title: 'Delete',
      text: 'Would you like to delete?',
      confirmBtnColor: Colors.red,
      onConfirmBtnTap: () async {
        Navigator.pop(context);
        var url = urlLeaveDelete + '?id=' + id;
        http.Response rsp = await deleteAPI(context, url);

        // print(url);

        if (rsp.statusCode == 200) {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            title: 'Delete',
            text: 'Transaction has been deleted successfully!',
            onConfirmBtnTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Leave(),
                ),
              );
            },
          );
        } else {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: 'Delete',
            text: rsp.statusCode.toString() + ": " + rsp.body,
          );
        }
      },
    );
  }
}
