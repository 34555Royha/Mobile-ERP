import 'dart:convert';
import 'package:bank/api_helper/http_services.dart';
import 'package:bank/provider/home_page/menu_model.dart';
import 'package:bank/provider/home_page/search_screen.dart';
import 'package:bank/provider/leave/leave_page.dart';
import 'package:bank/provider/myovertime/myovertime_page.dart';
import 'package:bank/side_menu/nav_drawer_new.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HttpService {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _menu = new Menu();
  var _menus = new List<Menu>();
  String username;
  String email;

  //Local Method for Perfoming Data from API
  Future getData() async {
    http.Response response = await _menu.getMenu("");

    Iterable list = json.decode(response.body);

    setState(() {
      _menus = list.map((model) => Menu.fromJson(model)).toList();
    });
  }

  //Local Method
  void menuClick(String id) {
    if (id == "myleave") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Leave()));
    } else if (id == "myovertime") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyOverTime()));
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Unknown App'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      //Body
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tap again to exit'),
        ),

        //Set MenuList as GridView
        child: GridView.count(
          crossAxisCount: 2, //2 => 2D
          padding: EdgeInsets.all(16.0),
          childAspectRatio: 8.0 / 9.0,
          children: List.generate(
            _menus.length, //Cound menu list
            (index) => Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                splashColor: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 18.0 / 11.0,
                      // child: Image.asset('assets/diamond.png'),
                      child: Icon(Icons.time_to_leave_sharp),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //Set Text Menu
                          Text(_menus[index].funcDesc),
                          // SizedBox(height: 8.0),
                          Text('Secondary Text'),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () async {
                  menuClick(_menus[index].webModule);
                },
              ),
            ),
          ),
        ),
      ),

      //AppBar
      appBar: _buildAppBar,
      //Extence Drawer
      drawer: NavDrawerNew(),
    );
  }

  get _buildAppBar {
    return AppBar(
      title: Text("SBILH Bank"),
      backgroundColor: Colors.blue[900],
      actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.search,
              semanticLabel: 'Search',
              color: Colors.white,
            ),
            onPressed: () async {
              //Action
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage()));
            }),
        IconButton(
            icon: Icon(
              Icons.notifications,
              semanticLabel: 'Notification',
              color: Colors.white,
            ),
            onPressed: () async {
              //Point to Notification Page
            })

        // IconButton(icon: Icon(Icons.notifications, semanticLabel: 'search')),
      ],
    );
  }
}
