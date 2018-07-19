import 'dart:io';
import "dart:async";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/web_helper/WebHelper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_app/model/models.dart';
class AddFoodPage extends StatefulWidget{
  var title = "Add Food";
  var category_id;

  Food mFood;
  AddFoodPage(this.category_id,[this.mFood]);


  @override
  State<StatefulWidget> createState() {
    return new _AddFoodPageState(mFood==null?null:mFood.subFoods);
  }

}
class _AddFoodPageState extends State<AddFoodPage>{
  final txtNameController = new TextEditingController();
  final txtPriceController = new TextEditingController();
  final txtDescriptionController = new TextEditingController();
  final txtFoodNameDialog = new TextEditingController();
  final txtFoodPriceDialog = new TextEditingController();

  int status=0;
  List<Food> mSubFoods ;

  _AddFoodPageState(this.mSubFoods);

  @override
  Widget build(BuildContext context) {;
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
      body: _getStatusContent()
        

    );
  }


  @override
  void initState() {
    txtNameController.text = widget.mFood==null? null : widget.mFood.name;
    txtPriceController.text = widget.mFood==null? null : widget.mFood.price.toString();
    txtDescriptionController.text = widget.mFood==null? null : widget.mFood.description;
    print("init");
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
    txtNameController.dispose();
    txtPriceController.dispose();
    txtDescriptionController.dispose();
    txtFoodNameDialog.dispose();
    txtFoodPriceDialog.dispose();
    super.dispose();
  }
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  getContent(){
    return new ListView(
      children: <Widget>[
        new TextField(controller: txtNameController,
          decoration: new InputDecoration(
              border: InputBorder.none,
              hintText:'Please enter a food name'
          ),
        ),
        new TextField(controller: txtPriceController,
          decoration: new InputDecoration(
              border: InputBorder.none,
              hintText:'Please enter a food price'
          ),
        ),
        new TextField(controller: txtDescriptionController,
          decoration: new InputDecoration(
              border: InputBorder.none,
              labelText: "description",
              hintText:'Please enter a food description'
          ),
        ),
        new Row(
          children: <Widget>[
            new RaisedButton(onPressed: (){
              showDialogCat();
            },child: Text("Add cat"),)
          ],
        ),
        new RaisedButton(onPressed: (){
          getImage();
        },

          child: Text("upload photo"),),
        new Container(
            height: 150.0,
            child: _image == null
                ? widget.mFood==null? new Text('No image selected.') : new Image.network(widget.mFood.img)
                : new Image.file(_image)
        ),
        mSubFoods == null? Text("cats"):
        new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children:
             new List.generate(mSubFoods.length, (index){
               return new ListTile(
                 leading: const Icon(Icons.fastfood),
                 title: new Text("${mSubFoods[index].name} ${mSubFoods[index].price} NIS"),
                 trailing: new RaisedButton(onPressed: (){
                    setState(() {
                      mSubFoods.removeAt(index);
                    });
                 },child: new Text("X"),),
               );
             })
          ,
        ),
        new RaisedButton(
            child: new Text("Add"),
            onPressed: (){
              setState(() {
                status=1;
              });
              upload();
            })
      ],
    );

  }


  upload(){

    if(widget.mFood == null){ // add
      if(_image == null){
        print("choose image");
      }else{
        WebHelper.uploadImage(_image).then((url) {
          Food food = Food(
              "fakeid", txtNameController.text, txtDescriptionController.text,
              url, txtPriceController.text, widget.category_id);
          food.subFoods = mSubFoods;
          WebHelper.addFood(food).then((b) {
            print("result is " + b.toString());
            showSuccess();
          });
        }
        );
      }
    }else{ // edit
      var food = widget.mFood;
      food.subFoods = mSubFoods;
      if(_image == null){
        var food2 =Food(food.id,txtNameController.text, txtDescriptionController.text, food.img, txtPriceController.text, widget.category_id);
        food2.subFoods= mSubFoods;
          WebHelper.updateFood(food2).then((b) {
            showSuccess();
          });
        }else{
          WebHelper.uploadImage(_image).then((url) {

            var food2 =Food(food.id, txtNameController.text, txtDescriptionController.text, url, txtPriceController.text, widget.category_id);
            food2.subFoods= mSubFoods;

            WebHelper.updateFood(food2).then((b) {
              print("result is " + b.toString());
              showSuccess();
            });
          }
          );
      }
    }



    }


    showDialogCat(){
      showDialog<Food>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return new AlertDialog(
              title: new Text('new cat'),
              content: new Column( children: <Widget>[
                new Text("Enter food details"),
                new TextField(controller: txtFoodNameDialog,
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      labelText: "Name",
                      hintText:'Please enter a food name'
                  )
                ),
              new TextField(controller: txtFoodPriceDialog,
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  labelText: "Name",
                  hintText:'Please enter a food price'
              ))
              ],
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(new Food(new DateTime.now().millisecondsSinceEpoch.toString(),txtFoodNameDialog.text,"","",txtFoodPriceDialog.text,widget.category_id));
                  },
                ),
              ],
            );
          }).then((food){
              setState(() {
                print("food name "+food.name);
                if( mSubFoods == null) mSubFoods = List();
                 mSubFoods.add(food);
              });
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


}