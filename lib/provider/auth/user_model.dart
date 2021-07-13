import 'dart:convert';
import 'package:bank/api_helper/http_services.dart';
import 'package:bank/constance_routes/base_routes.dart';
import 'package:http/http.dart' as http;

class UserModel extends HttpService {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final String scope;
  final String jti;

  UserModel(
      {this.accessToken, this.tokenType, this.expiresIn, this.jti, this.scope});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        accessToken: json['access_token'],
        tokenType: json['token_type'],
        expiresIn: json['expires_in'],
        scope: json['scope'],
        jti: json['jti']);
  }
  // Future<http.Response> login(String username, String password) async {
  //   final response = await http.post(
  //     urlAccessToken,
  //     body: {
  //       'grant_type': 'password',
  //       'username': username,
  //       'password': password,
  //     },
  //     headers: {
  //       "Accept": "application/json",
  //       "Content-Type": "application/x-www-form-urlencoded"
  //     },
  //     encoding: Encoding.getByName('utf-8'),
  //   );
  //   return response;
  // }

  Future<http.Response> appLogin(String username, String password) async {
    var rsp = await http.post(
      urlAccessToken,
      body: {
        'grant_type': 'password',
        'username': username,
        'password': password,
      },
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      encoding: Encoding.getByName('utf-8'),
    );

    return rsp;
  }
}
