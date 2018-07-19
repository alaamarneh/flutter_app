import 'dart:io';
import "dart:async";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/web_helper/WebHelper.dart';
import 'package:flutter_app/model/models.dart';
class AddCatPage extends StatefulWidget{
  var title = "Add Cat";
  @override
  State<StatefulWidget> createState() {
    return new _AddCatPageState();
  }

}
class _AddCatPageState extends State<AddCatPage>{
  final myController = new TextEditingController();

  int status=0;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text(widget.title),
        ),
      body: _getStatusContent()
        

    );
  }

  _getStatusContent(){
    switch(status){
      case 0:
        return getContent();
      case 1:
        return getLoading();
    }
  }

  getLoading(){
    return new Center(
      child: CircularProgressIndicator(),
    );
  }
  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }

  getContent(){
      return new Column(
        children: <Widget>[
            new TextField(controller: myController,
            decoration: new InputDecoration(
                filled: true,
                labelText: 'Category name'
            ),
          ),
            SizedBox(height: 12.0),
          new RaisedButton(onPressed: (){
            setState(() {
              status=1;
            });
            uploadCategory();
          },
          child: Text("Add"),
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ))
        ],
      );
  }

  uploadCategory(){
    String rid = "zYdpFG4VZRmhFmQjQDSI";
    WebHelper.addCategory(Category(myController.text,myController.text+"id"), rid)
    .then((result){
      if(result)
        showSuccess();
      else
        showError();
    });
  }

  showSuccess(){
    showDialog<Null>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text('Success'),
        content: new SingleChildScrollView(
          child: new Text("Created sucessfully")
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
  });
  }
  showError(){
    showDialog<Null>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('Error'),
            content: new SingleChildScrollView(
                child: new Text("error")
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

}