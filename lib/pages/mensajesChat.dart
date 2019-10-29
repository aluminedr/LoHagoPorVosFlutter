import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MensajesChat extends StatefulWidget{
  final String text;
  MensajesChat({this.text});
  @override
  State<StatefulWidget> createState()=> _MensajesChatState();
  
}

class _MensajesChatState extends State<MensajesChat> {
  String nombreUsuario;
  void initState() {
    _getUserInfo();
    super.initState();
  }

  void _getUserInfo() async {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var userJson = localStorage.getString('user');
      var user = json.decode(userJson);
      //print(user);
      setState(() {
        nombreUsuario= user['nombreUsuario'];
      });  
  }
  @override
  Widget build(BuildContext context) {
    String text= widget.text;
        return new Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: new CircleAvatar(
                  child: new Image.network("http://res.cloudinary.com/kennyy/image/upload/v1531317427/avatar_z1rc6f.png"),
                  ),
              ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text('$nombreUsuario', style: Theme.of(context).textTheme.subhead),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(text),
              )
            ],
          )
        ],
      )
    );
  }
}