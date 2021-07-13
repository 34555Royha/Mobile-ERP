import 'dart:convert';

import 'package:bank/api_helper/http_services.dart';
import 'package:bank/app_utility/app_utilities.dart';
import 'package:bank/constance_routes/base_routes.dart';
import 'package:bank/provider/auth/user_model.dart';
import 'package:bank/provider/forget_password/forget_password_page.dart';

import 'package:bank/provider/home_page/home_page.dart';

import 'package:bank/side_menu/user_profile_model.dart';
import 'package:bank/signup/signup_request_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with HttpService {
  final _formKey = GlobalKey<FormState>();

  UserModel userModel = new UserModel();
  // NavDrawer navDrawer = new NavDrawer();

// Function GetUserProfile
  Future getUserProfile() async {
    //get data
    http.Response rsp = await get(urlGetUserProfile);

    if (rsp.statusCode == 200) {
      final Userprofilemodel userprofilemodel =
          Userprofilemodel.fromMap(jsonDecode(rsp.body));

      // SetPreferences
      setPrefs("username", userprofilemodel.fullName);
      setPrefs(
        "email",
        userprofilemodel.email,
      );
    } else {
      alertRespose(context, rsp.body);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _txtUsername = TextEditingController();
    var _txtPassword = TextEditingController();

    final title = Text(
      'Login',
      style: TextStyle(
          color: Colors.red[900], fontWeight: FontWeight.bold, fontSize: 30),
      textAlign: TextAlign.center,
    );

    var txtUsername = AppUtilities.textBox(
      _txtUsername,
      'Username',
      validate: true,
    );
    var txtPassword = AppUtilities.textBox(
      _txtPassword,
      'Password',
      validate: true,
      obscureText: true,
    );

    var btnLoging = AppUtilities.raisedButton(
      'Login',
      color: Colors.blue[900],
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          /* Visible Keyboard */
          FocusScope.of(context).requestFocus(FocusNode());

          //Set value for API's IP Address
          // ipAdd = '192.168.1.118';

          print(ipAdd);

          //Send API
          final rsp = await userModel.appLogin(
            _txtUsername.text,
            _txtPassword.text,
          );

          print(rsp.statusCode);

          if (rsp.statusCode == 200) {
            userModel = UserModel.fromJson(jsonDecode(rsp.body));

            //Set Token
            setToken(userModel.accessToken);

            getUserProfile();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          } else {
            AppUtilities.snackBar(
              _formKey.currentContext,
              jsonDecode(rsp.body)["error_description"],
            );
          }
        }
      },
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forget password',
        style: TextStyle(color: Colors.blue[900]),
      ),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ForgetPassword()));
      },
    );

    final signupLabel = FlatButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpRequest()));
      },
      child: Text(
        'New User? Register',
        style: TextStyle(color: Colors.blue[900]),
      ),
    );

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            children: <Widget>[
              title,
              SizedBox(height: 40.0),
              txtUsername,
              SizedBox(height: 10.0),
              txtPassword,
              SizedBox(height: 10.0),
              forgotLabel,
              SizedBox(height: 10.0),
              btnLoging,
              signupLabel
            ],
          ),
        ),
      ),
    );
  }
}
