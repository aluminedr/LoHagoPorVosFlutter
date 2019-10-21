import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/pages/crearPerfil.dart';

class ListaCategoriasPage extends StatefulWidget{
  final List listaHabilidades;
  ListaCategoriasPage({Key key,this.listaHabilidades}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ListaCategoriasPageState();
  
  
  }
  
  class _ListaCategoriasPageState extends State<ListaCategoriasPage> {


  //funcion que trae el listado de trabajos en formato json para luego decodificarlo
  Future<List> getListaCategorias() async {
    
    var res = await CallApi().getData('listarCategorias');
    var listaCategorias = json.decode(res.body);
    return listaCategorias;

  }
  

  @override
  Widget build(BuildContext context) {
    List listaHabilidades=widget.listaHabilidades;
    var listaCategorias =getListaCategorias();
    return new Scaffold(
      
      /*floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new AddData(),
            )),
      ),*/
      body: new FutureBuilder<List>(
        future: listaCategorias,
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return new CrearPerfilPage(
                  list: snapshot.data,
                  listaHabilidades:listaHabilidades,
                );
        }),     
    );
  }
}