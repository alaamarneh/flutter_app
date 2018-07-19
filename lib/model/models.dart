import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Food{
  String name,description,img,categoryId,id;
  String price;
  List<Food> subFoods;
  Food(this.id, this.name, this.description, this.img, this.price, this.categoryId){

  }
  static fromFirebase(id, name, description, img, price, categoryId, List<dynamic> dc){
    Food food = new Food(id, name, description, img, price, categoryId);
    if(dc != null) {
      print("ok");
      food.subFoods = dc.map((ds) {
        return Food(
            ds['id'], ds['name'], "", null, ds['price'].toString(), categoryId);
      }).toList();
    }

    return food;
  }
}

class Category{
  String name,id;
  Category(this.name, this.id);
}

class Chat{
  String restaurantId,uId,id,restaurant_name,username;
  DateTime created;

  Chat(this.restaurantId, this.uId, this.id, this.restaurant_name,
      this.username, this.created);


}
class ChatMessage{
  String sender,id,text;
  DateTime created;

  ChatMessage(this.sender, this.id, this.text, this.created);

}