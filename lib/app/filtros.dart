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
    List _filtrosSeleccionadosCategoria= List();
    List _filtrosSeleccionadosLocalidad= List();
    final ScrollController _scrollController= ScrollController();
  Function(String) precioValidator = (String value){
   if(value.isEmpty){
     return "Ingrese su nombre";
   }
   return null;
 };
  
  Widget build(BuildContext context) {
    var listaFiltros=widget.list;
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.green,
        title: new Text("Filtrar"),
      ),
      body: 
      Column(
        children: <Widget>[ 
          Text('Categorias'),
          Expanded(
                        child:
                            new ListView.builder(
                                  itemCount: listaFiltros[0]['categorias'] == null ? 0 : listaFiltros[0]['categorias'].length,
                                  itemBuilder: (context, i) {
                                            return CheckboxListTile(
                                             
                                                  value: _filtrosSeleccionadosCategoria.contains(listaFiltros[0]['categorias'][i]['idCategoriaTrabajo']),
                                                   
                                                  onChanged: (bool selectedCat) {
                                                    
                                                    if (selectedCat == true) {
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
          ExpansionTile(
                          children: <Widget>[
                                  new ListView.builder(
                                    controller: _scrollController,
                                    shrinkWrap: true,
                                    itemCount: listaFiltros[0]['provincias'][0]['localidades'] == null ? 0 : listaFiltros[0]['provincias'][0]['localidades'].length,
                                    itemBuilder: (context, i) {
                                      //print(listaFiltros[0]['provincias'][0]['localidades']);
                                              return CheckboxListTile(
                                                    value: _filtrosSeleccionadosLocalidad.contains(listaFiltros[0]['provincias'][0]['localidades'][i]['idLocalidad']),
                                                    onChanged: (bool selected) {
                                                      if (selected == true) {
                                                        setState(() {
                                                          _filtrosSeleccionadosLocalidad.add(listaFiltros[0]['provincias'][0]['localidades'][i]['idLocalidad']);
                                                        });
                                                      } else {
                                                        setState(() {
                                                          _filtrosSeleccionadosLocalidad.remove(listaFiltros[0]['provincias'][0]['localidades'][i]['idLocalidad']);
                                                        });
                                                      }
                                                    },
                                                title: Text(listaFiltros[0]['provincias'][0]['localidades'][i]['nombreLocalidad']),
                                              );
                                    }
                                  ),
          ], title: Text('Neuquen'),),
       ExpansionTile(
                          children: <Widget>[
                                  new ListView.builder(
                                    controller: _scrollController,
                                    shrinkWrap: true,
                                    itemCount: listaFiltros[0]['provincias'][1]['localidades'] == null ? 0 : listaFiltros[0]['provincias'][1]['localidades'].length,
                                    itemBuilder: (context, i) {
                                      //print(listaFiltros[0]['provincias'][1]['localidades']);
                                              return CheckboxListTile(
                                                    value: _filtrosSeleccionadosLocalidad.contains(listaFiltros[0]['provincias'][1]['localidades'][i]['idLocalidad']),
                                                    onChanged: (bool selected) {
                                                      if (selected == true) {
                                                        setState(() {
                                                          _filtrosSeleccionadosLocalidad.add(listaFiltros[0]['provincias'][1]['localidades'][i]['idLocalidad']);
                                                        });
                                                      } else {
                                                        setState(() {
                                                          _filtrosSeleccionadosLocalidad.remove(listaFiltros[0]['provincias'][1]['localidades'][i]['idLocalidad']);
                                                        });
                                                      }
                                                    },
                                                title: Text(listaFiltros[0]['provincias'][1]['localidades'][i]['nombreLocalidad']),
                                              );
                                    }
                                  ),
          ], title: Text('Rio Negro'),),
       
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
                          )
                          );
}
           
}
