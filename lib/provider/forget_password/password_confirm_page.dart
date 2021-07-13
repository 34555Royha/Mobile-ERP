import 'dart:convert';

import 'package:bank/api_helper/error_response_model.dart';
import 'package:bank/api_helper/http_services.dart';
import 'package:bank/app_utility/app_utilities.dart';
import 'package:bank/constance_routes/base_routes.dart';
import 'package:bank/provider/auth/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PasswordConfirm extends StatefulWidget {
  @override
  _PasswordConfirm createState() => new _PasswordConfirm();
}

class _PasswordConfirm extends State<PasswordConfirm> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  HttpService httpServices = new HttpService();

  TextEditingController _staffid = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _staffname = new TextEditingController();
  TextEditingController _userid = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  String url = "http://$baseApiUrl/profile/resetpassword";
  @override
  Widget build(BuildContext context) {
    final title = Text(
      'Password Confirmation',
      style: TextStyle(
          color: Colors.red[900], fontWeight: FontWeight.bold, fontSize: 30),
      textAlign: TextAlign.center,
    );

    final staffID = TextFormField(
      controller: _staffid,
      keyboardType: TextInputType.text,
      autofocus: false,
      // initialValue: 'sophanet@gmail.com',
      // decoration: InputDecoration(
      //   hintText: 'Staff ID',
      //   contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      //   border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      // ),
      decoration: AppUtilities.textFormFieldDecoration('Staff ID'),
    );

    final email = TextFormField(
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      // initialValue: 'sophanet@gmail.com',
      // decoration: InputDecoration(
      //   hintText: 'Email',
      //   contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      //   border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      // ),
      decoration: AppUtilities.textFormFieldDecoration('Email'),
    );

    final staffName = TextFormField(
      controller: _staffname,
      keyboardType: TextInputType.text,
      autofocus: false,
      // initialValue: 'sophanet@gmail.com',
      // decoration: InputDecoration(
      //   hintText: 'Staff name',
      //   contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      //   border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      // ),
      decoration: AppUtilities.textFormFieldDecoration('Staff Name'),
    );

    final username = TextFormField(
      controller: _userid,
      keyboardType: TextInputType.text,
      autofocus: false,
      // initialValue: 'sophanet@gmail.com',
      // decoration: InputDecoration(
      //   hintText: 'Username',
      //   contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      //   border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      // ),
      decoration: AppUtilities.textFormFieldDecoration('Username'),
    );

    final password = TextFormField(
      controller: _password,
      autofocus: false,
      // initialValue: 'some password',
      obscureText: true,
      // decoration: InputDecoration(
      //   hintText: 'Password',
      //   contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      //   border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      // ),
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
            final response = await httpServices.put(
                url,
                json.encode({
                  "sidcard": _staffid.text,
                  "email": _email.text,
                  "fullName": _staffname.text,
                  "userID": _userid.text,
                  "password": _password.text
                }));
            //"sokunnea.born@sbilhbank.com.kh"
            if (response.statusCode == 200) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
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
