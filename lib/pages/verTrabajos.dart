import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ListarTrabajosPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ListarTrabajosPageState();
  
  
  }
  
  class _ListarTrabajosPageState extends State<ListarTrabajosPage>{
  //funcion que trae el listado de trabajos en formato json para luego decodificarlo
  Future<List> getListaTrabajos() async {
    final response = await http.get("http://192.168.0.5/LoHagoPorVosFlutter/lib/conexion/Trabajo/ListarTrabajos.php");
    
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      
      /*floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new AddData(),
            )),
      ),*/
      body: new FutureBuilder<List>(
        future: getListaTrabajos(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new ItemList(
                  list: snapshot.data,
                )
              : new Center(
                  child: new CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          padding: const EdgeInsets.all(10.0),
          /*child: new GestureDetector(
            onTap: () => Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new Detail(
                            list: list,
                            index: i,
                          )),
                ),
            */
            child: new Card(
              child: new ListTile(
                title: new Text(
                  list[i]['titulo'],
                  style: TextStyle(fontSize: 20.0, color: Colors.purple),
                ),
                /*
                leading: new Icon(
                  Icons.person_pin,
                  size: 77.0,
                  color: Colors.orangeAccent,
                ),
                */
                subtitle: 
                new Text(
                  list[i]['descripcion'],
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                ),
              ),
            /*),*/
          ),
        );
      },
    );
  }
}