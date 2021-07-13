import 'dart:convert';
import 'package:bank/api_helper/http_services.dart';
import 'package:bank/api_helper/error_response_model.dart';
import 'package:bank/app_utility/app_utilities.dart';
import 'package:bank/constance_routes/base_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUp createState() => new _SignUp();
}

class _SignUp extends State<SignUp> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  HttpService httpServices = new HttpService();
  String url = "http://$baseApiUrl/register/create";

  TextEditingController _staffid = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _fullname = new TextEditingController();
  TextEditingController _userid = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final title = Text(
      'Sign Up',
      style: TextStyle(
          color: Colors.red[900], fontWeight: FontWeight.bold, fontSize: 30),
      textAlign: TextAlign.center,
    );

    final staffID = TextFormField(
      controller: _staffid,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: AppUtilities.textFormFieldDecoration('Staff ID'),
    );

    final email = TextFormField(
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: AppUtilities.textFormFieldDecoration('Email'),
    );

    final staffName = TextFormField(
      controller: _fullname,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: AppUtilities.textFormFieldDecoration('Staff name'),
    );

    final username = TextFormField(
      controller: _userid,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: AppUtilities.textFormFieldDecoration('Username'),
    );

    final password = TextFormField(
      controller: _password,
      autofocus: false,
      obscureText: true,
      decoration: AppUtilities.textFormFieldDecoration('Password'),
    );

    final confirmButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: AppUtilities.borderRadius(),
        ),
        onPressed: () async {
          try {
            final response = await httpServices.post(
                url,
                json.encode({
                  "sidcard": _staffid.text,
                  "email": _email.text,
                  "fullName": _fullname.text,
                  "userID": _userid.text,
                  "password": _password.text
                }));
            if (response.statusCode == 200) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignUp()));
            } else {
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  content: Text(
                    ErrorResponse.fromJson(jsonDecode(response.body))
                        .errorDescription,
                  ),
                ),
              );
            }
          } catch (e) {
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text(e.toString()),
              ),
            );
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.blue[900],
        child: Text('Confirm', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          children: <Widget>[
            title,
            SizedBox(height: 40.0),
            staffID,
            SizedBox(height: 10.0),
            email,
            SizedBox(height: 10.0),
            staffName,
            SizedBox(height: 10.0),
            username,
            SizedBox(height: 10.0),
            password,
            confirmButton
          ],
        ),
      ),
    );
  }
}
