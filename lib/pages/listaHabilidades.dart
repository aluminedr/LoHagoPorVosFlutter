import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/pages/listaCategorias.dart';

class ListaHabilidadesPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ListaHabilidadesPageState();
  
  
  }
  
  class _ListaHabilidadesPageState extends State<ListaHabilidadesPage> {


  //funcion que trae el listado de trabajos en formato json para luego decodificarlo
  Future<List> getListaHabilidades() async {
    
    var res = await CallApi().getData('listarHabilidades');
    var listaHabilidades = json.decode(res.body);
    return listaHabilidades;

  }
  

  @override
  Widget build(BuildContext context) {
    var listaHabilidades =getListaHabilidades();
    return new Scaffold(
      
      /*floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new AddData(),
            )),
      ),*/
      body: new FutureBuilder<List>(
        future: listaHabilidades,
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return new ListaCategoriasPage(
                  listaHabilidades: snapshot.data,
                );
        }),     
    );
  }
}