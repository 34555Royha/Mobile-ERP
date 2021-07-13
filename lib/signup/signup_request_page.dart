import 'package:bank/api_helper/http_services.dart';
import 'package:bank/app_utility/app_utilities.dart';
import 'package:bank/signup/signup_request_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpRequest extends StatefulWidget {
  @override
  _SignUpRequest createState() => new _SignUpRequest();
}

class _SignUpRequest extends State<SignUpRequest> {
  //
  var _txtStaffId = new TextEditingController();
  var _txtEmail = new TextEditingController();

  HttpService httpServices = new HttpService();
  final _scaffoldState = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  // String url = "http://$baseApiUrl/register/verify";
  @override
  Widget build(BuildContext context) {
    final title = Text(
      'Sign Up Request',
      style: TextStyle(
          color: Colors.red[900], fontWeight: FontWeight.bold, fontSize: 30),
      textAlign: TextAlign.center,
    );

    final txtStaffId = AppUtilities.textBox(
      _txtStaffId,
      'Staff Id',
      validate: true,
      keyboardType: TextInputType.number,
    );

    final txtEmail = AppUtilities.textBox(
      _txtEmail,
      'Email',
      validate: true,
      keyboardType: TextInputType.emailAddress,
    );

    final btnSubmit = AppUtilities.raisedButton(
      'Submit',
      color: Colors.blue[900],
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          SignupModel().postSignup(
            context,
            _scaffoldState,
            _txtStaffId.text,
            _txtEmail.text,
          );
        }
      },
    );

    return Scaffold(
      key: _scaffoldState,
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            children: <Widget>[
              title,
              SizedBox(height: 40.0),
              txtStaffId,
              SizedBox(height: 10.0),
              txtEmail,
              SizedBox(height: 10.0),
              btnSubmit
            ],
          ),
        ),
      ),
    );
  }
}

// final submitButton = Padding(
//   padding: EdgeInsets.symmetric(vertical: 16.0),
//   child: RaisedButton(
//     shape: RoundedRectangleBorder(
//       borderRadius: AppUtilities.borderRadius(),
//     ),
//     onPressed: () async {
//       try {
//         final response = await httpServices.post(url,
//             json.encode({"sidcard": _staffid.text, "email": _email.text}));
//         //"sokunnea.born@sbilhbank.com.kh"
//         if (response.statusCode == 200) {
//           Navigator.push(
//               context, MaterialPageRoute(builder: (context) => SignUp()));
//         } else {
//           _scaffoldKey.currentState.showSnackBar(
//             SnackBar(
//               content: Text(
//                 ErrorResponse.fromJson(jsonDecode(response.body))
//                     .errorDescription,
//               ),
//             ),
//           );
//         }
//       } catch (e) {
//         _scaffoldKey.currentState.showSnackBar(
//           SnackBar(
//             content: Text(e.toString()),
//           ),
//         );
//       }
//     },
//     padding: EdgeInsets.all(12),
//     color: Colors.blue[900],
//     child: Text('Submit', style: TextStyle(color: Colors.white)),
//   ),
// );
