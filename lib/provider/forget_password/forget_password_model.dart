import 'dart:convert';

import 'package:bank/api_helper/http_services.dart';
import 'package:bank/app_utility/app_utilities.dart';
import 'package:bank/constance_routes/base_routes.dart';
import 'package:bank/provider/forget_password/password_verification_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecoveryPasswordModel extends HttpService {
  String userId;
  String email;

  RecoveryPasswordModel({
    this.userId,
    this.email,
  });

  factory RecoveryPasswordModel.fromJson(Map<String, dynamic> json) =>
      RecoveryPasswordModel(
        userId: json["userId"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "email": email,
      };

  Future<int> recoveryPassword(
      String userId, String email, BuildContext context) async {
    var x = new RecoveryPasswordModel(
      userId: userId,
      email: email,
    );

    var body = jsonEncode(x.toJson());

    var rsp = await http.post(
      urlRecoveryPassword,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: body,
      encoding: Encoding.getByName('utf-8'),
    );

    if (rsp.statusCode == 200) {
      AppUtilities.snackBarButton(
          context, 'Click Ok to confirm new password', 'Ok', onPressed: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PasswordVerification(
                recoveryPasswordModel: x,
              ),
            ));
      });
    } else {
      AppUtilities.snackBarButton(context, rsp.body, 'Okay');
    }

    return rsp.statusCode;
  }
}
