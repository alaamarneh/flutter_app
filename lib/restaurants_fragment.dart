import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import "dart:async";
class RestaurantsFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        getTopList(),
        getDivider(),
        getBottomList()
      ],
    );
  }

  Widget getTopList() {
    Widget text = new Text("Restaurants");
    return text;
  }
  Widget getDivider(){
    Widget text = new Text('Deliver features faster');
    return text;
  }
  Widget getBottomList(){
    Widget text = new Text("asa");
    fetchPost();
    return text;
  }
  Future<http.Response> fetchPost() async {
    final response =
        await http.get('http://localhost:8888/restaurants/restaurants/read.php');
    print(json.decode(response.body));
    return null;
  }

}