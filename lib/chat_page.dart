import 'dart:io';
import "dart:async";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/categories_fragment.dart';
import 'package:flutter_app/chat_messages_page.dart';
import 'package:flutter_app/home_fragment.dart';
import 'package:flutter_app/model/models.dart';
import 'package:flutter_app/page_add_food.dart';
import 'package:flutter_app/restaurants_fragment.dart';
import 'package:flutter_app/web_helper/WebHelper.dart';
import 'package:fluttertoast/fluttertoast.dart';
class ChatsPage extends StatefulWidget{
  String catId;
  var title = "Chats";
  @override
  State<StatefulWidget> createState() {
    return new _ChatsPageState();
  }

}
class _ChatsPageState extends State<ChatsPage>{

  List<Chat> mList;

  _ChatsPageState(){
    getChats();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new RefreshIndicator(child: getContent(), onRefresh: getChats)

    );
  }



  getContent(){
    if(mList == null)
      return getLoading();
    return ListView(
      children: _buildWidgetAdapter(mList),

    );
  }
  _buildWidgetAdapter(List<Chat> chats){
    return List.generate( chats.length, (index){
      return  _buildListElement(chats[index], index);
    }
    );
  }

  getLoading(){
    return new Center(
      child: CircularProgressIndicator(),
    );
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

  Future<Null> getChats() {
    return WebHelper.getRestaurantChats("r1")
    .then( (chats){
      print("sdfd" + chats.length.toString());
      setState(() {
        mList = chats;
      });
    }
    );
  }

  Widget _buildListElement(Chat chat, index){
    return new ListTile(
      leading: new CircleAvatar(
        child: new Text(chat.username[0]),
      ),
      title: new Text(chat.created.toString()),
      onTap: (){
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new ChatMessagesPage(chat.id)),
        );
      },
    );
  }


}