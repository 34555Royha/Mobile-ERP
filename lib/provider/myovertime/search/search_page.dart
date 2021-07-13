import 'dart:convert';
import 'package:bank/api_helper/http_services.dart';
import 'package:bank/provider/myovertime/new_request/new_overtime_page.dart';
import 'package:bank/provider/myovertime/search/search_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class OvertimeSearch extends StatefulWidget {
  @override
  _OvertimeSearchState createState() => _OvertimeSearchState();
}

class _OvertimeSearchState extends State<OvertimeSearch> with HttpService {
  final _searchlist = new SearchmodelS();
  var _searchlists = new List<SearchmodelS>();
  List<SearchmodelS> searchlistbytext = [];
  Future getData() async {
    http.Response response = await _searchlist.getSearchlist();
    Iterable list = json.decode(response.body);
    _searchlists = list.map((model) => SearchmodelS.fromMap(model)).toList();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      appBar: AppBar(
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
                setState(() {
                  searchlistbytext = _searchlists
                      .where((element) => element.name
                          .toLowerCase()
                          .contains(text.toLowerCase()))
                      .toList();
                });
              },
              decoration: InputDecoration(
                hintText: "Search...",
                border: InputBorder.none,
              ),
            )),
      ),
      body: _buildBody,
    );
  }

  get _buildBody {
    return ListView.builder(
      itemCount: searchlistbytext.length == null ? 0 : searchlistbytext.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewOvertime()));
          },
          child: Container(
            padding: EdgeInsets.only(left: 7, right: 7),
            child: Card(
              child: ListTile(
                title: Text(searchlistbytext[index].name),
              ),
            ),
          ),
        );
      },
    );
  }
}
