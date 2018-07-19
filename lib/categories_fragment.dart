import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/page_food.dart';
class CategoriesFragment extends StatelessWidget {
  String rId;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.5),
      child: getCategories("zYdpFG4VZRmhFmQjQDSI"),
    );

  }

  Widget getCategories(String rId) {
    return new StreamBuilder(
        stream: Firestore.instance.collection('restaurants').document(rId).collection('categories').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          return getList(snapshot);
        });
  }
  Widget getList(snapshot){

    return new ListView.builder(
        itemCount: snapshot.data.documents.length,

        itemBuilder: (context, index) {
          DocumentSnapshot ds = snapshot.data.documents[index];
          return _buildItem(ds['name'],ds['id'],context);
        }
    );
  }



  Widget getGrid(QuerySnapshot q, context){

    return new GridView.count(crossAxisCount: 2,
      children: new List.generate(q.documents.length, (index){
        DocumentSnapshot ds = q.documents[index];
        return _buildItem(ds['name'], ds['id'],context);
      }),
    );
  }
  Widget _buildItem(String name,String id,context){
    return ListTile(
      leading: Icon(Icons.category),
      title: Text(name),
      onTap: (){
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new FoodPage(id)));
      }
    );
  }


}