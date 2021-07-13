class OvertimUpdateModel {
  OvertimUpdateModel({
    this.requestId,
    this.requestDate,
    this.paymentDate,
    this.overtimeDate,
    this.startTime,
    this.endTime,
    this.numHour,
    this.hourType,
    this.remarks,
    this.salType,
    this.salRate,
    this.assignId,
    this.nextTran,
    this.chgDeptId,
    this.reasonType,
  });

  String requestId;
  String requestDate;
  String paymentDate;
  String overtimeDate;
  String startTime;
  String endTime;
  String numHour;
  String hourType;
  String remarks;
  String salType;
  String salRate;
  String assignId;
  String nextTran;
  String chgDeptId;
  String reasonType;

  Map<String, dynamic> toJson() => {
        "requestID": requestId,
        "requestDate": requestDate,
        "paymentDate": paymentDate,
        "overtimeDate": overtimeDate,
        "startTime": startTime,
        "endTime": endTime,
        "numHour": numHour,
        "hourType": hourType,
        "remarks": remarks,
        "salType": salType,
        "salRate": salRate,
        "assignID": assignId,
        "nextTran": nextTran,
        "chgDeptID": chgDeptId,
        "reasonType": reasonType,
      };
}
