import 'dart:convert';

Userprofilemodel userprofilemodelFromMap(String str) =>
    Userprofilemodel.fromMap(json.decode(str));

String userprofilemodelToMap(Userprofilemodel data) =>
    json.encode(data.toMap());

class Userprofilemodel {
  Userprofilemodel({
    this.fullName,
    this.email,
  });

  String fullName;
  String email;

  factory Userprofilemodel.fromMap(Map<String, dynamic> json) =>
      Userprofilemodel(
        fullName: json["fullName"],
        email: json["email"],
      );

  Map<String, dynamic> toMap() => {
        "fullName": fullName,
        "email": email,
      };
}
