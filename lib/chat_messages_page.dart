import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/base/BaseState.dart';
import 'package:flutter_app/model/models.dart';

class ChatMessagesPage extends StatefulWidget{
  final String chatId;
  @override
  State<StatefulWidget> createState() {
    return new _ChatMessagesPageState(chatId);
  }

  ChatMessagesPage(this.chatId);

}
class _ChatMessagesPageState extends BaseState<ChatMessagesPage>{
  var chatId;
  final TextEditingController _textController = new TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  bool _isComposing = false;

  _ChatMessagesPageState(this.chatId);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Messages"),
      ),
      body: _getBody(),
    );
  }
  _getBody(){
    return new Container(                                             //modified
        child: new Column(                                           //modified
          children: <Widget>[
            new Flexible(
              child: _getStream()
            ),
            new Divider(height: 1.0),
            new Container(
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS //new
            ? new BoxDecoration(                                     //new
          border: new Border(                                  //new
            top: new BorderSide(color: Colors.grey[200]),      //new
          ),                                                   //new
        )                                                      //new
            : null);
  }

  _getStream(){
    return new StreamBuilder(
        stream: Firestore.instance.collection('chat').document(chatId).collection("messages").orderBy("created",descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return getLoading();
          return _buildData(context,snapshot.data);
        });
  }
  _buildData(context,QuerySnapshot qs){
    return new ListView(
        padding: new EdgeInsets.all(8.0),
        reverse: true,
        children:
           qs.documents.map( (ds){
            return new ChatMessageWidget(text: ds['text'],name: ds['sender']);
          }).toList()
    );
  }


  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {          //new
                  setState(() {                     //new
                    _isComposing = text.length > 0; //new
                  });                               //new
                },                                  //new
                onSubmitted: _handleSubmitted,
                decoration:
                new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: _isComposing
                    ? () => _handleSubmitted(_textController.text)    //modified
                    : null,                                           //modified
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    Firestore.instance.collection("chat").document(chatId).collection("messages")
      .add(
      {
        "text":text,
        "sender":"Mohammed",
        "created": new DateTime.now()
      }
    );
  }

}

class ChatMessageWidget extends StatelessWidget {
  ChatMessageWidget({this.text,this.name});
  final String text;
  final String name;
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new CircleAvatar(child: new Text(name[0])),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(name, style: Theme.of(context).textTheme.subhead),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}