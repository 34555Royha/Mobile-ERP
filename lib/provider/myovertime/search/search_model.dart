import 'package:bank/api_helper/http_services.dart';
import 'package:bank/constance_routes/base_routes.dart';
import 'package:http/http.dart' as http;

class SearchmodelS extends HttpService {
  SearchmodelS({
    this.name,
    this.code,
  });

  String name;
  String code;

  factory SearchmodelS.fromMap(Map<String, dynamic> json) => SearchmodelS(
        name: json["name"],
        code: json["code"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "code": code,
      };
  String urlgetsearch = '$httpMethod$baseApiUrl/overtime/sup';
  Future<http.Response> getSearchlist() async {
    return await get(urlgetsearch);
  }
}
