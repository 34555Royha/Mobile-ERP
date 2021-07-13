import 'package:bank/api_helper/http_services.dart';
import 'package:bank/app_utility/app_utilities.dart';
import 'package:bank/provider/forget_password/forget_password_model.dart';
import 'package:flutter/material.dart';

class PasswordVerification extends StatefulWidget {
  final RecoveryPasswordModel recoveryPasswordModel;

  const PasswordVerification({Key key, this.recoveryPasswordModel})
      : super(key: key);
  @override
  _PasswordVerificationState createState() => _PasswordVerificationState();
}

class _PasswordVerificationState extends State<PasswordVerification>
    with HttpService {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    firstLoading();
  }

  var _txtEmail = TextEditingController();
  var _txtFullName = TextEditingController();
  var _txtUsername = TextEditingController();
  var _txtPassword = TextEditingController();
  var _txtConfirmPassword = TextEditingController();

  void firstLoading() {
    _txtUsername.text = widget.recoveryPasswordModel.userId;
    _txtEmail.text = widget.recoveryPasswordModel.email;
  }

  bool verifyPwd() {
    if (_txtPassword.text == _txtConfirmPassword.text) {
      return true;
    }

    AppUtilities.snackBar(_formKey.currentContext, 'Password are not matched.');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final title = Text(
      'Verify Password',
      style: TextStyle(
          color: Colors.red[900], fontWeight: FontWeight.bold, fontSize: 30),
      textAlign: TextAlign.center,
    );

    final txtEmail = AppUtilities.textBox(
      _txtEmail,
      'Email',
      validate: true,
      readOnly: true,
    );

    final txtFullName = AppUtilities.textBox(
      _txtFullName,
      'FullName',
      validate: true,
      readOnly: true,
    );

    final txtUsername = AppUtilities.textBox(
      _txtUsername,
      'Username',
      validate: true,
      readOnly: true,
    );

    final txtPassword = AppUtilities.textBox(
      _txtPassword,
      'Password',
      validate: true,
      obscureText: true,
    );

    final txtConfirmPassword = AppUtilities.textBox(
      _txtConfirmPassword,
      'Confirm Password',
      validate: true,
      obscureText: true,
    );

    var btnConfirm = AppUtilities.raisedButton(
      'Confirm',
      color: Colors.blue[900],
      onPressed: () async {
        if (_formKey.currentState.validate() && verifyPwd()) {
          // Visible Keyboard
          FocusScope.of(context).requestFocus(FocusScopeNode());

          // final rsp = await UserModel().appLogin(
          //   _txtUsername.text,
          //   _txtPassword.text,
          // );

          // if (rsp.statusCode == 200) {}
        }
      },
    );

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            children: [
              title,
              SizedBox(height: 10.0),
              txtEmail,
              SizedBox(height: 10.0),
              txtFullName,
              SizedBox(height: 10.0),
              txtUsername,
              SizedBox(height: 10.0),
              txtPassword,
              SizedBox(height: 10.0),
              txtConfirmPassword,
              SizedBox(height: 10.0),
              btnConfirm,
            ],
          ),
        ),
      ),
    );
  }
}
