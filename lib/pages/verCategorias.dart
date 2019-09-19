import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class VerCategoriasPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _VerCategoriasPageState();
  
  
  }

  class _VerCategoriasPageState extends State<VerCategoriasPage>{
  //funcion que trae el listado de categorias en formato json para luego decodificarlo
  Future<List> getCategorias() async {
    final response = await http.get("http://192.168.1.36/LoHagoPorVosFlutter/lib/conexion/ListarCategorias.php");
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Categorias"),
      ),
      /*floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new AddData(),
            )),
      ),*/
      body: new FutureBuilder<List>(
        future: getCategorias(),
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
    //creacion de una lista de items
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          padding: const EdgeInsets.all(10.0),
            child: new Card(
              child: new ListTile(
                title: new Text(
                  list[i]['nombreCategoriaTrabajo'],
                  textAlign:TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0, 
                    color: Colors.purpleAccent[400],
                  ),
                ),onTap: (){
                    void elQueSeTeCanteElForroDelOrto($idCategoriaTrabajo){
                      
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                    
                  elQueSeTeCanteElForroDelOrto(list[i]['idCategoriaTrabajo']);
                  
                },
              ),
            ),
        );
      },
    );
  }
  
}


