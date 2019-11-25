
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/pages/listaMensajes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {           
  final int idConversacion;
  final int deshabilitado;
  ChatScreen({this.idConversacion, this.deshabilitado});          
  @override                                                       
  State createState() => new ChatScreenState();                    
} 


class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin{   
  //final List<MensajesChat> _messages = <MensajesChat>[];  
  Future<List> listaMensajes;
  int idPersonaLogueada;
  final TextEditingController _textController = new TextEditingController(); 
  bool _isComposing = true;   
   
  void initState(){
    super.initState();
    verPersonaLog();
  }
  void verPersonaLog() async{
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      idPersonaLogueada = localStorage.getInt('idPersona');
        setState(() {
          idPersonaLogueada=idPersonaLogueada;
        });
      }

  Future actualizarVisto() async {
    var data = {
      'idPersonaLogueada':idPersonaLogueada,
      'idConversacion':widget.idConversacion,
    };
    await CallApi().postData(data,'actualizarvisto');
  }
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Conversacion")),
      body: new Container(                                             
        child: new Column(                                       
        children: <Widget>[                         
          new Flexible(                                             
            child: ListaMensajes(idConversacion: widget.idConversacion,idPersonaLogueada: idPersonaLogueada),                                          
          ),                                                        
          new Divider(height: 1.0),                                 
          new Container(                                            
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor
            ),                  
            child: _buildTextComposer(idPersonaLogueada),                       
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
    /*SharedPreferences localStorage = await SharedPreferences.getInstance();
    int idPersona=localStorage.getInt('idPersona');*/
    var data = {
      "idPersona":idPersonaLogueada,
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
            builder: (context) => ChatScreen(idConversacion: widget.idConversacion, deshabilitado: widget.deshabilitado,)));
      }
    }

  Widget _buildTextComposer(idPersonaLogueada) {
    return new IconTheme(                                            
      data: new IconThemeData(color: Theme.of(context).accentColor), 
      child: new Container(                                     
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: GestureDetector(
                onTap: () {
                  actualizarVisto();
                },
              child: (widget.deshabilitado == 0)? 
              new TextField(
                controller: _textController,
                onChanged: (String text) {          
                  setState(() {                     
                    _isComposing = text.length > 0; 
                  });                             
                },                        
                onSubmitted: _handleSubmitted,
                decoration: new InputDecoration.collapsed(
                  
                  hintText: "Escribe un mensaje..."),
              ) 
              :
              new TextField(
                controller: _textController,
                onChanged: (String text) {          
                  setState(() {                     
                    _isComposing = text.length > 0; 
                  });                             
                },                        
                onSubmitted: _handleSubmitted,
                decoration: new InputDecoration.collapsed(
                  
                  hintText: "No se pueden enviar más mensajes en esta conversación."),
              )
              ),
            ),
            (widget.deshabilitado == 0)? 
            new Container(
             
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send,semanticLabel: "Enviar mensaje",),
                  onPressed: () => _isComposing
                    ? _handleSubmitted(_textController.text)    
                    : null,           
              ),
            )
            :
            new Container()
            ],
          ),
      )
        );                                                         
  }
}