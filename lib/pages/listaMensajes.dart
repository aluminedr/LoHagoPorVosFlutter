import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';


class ListaMensajes extends StatefulWidget{
final int idConversacion;
  ListaMensajes({this.idConversacion});  

  @override
  _ListaMensajesState createState() => _ListaMensajesState();
}

class _ListaMensajesState extends State<ListaMensajes> with SingleTickerProviderStateMixin{
  Future<List> listaMensajes;
  Timer timer;
  @override
  void initState() {
    super.initState();
    new Timer.periodic(Duration(seconds: 15), (Timer t) => setState((){
      callApi();
    }));
  }

  void callApi() {
    setState(() {
      listaMensajes = buscarMensajesConversacion();
    });
  }

  Future<List> buscarMensajesConversacion() async{
    var data={
      'idConversacionChat': widget.idConversacion,
    };
    var res = await CallApi().postData(data,'listarMensajesConversacion');
    var listaMensajes = json.decode(res.body);
    //print(DateTime.now().toIso8601String());
    return listaMensajes;
  }

  Widget build(BuildContext context) {
    //var listaMensajes =listaMensajes;
    return new Scaffold(
      body: new FutureBuilder<List>(
        future: listaMensajes,
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new ItemList(
                  list: snapshot.data,
                )
              : new Center(
                  child:Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                  child: CircularProgressIndicator()
                  ),        
                );
        },
      ),
    );
  }
}

class ItemList extends StatefulWidget {
  final List list;
  ItemList({this.list});
  @override
  State<StatefulWidget> createState() => _ItemListState();
  
  
  }
  
  class _ItemListState extends State<ItemList>{

  void initState(){
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    List list=widget.list;
    //print(list);
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        String nombreUsuario= list[i]['usuario'][0]['nombreUsuario'];
        String text= list[i]['mensaje'];
        return new Container(
          padding: const EdgeInsets.all(10.0),            
            child: new Container(
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
              new Expanded(                                             
                child: new Column(  
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text('$nombreUsuario', style: Theme.of(context).textTheme.subhead),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(text),
                  ),
            ],
          ),
              ),
        ],
            
      ),
        
      ),
        );
      },
    );
    
  }
}
