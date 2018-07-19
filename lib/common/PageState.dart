import 'dart:async';

import 'package:flutter/material.dart';
abstract class LoadingPageState<T extends StatefulWidget> extends State<T>{
  var title;
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(title),
        ),
        body: new RefreshIndicator(child: getContent(), onRefresh: onRefresh)

    );
  }
  getBody(){
    if(loading)
      return getLoading();


  }
  getContent();
  Future<Null> onRefresh();

  getLoading(){
    return new Center(
      child: CircularProgressIndicator(),
    );
  }

}