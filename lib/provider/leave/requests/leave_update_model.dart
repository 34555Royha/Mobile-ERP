import 'package:bank/api_helper/http_services.dart';
import 'package:bank/constance_routes/leave_routes.dart';
import 'package:bank/provider/leave/leave_page.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeaveUpdateModel with HttpService {
  String assignId;
  String leaveFrom;
  String leaveTo;
  String ltypeId;
  String numReq;
  String numType;
  String reasonType;
  String remarks;
  String requestId;
  String schClassId;
  String valueDate;

  LeaveUpdateModel({
    this.assignId,
    this.leaveFrom,
    this.leaveTo,
    this.ltypeId,
    this.numReq,
    this.numType,
    this.reasonType,
    this.remarks,
    this.requestId,
    this.schClassId,
    this.valueDate,
  });

  factory LeaveUpdateModel.fromJson(Map<String, dynamic> json) =>
      LeaveUpdateModel(
        assignId: json["assignID"],
        leaveFrom: json["leaveFrom"],
        leaveTo: json["leaveTo"],
        ltypeId: json["ltypeID"],
        numReq: json["numReq"],
        numType: json["numType"],
        reasonType: json["reasonType"],
        remarks: json["remarks"],
        requestId: json["requestID"],
        schClassId: json["schClassID"],
        valueDate: json["valueDate"],
      );

  Map<String, dynamic> toJson() => {
        "assignID": assignId,
        "leaveFrom": leaveFrom,
        "leaveTo": leaveTo,
        "ltypeID": ltypeId,
        "numReq": numReq,
        "numType": numType,
        "reasonType": reasonType,
        "remarks": remarks,
        "requestID": requestId,
        "schClassID": schClassId,
        "valueDate": valueDate,
      };

  Future updateLeave(BuildContext context, String body) async {
    var rsp = await putAPI(context, urlCreateLeaveRequest, body);

    if (rsp.statusCode == 200) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        title: 'Save',
        text: "Transaction completed successfully!",
        // onConfirmBtnTap: () async {
        //   Navigator.pop(context);
        // }
        // onConfirmBtnTap: () async {
        //   Navigator.pop(context);
        //   Navigator.pop(context);
        //   // Navigator.of(context)..pop()..pop(context);
        //   // await Navigator.of(context).push(MaterialPageRoute(
        //   //   builder: (context) => LeaveRequestItem(),
        //   // ));
        //   // setState(() {});
        // },
      );
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: 'Save',
        text: rsp.statusCode.toString() + ": " + rsp.body,
      );
    }
  }

  void updateLeaveReq(BuildContext context, String body) async {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      title: 'Update',
      text: 'Would you like to Update?',
      confirmBtnColor: Colors.red,
      onConfirmBtnTap: () async {
        Navigator.pop(context);

        var rsp = await putAPI(context, urlCreateLeaveRequest, body);
        if (rsp.statusCode == 200) {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            title: 'Update',
            text: "Completed with successfully!",
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
            title: 'Update',
            text: rsp.statusCode.toString() + ": " + rsp.body,
          );
        }
      },
    );
  }
}
