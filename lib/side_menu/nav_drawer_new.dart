import 'dart:convert';

import 'package:bank/api_helper/error_response_model.dart';
import 'package:bank/api_helper/http_services.dart';
import 'package:bank/constance_routes/base_routes.dart';
import 'package:bank/provider/auth/login_page.dart';
import 'package:bank/provider/drawer/change_password_screen.dart';
import 'package:bank/side_menu/user_profile_model.dart';
import 'package:flutter/material.dart';

class NavDrawerNew extends StatefulWidget {
  @override
  _NavDrawerNewState createState() => _NavDrawerNewState();
}

class _NavDrawerNewState extends State<NavDrawerNew> with HttpService {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime dateLogin = DateTime.now();

  Userprofilemodel x = Userprofilemodel();
  var staffID;
  void data() async {
    var a = await getPrefs('username');
    var b = await getPrefs('email');
    staffID = await getUserLoginId();

    setState(() {
      x.fullName = a;
      x.email = b;
    });
  }

  // void getUserProfile() async {
  //   print(username);
  //   username = await getPrefs('username');
  //   email = await getPrefs('email');
  //   print(username);
  // }

  @override
  void initState() {
    // getUserProfile();
    super.initState();
    data();
  }

  @override
  Widget build(BuildContext context) {
    // getUserProfile();
    data();

    return Drawer(
      child: Container(
        key: _scaffoldKey,
        // color: Colors.blue[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[900],
              ),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 80,
                      //    color: Colors.pink,
                      child: Row(
                        children: [
                          Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red[900],
                              )),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '   ' + x.fullName,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '   Staff ID : $staffID',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 15),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      //       height: 30,
                      //   color: Colors.red,
                      child: Row(
                        children: [
                          Icon(
                            Icons.email,
                            color: Colors.white,
                            size: 17,
                          ),
                          Text('   ' + x.email,
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            // ListTile(
            //   leading: Icon(Icons.person, color: Colors.grey),
            //   title: Text(
            //     'My profile',
            //     style: TextStyle(color: Colors.grey),
            //   ),
            //   // onTap: () => {Navigator.of(context).pop()},
            //   onTap: () => {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => UserProfile(),
            //       ),
            //     ),
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.lock_open, color: Colors.grey),
              title:
                  Text('Change password', style: TextStyle(color: Colors.grey)),
              onTap: () => {
                // Navigator.of(context).pop("") //Close Drawer
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChangePassword()))
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.language, color: Colors.grey),
            //   title: Text('Language', style: TextStyle(color: Colors.grey)),
            //   // onTap: () => {Navigator.of(context).pop()},
            //   onTap: () => {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => Language()))
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.people, color: Colors.grey),
              title: Text('Contact us', style: TextStyle(color: Colors.grey)),
              onTap: () => {},
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.grey),
              title: Text('Settings', style: TextStyle(color: Colors.grey)),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.star_rate, color: Colors.grey),
              title: Text('Rate', style: TextStyle(color: Colors.grey)),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.grey),
              title: Text('Log out', style: TextStyle(color: Colors.grey)),
              onTap: () async {
                try {
                  var body = json.encode({"name": x.fullName});
                  final response = await post(urllogout, body);
                  print('code = ${response.statusCode}');
                  if (response.statusCode == 200) {
                    Navigator.pushReplacement(context,
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
            ),
          ],
        ),
      ),
    );
  }
}
