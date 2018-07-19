import 'dart:io';
import "dart:async";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class WebHelper{
  static Future<String> uploadImage(_image) async{
    var now = new DateTime.now().millisecondsSinceEpoch;
    StorageUploadTask uploadTask = FirebaseStorage.instance.ref().child("images")
        .child(now.toString() + "image")
        .putFile(_image);
    Uri downloadUrl = (await uploadTask.future).downloadUrl;
    return downloadUrl.toString();
  }
  static Future<bool> addFood(Food food) async{
    await Firestore.instance.collection("food")
        .add({
      "name" : food.name,
      "description" : food.description,
      "price" : double.parse(food.price),
      "img" : food.img,
      "category_id" : food.categoryId,
      "cats" : food.subFoods.map((f){
         return {
           "name":f.name,
           "price":double.parse(f.price),
           "id" : f.id
         };
      }).toList()
    }).then((ds){
      return true;
    }
    );
    return true;
  }
  static Future<bool> updateFood(Food food) async{
    await Firestore.instance.collection("food").document(food.id)
        .updateData({
      "name" : food.name,
      "description" : food.description,
      "price" : food.price,
      "img" : food.img,
      "category_id" : food.categoryId,
      "cats" : food.subFoods.map((f){
        return {
          "name":f.name,
          "price":double.parse(f.price),
          "id" : f.id
        };
      }).toList()
    }).then((ds){
      return true;
    }
    );
    return true;
  }
  static Future<bool> addCategory(Category category, String restaurantId) async{
    await Firestore.instance.collection("restaurants").document(restaurantId).collection("categories")
        .add({
      "name" : category.name,
      "id" : category.id
    });
    return true;
  }

  static Future<List<Chat>> getRestaurantChats(String rId) async{
          return await Firestore.instance.collection("chat")
              .where("restaurant_id", isEqualTo: rId)
              .getDocuments().then(
              (qs){
                return qs.documents.map( (ds){
                  print("ds " + ds.documentID);
                  return new Chat(ds['restaurant_id'],ds['uid'],ds.documentID,ds['restaurant_name'],ds['username'],ds['created']);
                }).toList();
              }

          );
  }
}