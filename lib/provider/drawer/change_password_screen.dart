import 'dart:convert';
import 'package:bank/app_utility/app_utilities.dart';
import 'package:bank/constance_routes/base_routes.dart';
import 'package:bank/api_helper/http_services.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => new _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  HttpService httpServices = new HttpService();

  TextEditingController _userid = new TextEditingController();
  TextEditingController _oldpass = new TextEditingController();
  TextEditingController _newpass = new TextEditingController();
  TextEditingController _confirmpass = new TextEditingController();
  String urlchangepass = "$httpMethod$baseApiUrl/profile/changepass";
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final username = TextFormField(
      controller: _userid,
      keyboardType: TextInputType.text,
      autofocus: false,
      // initialValue: 'sophanet@gmail.com',
      decoration: AppUtilities.textFormFieldDecoration('Username'),
      textInputAction: TextInputAction.next,
    );

    final oldPassword = TextFormField(
      controller: _oldpass,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: AppUtilities.textFormFieldDecoration('Old Password'),
      obscureText: true,
    );

    final newPassword = TextFormField(
      controller: _newpass,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: AppUtilities.textFormFieldDecoration('New Password'),
      obscureText: true,
    );

    final confirmNewPassword = TextFormField(
      controller: _confirmpass,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: AppUtilities.textFormFieldDecoration('Confirm New Password'),
      obscureText: true,
    );

    final submitButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: AppUtilities.borderRadius(),
        ),
        onPressed: () async {
          var response;
          try {
            if (_newpass.text == _confirmpass.text) {
              response = await httpServices.put(
                  urlchangepass,
                  json.encode({
                    "userID": _userid.text,
                    "oldPass": _oldpass.text,
                    "newPass": _newpass.text
                  }));
            } else {
              // _scaffoldKey.currentState.showSnackBar(SnackBar(
              //   content: Text("Invalid Confirm Password"),
              //   duration: Duration(milliseconds: 5000),
              //   action: SnackBarAction(
              //       label: "OK", onPressed: () => debugPrint("OK")),
              // ));
              CoolAlert.show(
                context: context,
                type: CoolAlertType.warning,
                title: "Change Password",
                text: "Invalid Confirm Password",
                onConfirmBtnTap: () {
                  Navigator.pop(context);
                },
              );
            }

            if (response.statusCode == 200) {
              // _scaffoldKey.currentState.showSnackBar(
              //   SnackBar(
              //     content: Text("Change password successful"),
              //     duration: Duration(milliseconds: 5000),
              //     action: SnackBarAction(
              //         label: "OK", onPressed: () => debugPrint("OK")),
              //   ),
              // );
              CoolAlert.show(
                context: context,
                type: CoolAlertType.success,
                title: "Change Password",
                text: "Completed Successfully!",
                onConfirmBtnTap: () {
                  Navigator.pop(context);
                },
              );
              /* Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ChangePassword()));*/
            } else {
              // _scaffoldKey.currentState.showSnackBar(
              //   SnackBar(
              //     content: Text(
              //       ErrorResponse.fromJson(jsonDecode(response.body))
              //           .errorDescription,
              //     ),
              //   ),
              // );
              CoolAlert.show(
                context: context,
                type: CoolAlertType.error,
                title: "Change Password",
                text: "Something Went Wrong",
                onConfirmBtnTap: () {
                  Navigator.pop(context);
                },
              );
            }
          } catch (e) {
            // _scaffoldKey.currentState.showSnackBar(
            //   SnackBar(
            //     content: Text(e.toString()),
            //   ),
            // );
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.blue[900],
        child: Text('Submit', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          children: <Widget>[
            username,
            SizedBox(height: 10.0),
            oldPassword,
            SizedBox(height: 10.0),
            newPassword,
            SizedBox(height: 10.0),
            confirmNewPassword,
            SizedBox(height: 10.0),
            submitButton,
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}

// class _ChangePasswordState extends State<ChangePassword> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false, // set it to false
//       appBar: AppBar(
//         title: Text('Change Password'),
//       ),

//       body: GestureDetector(
//         onTap: () {
//           FocusScope.of(context).requestFocus(FocusNode());
//         },
//         child: Builder(
//           builder: (context) => ListView(
//             // padding: Page.padding,
//             children: <Widget>[
//               //Username
//               Padding(
//                 // padding: EdgeInsets.only(top: 48.0),
//                 padding: EdgeInsets.all(15),
//                 child: TextField(
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0)),
//                       labelText: 'Username',
//                       hintText: 'Enter Username'),
//                 ),
//               ),

//               //Email
//               Padding(
//                 // padding: EdgeInsets.only(top: 48.0),
//                 padding: EdgeInsets.all(15),
//                 child: TextField(
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0)),
//                       labelText: 'Email',
//                       hintText: 'Enter Email'),
//                 ),
//               ),

//               //Old Password
//               Padding(
//                 // padding: EdgeInsets.only(top: 48.0),
//                 padding: EdgeInsets.all(15),
//                 child: TextField(
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0)),
//                       labelText: 'Old Password',
//                       hintText: 'Enter Old Password'),
//                 ),
//               ),

//               //New Password
//               Padding(
//                 // padding: EdgeInsets.only(top: 48.0),
//                 padding: EdgeInsets.all(15),
//                 child: TextField(
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0)),
//                       labelText: 'New Password',
//                       hintText: 'Enter New Password'),
//                 ),
//               ),

//               //Confirm New Password
//               Padding(
//                 // padding: EdgeInsets.only(top: 48.0),
//                 padding: EdgeInsets.all(15),
//                 child: TextField(
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0)),
//                       labelText: 'Confirm New Password',
//                       hintText: 'Enter Confirm New Password'),
//                 ),
//               ),

//               Padding(
//                 // padding: EdgeInsets.only(top: 48.0),
//                 padding: EdgeInsets.all(15),
//                 child: TextField(
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0)),
//                       labelText: 'Confirm New Password',
//                       hintText: 'Enter Confirm New Password'),
//                 ),
//               ),

//               Padding(
//                 // padding: EdgeInsets.only(top: 48.0),
//                 padding: EdgeInsets.all(5),
//                 child: FlatButton(
//                   child: Text(
//                     'Confirm',
//                     style: TextStyle(fontSize: 20.0),
//                   ),
//                   color: Colors.blueAccent,
//                   textColor: Colors.white,
//                   onPressed: () {},
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       // body: Padding(
//       //   // padding: EdgeInsets.all(5),
//       //   padding: EdgeInsets.symmetric(vertical: 16.0),

//       //   child: Column(
//       //     children: <Widget>[
//       //       Padding(
//       //         padding: EdgeInsets.all(15),
//       //         child: TextField(
//       //           decoration: InputDecoration(
//       //               // border: OutlineInputBorder(),
//       //               border: OutlineInputBorder(
//       //                   borderRadius: BorderRadius.circular(10.0)),
//       //               labelText: 'Username',
//       //               hintText: 'Enter Your Name'),
//       //         ),
//       //       ),
//       //       Padding(
//       //         padding: EdgeInsets.all(15),
//       //         child: TextField(
//       //           decoration: InputDecoration(
//       //               border: OutlineInputBorder(),
//       //               labelText: 'Email',
//       //               hintText: 'Enter Mail'),
//       //         ),
//       //       ),
//       //       Padding(
//       //         padding: EdgeInsets.all(15),
//       //         child: TextField(
//       //           decoration: InputDecoration(
//       //               border: OutlineInputBorder(),
//       //               labelText: 'Old Password',
//       //               hintText: 'Enter Old Password'),
//       //         ),
//       //       ),
//       //       Padding(
//       //         padding: EdgeInsets.all(15),
//       //         child: TextField(
//       //           decoration: InputDecoration(
//       //               border: OutlineInputBorder(),
//       //               labelText: 'New Password',
//       //               hintText: 'Enter New Password'),
//       //         ),
//       //       ),
//       //       Padding(
//       //         padding: EdgeInsets.all(15),
//       //         child: TextField(
//       //           decoration: InputDecoration(
//       //               border: OutlineInputBorder(),
//       //               labelText: 'Confirm New Password',
//       //               hintText: 'Enter Confirm New Password'),
//       //         ),
//       //       ),
//       //       Padding(
//       //         padding: EdgeInsets.all(15),
//       //         child: FlatButton(
//       //           child: Text(
//       //             'Confirm',
//       //             style: TextStyle(fontSize: 20.0),
//       //           ),
//       //           color: Colors.blueAccent,
//       //           textColor: Colors.white,
//       //           onPressed: () {},
//       //         ),
//       //       )
//       //     ],
//       //   ),
//       // ),
//     );
//   }
// }
