// To parse this JSON data, do
//
//     final viewProfile = viewProfileFromMap(jsonString);

import 'dart:convert';

ViewProfile viewProfileFromMap(String str) =>
    ViewProfile.fromMap(json.decode(str));

String viewProfileToMap(ViewProfile data) => json.encode(data.toMap());

class ViewProfile {
  ViewProfile({
    this.mailitemId,
    this.gname,
    this.branchname,
    this.groupid,
    this.employeeid,
    this.id,
    this.glevel,
    this.lanName,
    this.noAllowJob,
    this.pwAlgorithm,
    this.noAllowGrd,
    this.computerName,
    this.alertFlag,
    this.usys,
    this.ulocked,
    this.udlang,
    this.ucpwd,
    this.userPwd,
    this.upwdcr,
    this.ualogin,
    this.branchId,
    this.expirePass,
    this.companyName,
    this.jobTitle,
    this.createdFrom,
    this.inheritDay,
    this.pwExpireDay,
    this.updatedFrom,
    this.updatedBy,
    this.exportFlag,
    this.grantWebAcc,
    this.webAddress,
    this.jobTitleId,
    this.noAllowBr,
    this.noAllowSub,
    this.inheritHour,
    this.authStatus,
    this.noAllowReport,
    this.linkUser,
    this.enPwExpire,
    this.noAllowCat,
    this.enPwPolicy,
    this.companyId,
    this.phone,
    this.fullName,
    this.userId,
    this.email,
    this.newPass,
  });

  dynamic mailitemId;
  String gname;
  String branchname;
  String groupid;
  dynamic employeeid;
  int id;
  String glevel;
  String lanName;
  String noAllowJob;
  String pwAlgorithm;
  String noAllowGrd;
  String computerName;
  String alertFlag;
  String usys;
  String ulocked;
  String udlang;
  String ucpwd;
  String userPwd;
  String upwdcr;
  String ualogin;
  String branchId;
  int expirePass;
  dynamic companyName;
  dynamic jobTitle;
  String createdFrom;
  dynamic inheritDay;
  int pwExpireDay;
  String updatedFrom;
  String updatedBy;
  String exportFlag;
  String grantWebAcc;
  dynamic webAddress;
  dynamic jobTitleId;
  String noAllowBr;
  String noAllowSub;
  dynamic inheritHour;
  String authStatus;
  String noAllowReport;
  String linkUser;
  String enPwExpire;
  String noAllowCat;
  String enPwPolicy;
  String companyId;
  dynamic phone;
  String fullName;
  String userId;
  String email;
  String newPass;

  factory ViewProfile.fromMap(Map<String, dynamic> json) => ViewProfile(
        mailitemId: json["mailitem_id"],
        gname: json["gname"],
        branchname: json["branchname"],
        groupid: json["groupid"],
        employeeid: json["employeeid"],
        id: json["id"],
        glevel: json["glevel"],
        lanName: json["lanName"],
        noAllowJob: json["noAllowJob"],
        pwAlgorithm: json["pwAlgorithm"],
        noAllowGrd: json["noAllowGrd"],
        computerName: json["computerName"],
        alertFlag: json["alertFlag"],
        usys: json["usys"],
        ulocked: json["ulocked"],
        udlang: json["udlang"],
        ucpwd: json["ucpwd"],
        userPwd: json["userPWD"],
        upwdcr: json["upwdcr"],
        ualogin: json["ualogin"],
        branchId: json["branchID"],
        expirePass: json["expirePass"],
        companyName: json["companyName"],
        jobTitle: json["jobTitle"],
        createdFrom: json["createdFrom"],
        inheritDay: json["inheritDay"],
        pwExpireDay: json["pwExpireDay"],
        updatedFrom: json["updatedFrom"],
        updatedBy: json["updatedBy"],
        exportFlag: json["exportFlag"],
        grantWebAcc: json["grantWebAcc"],
        webAddress: json["webAddress"],
        jobTitleId: json["jobTitleID"],
        noAllowBr: json["noAllowBr"],
        noAllowSub: json["noAllowSub"],
        inheritHour: json["inheritHour"],
        authStatus: json["authStatus"],
        noAllowReport: json["noAllowReport"],
        linkUser: json["linkUser"],
        enPwExpire: json["enPwExpire"],
        noAllowCat: json["noAllowCat"],
        enPwPolicy: json["enPwPolicy"],
        companyId: json["companyID"],
        phone: json["phone"] == null ? "n/a" : json["phone"],
        fullName: json["fullName"] == null ? "n/a" : json["fullName"],
        userId: json["userID"],
        email: json["email"] == null ? "n/a" : json["email"],
        newPass: json["newPass"],
      );

  Map<String, dynamic> toMap() => {
        "mailitem_id": mailitemId,
        "gname": gname,
        "branchname": branchname,
        "groupid": groupid,
        "employeeid": employeeid,
        "id": id,
        "glevel": glevel,
        "lanName": lanName,
        "noAllowJob": noAllowJob,
        "pwAlgorithm": pwAlgorithm,
        "noAllowGrd": noAllowGrd,
        "computerName": computerName,
        "alertFlag": alertFlag,
        "usys": usys,
        "ulocked": ulocked,
        "udlang": udlang,
        "ucpwd": ucpwd,
        "userPWD": userPwd,
        "upwdcr": upwdcr,
        "ualogin": ualogin,
        "branchID": branchId,
        "expirePass": expirePass,
        "companyName": companyName,
        "jobTitle": jobTitle,
        "createdFrom": createdFrom,
        "inheritDay": inheritDay,
        "pwExpireDay": pwExpireDay,
        "updatedFrom": updatedFrom,
        "updatedBy": updatedBy,
        "exportFlag": exportFlag,
        "grantWebAcc": grantWebAcc,
        "webAddress": webAddress,
        "jobTitleID": jobTitleId,
        "noAllowBr": noAllowBr,
        "noAllowSub": noAllowSub,
        "inheritHour": inheritHour,
        "authStatus": authStatus,
        "noAllowReport": noAllowReport,
        "linkUser": linkUser,
        "enPwExpire": enPwExpire,
        "noAllowCat": noAllowCat,
        "enPwPolicy": enPwPolicy,
        "companyID": companyId,
        "phone": phone,
        "fullName": fullName,
        "userID": userId,
        "email": email,
        "newPass": newPass,
      };
}
