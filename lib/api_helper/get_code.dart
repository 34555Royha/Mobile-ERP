import 'package:bank/api_helper/http_services.dart';
import 'package:bank/constance_routes/base_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class CodeName extends HttpService {
  String name;
  String code;

  CodeName({this.name, this.code});

  factory CodeName.fromJson(Map<String, dynamic> json) {
    return CodeName(
      name: json["name"],
      code: json["code"],
    );
  }

  List<CodeName> jsonList(Map<String, dynamic> json, String jName) {
    if (json[jName] == null) {
      return new List<CodeName>();
    }
    return List<CodeName>.from(
      json[jName].map(
        (e) => CodeName.fromJson(e),
      ),
    );
  }

  Future<http.Response> getCodeName(String url) async {
    return await get(url);
  }

  Future<String> getCodeNameJson(BuildContext context) async {
    http.Response rsp = await getAPI(urlGetParams, context);
    // print(jsonDecode(rsp.body));
    if (rsp.statusCode == 200) {
      return (rsp.body).toString();
    }
    return null;
  }
}
