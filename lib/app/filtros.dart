import 'dart:convert';
import 'dart:ui' as prefix0;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/app/ovalRightClipper.dart';
import 'package:flutter_app/pages/verTrabajosFiltrados.dart';
import 'package:image/image.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
   if(value.isNotEmpty){
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
          Text('Categorias',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),),
          Expanded(
                        child:
                            new ListView.builder(
                              physics: ScrollPhysics(),
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
          Text('Ubicación',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),),
          Expanded(child:
          SingleChildScrollView(child:ExpansionTile(
                          children: <Widget>[
                                  new ListView.builder(
                                    controller: _scrollController,
                                    shrinkWrap: true,
                                    //physics: AlwaysScrollableScrollPhysics() ,
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
          ], title: Text('Neuquen'),),),),
          
       Expanded(child:
          SingleChildScrollView(child:ExpansionTile(
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
          ], title: Text('Rio Negro'),),)),
        Text('Rango monetario',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),),
          Expanded(
            child:  ListView(
              children:
              <Widget>[
                new TextFormField(
                            controller: precioMinController,
                            validator:precioValidator,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ], // Only numbers can be entered
                              decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              prefixIcon:Icon(Icons.attach_money),
                              labelText:"Min", 
                                hintText: "0",
                                
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none
                              ),
                              filled: true,
                              fillColor: Colors.green.withOpacity(0.1),
                            ),
                          ),
                    SizedBox(height: 10,),
              new TextFormField(
                            controller: precioMaxController,
                            validator:precioValidator,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ], // Only numbers can be entered
                              decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              prefixIcon:Icon(Icons.attach_money),
                              labelText:"Max", 
                                hintText: "1000",
                                
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none
                              ),
                              filled: true,
                              fillColor: Colors.green.withOpacity(0.1),
                            ),
                          ),
                ],),
          ),
          Expanded(
            child: Center(
                         child: SizedBox(
                        child: new RaisedButton(
                          child: new Text("Filtrar"),
                          textColor: Colors.green,
                          padding: const EdgeInsets.all(10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)
                          ),
                              onPressed: () {
                                filtrar();
                              },
                          ),
                         ),
            ),
                      ),],
                          )
                          );
}

void filtrar() async{
  var data = {
    'categoria': _filtrosSeleccionadosCategoria,
    'localidad': _filtrosSeleccionadosLocalidad,
    //'rangoMontoInferior': precioMinController.text,
    //'rangoMontoSuperior': precioMaxController.text,
  };
  var res = await CallApi().postData(data, 'filtrar');
  var body = json.decode(res.body);
  //print(body);
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => ListarTrabajosFiltradosPage(listaFiltrados: body)));

}
           
}
