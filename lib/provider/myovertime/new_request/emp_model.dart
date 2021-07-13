class EmpModel {
  String employeeId;
  String fullName;

  EmpModel({
    this.employeeId,
    this.fullName,
  });

  factory EmpModel.fromJson(Map<String, dynamic> json) {
    return EmpModel(
      employeeId: json["employeeId"],
      fullName: json["fullName"],
    );
  }
}
