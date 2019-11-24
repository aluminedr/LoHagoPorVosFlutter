
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/pages/listaMensajes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {           
  final int idConversacion;
  ChatScreen({this.idConversacion});          
  @override                                                       
  State createState() => new ChatScreenState();                    
} 


class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin{   
  //final List<MensajesChat> _messages = <MensajesChat>[];  
  Future<List> listaMensajes;
  int idPersonaLogueada;
  final TextEditingController _textController = new TextEditingController(); 
  bool _isComposing = true;   


  Widget build(BuildContext context) {
    //print(listaMensajes);
    return new Scaffold(
      appBar: new AppBar(title: new Text("Conversacion")),
      body: new Container(                                             
        child: new Column(                                       
        children: <Widget>[                         
          new Flexible(                                             
            child: ListaMensajes(idConversacion: widget.idConversacion),                                          
          ),                                                        
          new Divider(height: 1.0),                                 
          new Container(                                            
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor
            ),                  
            child: _buildTextComposer(),                       
          ),                                                        
        ],                                                          
      ),   
      ),                                                         
    );
}

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {                                                    
    _isComposing = false;                                          
    });        
    guardarMensaje(text);                                                                                                  
  }
void guardarMensaje(text) async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    int idPersona=localStorage.getInt('idPersona');
    var data = {
      "idPersona":idPersona,
      "idConversacionChat":widget.idConversacion,
      "mensaje":text,
      'flutter':true,
    };  
    var res = await CallApi().postData(data, 'guardarMensaje');
    var body = json.decode(res.body);
    print(res.body);
      if (body['success']){
        Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => ChatScreen(idConversacion: widget.idConversacion)));
      }
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
                onChanged: (String text) {          
                  setState(() {                     
                    _isComposing = text.length > 0; 
                  });                             
                },                        
                onSubmitted: _handleSubmitted,
                decoration: new InputDecoration.collapsed(
                  
                  hintText: "Escribe un mensaje..."),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send,semanticLabel: "Enviar mensaje",),
                  onPressed: () => _isComposing
                    ? _handleSubmitted(_textController.text)    
                    : null,           
              ),
            ),
            ],
          ),
      )
        );                                                         
  }
}