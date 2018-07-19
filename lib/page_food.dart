import 'dart:io';
import "dart:async";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/categories_fragment.dart';
import 'package:flutter_app/home_fragment.dart';
import 'package:flutter_app/model/models.dart';
import 'package:flutter_app/page_add_food.dart';
import 'package:flutter_app/restaurants_fragment.dart';
import 'package:fluttertoast/fluttertoast.dart';
class FoodPage extends StatefulWidget{
  String catId;

  FoodPage(this.catId);

  var title = "Foods";
  @override
  State<StatefulWidget> createState() {
    return new _FoodPageState();
  }

}
class _FoodPageState extends State<FoodPage>{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.delete), onPressed: (){
              showSuccess();
            })
          ],
        ),
      body: getContent(),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
          onPressed: (){
            Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => new AddFoodPage(widget.catId)),
            );
      }),
    );
  }



  getContent(){
      return getFoods(widget.catId);
  }
  Widget getFoods(String catId) {
    return new StreamBuilder(
        stream: Firestore.instance.collection('food').where("category_id",isEqualTo: catId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return getLoading();
          return getGrid(snapshot.data);
        });
  }


  Widget getGrid(QuerySnapshot q){

    return new GridView.count(crossAxisCount: 2,
      children: new List.generate(q.documents.length, (index){
        DocumentSnapshot ds = q.documents[index];
        return _buildItem(index,Food.fromFirebase(ds.documentID,ds['name'], ds['description'], ds['img'],ds['price'].toString(),widget.catId,ds['cats']));
      }),
    );
  }
  Widget _buildItem(int index,Food food){
    return new GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new AddFoodPage(widget.catId,food)),
        );
      },
      child: new Card(
        child: new Container(
          child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Expanded(child: new Image.network(
                  food.img,fit: BoxFit.fitWidth,
                ),

                ),
                Text(food.name),
                Text(food.price + " NIS")
              ]
          ),

        ),
      ),
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


}