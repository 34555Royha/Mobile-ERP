import 'dart:convert';

import 'package:bank/api_helper/http_services.dart';
import 'package:bank/constance_routes/overtime_routes.dart';
import 'package:bank/provider/myovertime/new_request/search_submitto_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import 'new_overtime_page.dart';

class SubmitTo extends StatefulWidget {
  @override
  _SubmitToState createState() => _SubmitToState();
}

class _SubmitToState extends State<SubmitTo> with HttpService {
  List<SearchSubmitToModel> searchSubmitToModel = [];
  // Function getData
  Future getData(String search) async {
    http.Response response = await post(urlgetSubmitTo, search);
    if (response.statusCode == 200) {
      setState(() {
        searchSubmitToModel = (jsonDecode(response.body) as List)
            .map((e) => SearchSubmitToModel.fromMap(e))
            .toList();
      });
    } else {
      print('Error');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Container(
            padding: EdgeInsets.only(left: 15, right: 5),
            alignment: Alignment.centerLeft,
            height: 40,
            //  margin: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              onChanged: (String text) {
                if (text == '') {
                  searchSubmitToModel = [];
                } else {
                  getData(text);
                }
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: "Search EmployeeName Or ID...",
                border: InputBorder.none,
              ),
            )),
      ),
      body: _buildBody,
    );
  }

  get _buildBody {
    return FutureBuilder(
      future: getData(''),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Snapshot Error : ${snapshot.error}'),
          );
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            if (searchSubmitToModel.isEmpty) {
              return Container(
                color: Colors.grey[350],
                child: Center(
                  child: Text('Search Not Found'),
                ),
              );
            }
            return Container(
              color: Colors.grey[350],
              child: ListView.builder(
                itemCount: searchSubmitToModel.length == null
                    ? 0
                    : searchSubmitToModel.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setPrefs('assignID', searchSubmitToModel[index].code);
                      setPrefs('assignName', searchSubmitToModel[index].name);
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewOvertime(
                            searchSubmitToModel: searchSubmitToModel[index],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 7, right: 7),
                      child: Card(
                        child: ListTile(
                          title: Text(searchSubmitToModel[index].name),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Container(
              color: Colors.grey[350],
              child: Center(
                child: SpinKitCircle(
                  color: Colors.red[900],
                  size: 50,
                ),
              ),
            );
          }
        }
      },
    );
  }
}
