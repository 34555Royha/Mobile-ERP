import 'dart:convert';
import 'package:bank/constance_routes/base_routes.dart';
import 'package:http/http.dart' as http;

import 'package:bank/api_helper/http_services.dart';
import 'package:bank/signup/signup_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignupModel with HttpService {
  String email;
  String fullName;
  String password;
  String remoteAddr;
  int retval;
  String sidcard;
  String userId;

  SignupModel({
    this.email,
    this.fullName,
    this.password,
    this.remoteAddr,
    this.retval,
    this.sidcard,
    this.userId,
  });

  factory SignupModel.fromJson(Map<String, dynamic> json) => SignupModel(
        email: json["email"],
        fullName: json["fullName"],
        password: json["password"],
        remoteAddr: json["remoteAddr"],
        retval: json["retval"],
        sidcard: json["sidcard"],
        userId: json["userID"],
      );

  void postSignup(
    BuildContext context,
    GlobalKey<ScaffoldState> scaffoldState,
    String sid,
    String email,
  ) async {
    try {
      var body = jsonEncode({
        "sidcard": sid,
        "email": email,
      });

      final rsp = await http.post(
        urlRegister,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: body,
      );

      if (rsp.statusCode == 200) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignUp(),
            ));
      } else {
        scaffoldState.currentState.hideCurrentSnackBar();
        scaffoldState.currentState.showSnackBar(
          SnackBar(
            duration: Duration(seconds: 360),
            content: Text(rsp.body),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {}
  }
}
