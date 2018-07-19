import 'package:flutter/material.dart';
import 'package:flutter_app/categories_fragment.dart';
import 'package:flutter_app/chat_page.dart';
import 'package:flutter_app/home_fragment.dart';
import 'package:flutter_app/page_add_cat.dart';
import 'package:flutter_app/restaurants_fragment.dart';

class HomePage extends StatefulWidget{
  var title = "Online Restaurant";
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }

}
class _HomePageState extends State<HomePage>{
  int index = 1;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
            bottom: new PreferredSize(
                child: new Container(
                  child: Divider(height: 2.0,),
                ),
                preferredSize: const Size.fromHeight(2.0)),

            actions: <Widget>[
        // action button
            new IconButton(
            icon: new Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new ChatsPage()),
              );
              },color: Colors.redAccent,),
            ],

          title: new Text(widget.title),
        ),
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: _getFragment(index)
          ),
          getBottomNavigation()
        ],
      ) ,

    );
  }


  _getFragment(int pos){
      switch(pos){
        case 0:
          return new HomeFragment();
        case 1:
          return new RestaurantsFragment();
      }
  }

  Widget getBottomNavigation(){
    return new BottomNavigationBar(
      currentIndex: index,fixedColor: Colors.redAccent,
      onTap: (int index) { setState((){ this.index = index; }); },
      items: <BottomNavigationBarItem>[
        new BottomNavigationBarItem(
          icon: new Icon(Icons.home),
          title: new Text("All")
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.category),
          title: new Text("Categories"),
        ),
      ],
    );
  }

}