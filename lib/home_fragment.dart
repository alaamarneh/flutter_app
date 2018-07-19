import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/model/models.dart';
class HomeFragment extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return getStream();
  }

  Widget getTopList() {
    Widget text = new Text("aa");
    return text;
  }
  Widget getDivider(){
    Widget text = new Text('Deliver features faster');
    return text;
  }
//  Widget getBottomList(){
//    return new ListView.builder(
//      padding: new EdgeInsets.all(8.0),
//
//      itemCount: list.length,
//      itemBuilder: (BuildContext context, int index) {
//        return _buildItem(index);
//      },
//    );
//  }
  Widget getGrid(QuerySnapshot q){

    return new GridView.count(crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
      childAspectRatio: 8.0 / 9.0,
      children: new List.generate(q.documents.length, (index){
        DocumentSnapshot ds = q.documents[index];
        return _buildItem(index,Food.fromFirebase(ds.documentID, ds['name'], ds['description'], ds['img'], ds['price'].toString(), ds['category_id'], ds['cats']) );
      }),
    );
  }
  Widget _buildItem(int index, Food food){
    return new Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 18.0 / 11.0,
            child: Image.network(food.img,fit: BoxFit.fitWidth,),
          ),
          new Padding(
            padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(food.name),
                SizedBox(height: 8.0),
                Text(food.price + " NIS"),
              ],
            ),
          ),
        ],
      ),
    );

  }



  Widget getStream(){
    return new StreamBuilder(
        stream: Firestore.instance.collection('food').snapshots(),
    builder: (context, snapshot) {
    if (!snapshot.hasData) return const Text('Loading...');
    return getGrid(snapshot.data);
    });
  }
}