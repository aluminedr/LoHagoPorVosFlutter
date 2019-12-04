import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/ovalRightClipper.dart';

class ModalFiltros extends StatefulWidget {
  final List list;
  ModalFiltros({this.list});
  _ModalFiltrosState createState() => _ModalFiltrosState();
}


  class _ModalFiltrosState extends State<ModalFiltros>{
    TextEditingController precioMinController = new TextEditingController();
    TextEditingController precioMaxController = new TextEditingController();
  Function(String) precioValidator = (String value){
   if(value.isEmpty){
     return "Ingrese su nombre";
   }
   return null;
 };
  
  Widget build(BuildContext context) {
    var listaFiltros=widget.list;
    List _filtrosSeleccionadosCategoria= List();
    List _filtrosSeleccionadosLocalidad= List();
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.green,
        title: new Text("Filtrar"),
      ),
      body: Column(
        children: <Widget>[ 
          Text('Categorias'),
          Expanded(
                        child:    new ListView.builder(
                                  itemCount: listaFiltros[0]['categorias'] == null ? 0 : listaFiltros[0]['categorias'].length,
                                  itemBuilder: (context, i) {
                                            return CheckboxListTile(
                                                  value: _filtrosSeleccionadosCategoria.contains(listaFiltros[0]['categorias'][i]['idCategoriaTrabajo']),
                                                  onChanged: (bool selected) {
                                                    if (selected == true) {
                                                      setState(() {
                                                        _filtrosSeleccionadosCategoria.add(listaFiltros[0]['categorias'][i]['idCategoriaTrabajo']);
                                                      });
                                                    } else {
                                                      setState(() {
                                                        _filtrosSeleccionadosCategoria.remove(listaFiltros[0]['categorias'][i]['idCategoriaTrabajo']);
                                                      });
                                                    }
                                                  },
                                              title: Text(listaFiltros[0]['categorias'][i]['nombreCategoriaTrabajo']),
                                            );
                                  }
                                ),
          ),
          Text('Ubicación'),
          Expanded(
                        child:    new ListView.builder(
                                  itemCount: listaFiltros[0]['provincias'] == null ? 0 : listaFiltros[0]['provincias'].length,
                                  itemBuilder: (context, i) {
                                            return CheckboxListTile(
                                                  value: _filtrosSeleccionadosLocalidad.contains(listaFiltros[0]['provincias'][i]['idProvincia']),
                                                  onChanged: (bool selected) {
                                                    if (selected == true) {
                                                      setState(() {
                                                        _filtrosSeleccionadosLocalidad.add(listaFiltros[0]['provincias'][i]['idProvincia']);
                                                      });
                                                    } else {
                                                      setState(() {
                                                        _filtrosSeleccionadosLocalidad.remove(listaFiltros[0]['provincias'][i]['idProvincia']);
                                                      });
                                                    }
                                                  },
                                              title: Text(listaFiltros[0]['provincias'][i]['nombreProvincia']),
                                            );
                                  }
                                ),
          ),
          Expanded(
            child:  ListView(
              children:
              <Widget>[
                new TextFormField(
                            controller: precioMinController,
                            validator:precioValidator,
                            
                          ),
                    
              new TextFormField(
                            controller: precioMaxController,
                            validator:precioValidator,
              ),
                ],),
          )],
                          ));
}
           
}
