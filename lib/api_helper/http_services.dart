import 'dart:convert';

import 'package:bank/api_helper/error_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HttpService {
  // void hideLoading(BuildContext context) {
  //   Navigator.of(context).pop();
  // }

  // void showLoading(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       child: _FullScreenLoader());
  // }

  // void showLoadingSubmitTo(BuildContext context) {
  //   showDialog(
  //       context: context, barrierDismissible: false, child: SubmitToPage());
  // }

  //Set Token
  void setToken(strToken) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('token', strToken);
  }

  //Get Token
  Future<String> getToken() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    return 'Bearer' + token;
  }

//Setprefs
  void setPrefs(String key, String text) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(key, text);
  }

//getprefs
  Future<String> getPrefs(String key) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  //API Get
  Future<Response> get(String url) async {
    return await http.get(url, headers: {
      "Accept": "application/json",
      // "Content-Type": "application/json",
      "Authorization": await getToken()
    });
  }

  Future<Response> getAPI(String url, BuildContext context) async {
    enableLoading(context);
    var x = await http.get(url, headers: {
      "Accept": "application/json",
      // "Content-Type": "application/json",
      "Authorization": await getToken()
    });
    disableLoading(context);
    return x;
  }

  //API Post
  Future<Response> post(String url, String body) async {
    CircularProgressIndicator();
    return await http.post(
      url,
      headers: {
        "Authorization": await getToken(),
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: body,
    );
  }

  Future<Response> postAPI(
      String url, String body, BuildContext context) async {
    enableLoading(context);
    var x = await http.post(
      url,
      headers: {
        "Authorization": await getToken(),
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: body,
    );
    disableLoading(context);
    return x;
  }

  Future<http.Response> putAPI(
      BuildContext context, String url, String body) async {
    enableLoading(context);
    var rsp = await http.put(
      url,
      headers: {
        "Authorization": await getToken(),
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: body,
    );
    disableLoading(context);
    return rsp;
  }

  Future<Response> deleteAPI(BuildContext context, String url) async {
    enableLoading(context);
    var res = await http.delete(url, headers: {
      "Authorization": await getToken(),
      "Accept": "application/json",
      "Content-Type": "application/json",
    });
    disableLoading(context);
    return res;
  }

  //API Delete
  Future<Response> delete(String url) async {
    return await http.delete(
      url,
      headers: {
        "Authorization": await getToken(),
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );
  }

  //API Put/Update
  Future<Response> put(String url, String body) async {
    return await http.put(
      url,
      headers: {
        "Authorization": await getToken(),
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: body,
    );
  }

  Future<DateTime> datePicker(BuildContext context, DateTime dt) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dt,
      firstDate: DateTime(2015, 1),
      lastDate: DateTime(2100),
    );

    if (picked == null) {
      return dt;
    } else {
      return picked;
    }
  }

  Future<TimeOfDay> selectTime(BuildContext context, TimeOfDay time) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (picked == null) {
      return time;
    } else {
      return picked;
    }
  }

  void alert(BuildContext context, String msg) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
        ),
        duration: Duration(seconds: 5),
      ),
    );
  }

  void alertRsp(BuildContext context, Response response) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ErrorResponse.fromJson(jsonDecode(response.body)).errorDescription,
        ),
      ),
    );
  }

  void alertRespose(BuildContext context, String msg) {
    // scaffoldKey.currentState.showSnackBar(
    //   SnackBar(
    //     content: Text(msg),
    //     duration: Duration(seconds: 5),
    //   ),
    // );

    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: Duration(seconds: 5),
      ),
    );
  }

  void setUserLoginId(String strUserLoginId) async {
    var prefs = await SharedPreferences.getInstance();

    prefs.setString('UserLoginId', strUserLoginId);
  }

  Future<String> getUserLoginId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('UserLoginId') ?? '';
  }
}

// class _FullScreenLoader extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
//       child: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitCircle(
          color: Colors.red[900],
          size: 50,
        ),
      ),
      // child: Image(image: AssetImage('assets/logo.png'))),
    );
  }
}

void enableLoading(BuildContext context) {
  // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
  //   builder: (context) {
  //     return Loading();
  //   },
  // ));
  Navigator.push(context, MaterialPageRoute(
    builder: (context) {
      return Loading();
    },
  ));
}

void disableLoading(BuildContext context) {
  Navigator.pop(context);
}
