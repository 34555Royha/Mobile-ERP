import 'package:bank/app_utility/app_utilities.dart';
import 'package:bank/provider/forget_password/forget_password_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ForgetPassword extends StatefulWidget {
  RecoveryPasswordModel recoveryPasswordModel;
  ForgetPassword({
    Key key,
    this.recoveryPasswordModel,
  }) : super(key: key);
  static String tag = 'forget-password-page';
  @override
  _ForgetPasswordPageState createState() => new _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var _txtUsername = TextEditingController();
    var _txtEmail = TextEditingController();

    final title = Text(
      'Forget Password',
      style: TextStyle(
          color: Colors.red[900], fontWeight: FontWeight.bold, fontSize: 30),
      textAlign: TextAlign.center,
    );

    final txtUsername = AppUtilities.textBox(
      _txtUsername,
      'Username',
      validate: true,
    );

    final txtEmail = AppUtilities.textBox(
      _txtEmail,
      'Email',
      validate: true,
    );

    final btnSubmit = AppUtilities.raisedButton(
      'Submit',
      color: Colors.blue[900],
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          RecoveryPasswordModel().recoveryPassword(
            _txtUsername.text,
            _txtEmail.text,
            _formKey.currentContext,
          );
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
              SizedBox(height: 40.0),
              txtUsername,
              SizedBox(height: 10.0),
              txtEmail,
              btnSubmit
            ],
          ),
        ),
      ),
    );
  }
}
