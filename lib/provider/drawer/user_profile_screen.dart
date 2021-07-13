import 'package:bank/api_helper/http_services.dart';
import 'package:bank/constance_routes/base_routes.dart';
import 'package:bank/provider/drawer/user_profile_model.dart';
import 'package:bank/provider/forget_password/forget_password_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'language_screen.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  HttpService httpServices = new HttpService();
  String url = "$httpMethod$baseApiUrl/profile";
  //var response;

  // function get data

  // Future getData() async {
  //   final response = await httpServices.get(url);
  //   return json.decode(response.body);
  // }

  Future<ViewProfile> get getData async {
    http.Response response = await httpServices.get(url);
    if (response.statusCode == 200) {
      return compute(viewProfileFromMap, response.body);
    } else {
      throw Exception("Error Code: ${response.statusCode}");
    }
  }

  double _withOfScreen;
  @override
  Widget build(BuildContext context) {
    _withOfScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Colors.blue[900],
      ),
      body: _buildBody,
    );
  }

  get _buildBody {
    return Center(
      child: SingleChildScrollView(
        child: FutureBuilder(
          future: getData,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error while loading${snapshot.error}");
            } else {
              if (snapshot.connectionState == ConnectionState.done) {
                ViewProfile viewProfile = snapshot.data;
                return Column(
                  children: [
                    Container(
                      width: _withOfScreen,
                      height: 130,
                      margin: EdgeInsets.only(bottom: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 270,
                              height: 130,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "   " + viewProfile.fullName,
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Icon(Icons.email),
                                        Text("   " + viewProfile.email),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Icon(Icons.phone),
                                        Text("    " + viewProfile.phone),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 5),
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue[900],
                                )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: _withOfScreen,
                      height: 99,
                      color: Colors.white,
                      //color: Colors.grey,
                      margin: EdgeInsets.only(bottom: 10),
                      child: GridView.count(
                        crossAxisCount: 3,
                        // mainAxisSpacing: 10,
                        // crossAxisSpacing: 10,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(viewProfile.companyId),
                                Text("Leave balance")
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(viewProfile.companyId),
                                Text("Taken")
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(viewProfile.companyId),
                                Text("Available")
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _withOfScreen,
                      height: 400,
                      // color: Colors.red,
                      child: ListView(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgetPassword()));
                            },
                            child: Card(
                              child: ListTile(
                                leading: Icon(Icons.person),
                                title: Text("Reset password"),
                                trailing: Icon(Icons.navigate_next_outlined),
                              ),
                            ),
                          ),
                          InkWell(
                            child: Card(
                              child: ListTile(
                                leading: Icon(Icons.location_on),
                                title: Text("My Address"),
                                trailing: Icon(Icons.navigate_next_outlined),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Language()));
                            },
                            child: Card(
                              child: ListTile(
                                leading: Icon(Icons.language),
                                title: Text("Language"),
                                trailing: Icon(Icons.navigate_next_outlined),
                              ),
                            ),
                          ),
                          InkWell(
                            child: Card(
                              child: ListTile(
                                leading: Icon(Icons.contact_mail),
                                title: Text("Contact Us"),
                                trailing: Icon(Icons.navigate_next_outlined),
                              ),
                            ),
                          ),
                          InkWell(
                            child: Card(
                              child: ListTile(
                                leading: Icon(Icons.settings),
                                title: Text("Settings"),
                                trailing: Icon(Icons.navigate_next_outlined),
                              ),
                            ),
                          ),
                          InkWell(
                            child: Card(
                              child: ListTile(
                                leading: Icon(Icons.share),
                                title: Text("Share"),
                                trailing: Icon(Icons.navigate_next_outlined),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            }
          },
        ),
      ),
    );
  }
}
