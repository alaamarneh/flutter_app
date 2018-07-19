import 'dart:async';

import 'package:flutter/material.dart';
abstract class BaseState<T extends StatefulWidget> extends State<T>{


  getLoading(){
    return new Center(
      child: CircularProgressIndicator(),
    );
  }

}