import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/pages/crearPerfil.dart';

class ListaFiltros extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ListaFiltrosState();
  
  
  }
  
  class _ListaFiltrosState extends State<ListaFiltros> {


  //funcion que trae el listado de trabajos en formato json para luego decodificarlo
  Future<List> getListaFiltros() async {
    
    var res = await CallApi().getData('listarFiltros');
    var listaFiltros = json.decode(res.body);
    //print(listaFiltros);
    return listaFiltros;
  }
  

  @override
  Widget build(BuildContext context) {
    var listaFiltros =getListaFiltros();
    return new Scaffold(
      
      /*floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new AddData(),
            )),
      ),*/
      body: new FutureBuilder<List>(
        future: listaFiltros,
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return new HomePage(
                  list: snapshot.data,
                );
        }),     
    );
  }
}