
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/pages/listaFiltros.dart';
import 'package:flutter_app/pages/verTrabajos.dart';
import 'package:flutter_app/trabajosBusqueda.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/drawer.dart';



class HomePage extends StatefulWidget {
  final List list;
  HomePage({this.list});
  @override
  _HomePageState createState() => _HomePageState();
}


  class _HomePageState extends State<HomePage>{
    
  var userData;
  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  void _getUserInfo() async {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var userJson = localStorage.getString('user'); 
      var user = json.decode(userJson);
      setState(() {
        userData = user;
      });

  }
List _filtrosSeleccionados= List();
  _showFiltrosDialog() {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          //print(_selecteCategorys);
          var listaFiltros=widget.list;
          //print(listaFiltros);
          //print(list);
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("Filtrar"),
            actions: <Widget>[
              FlatButton(
                child: Text("Filtrar"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
            content:StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) { 
              return Container(
              height: 300.0, // Change as per your requirement
              width: 300.0,
              child: new ListView(children: <Widget>[
                new Column(
                      children: <Widget>[
                        Container(
                          child:new ListView.builder(
                              itemCount: listaFiltros[0]['categorias'] == null ? 0 : listaFiltros[0]['categorias'].length,
                              itemBuilder: (context, i) {
                                        return CheckboxListTile(
                                              value: _filtrosSeleccionados.contains(listaFiltros[0]['categorias'][i]['idCategoriaTrabajo']),
                                              onChanged: (bool selected) {
                                                if (selected == true) {
                                                  setState(() {
                                                    _filtrosSeleccionados.add(listaFiltros[0]['categorias'][i]['idCategoriaTrabajo']);
                                                  });
                                                } else {
                                                  setState(() {
                                                    _filtrosSeleccionados.remove(listaFiltros[0]['categorias'][i]['idCategoriaTrabajo']);
                                                  });
                                                }
                                              },
                                          title: Text(listaFiltros[0]['categorias'][i]['nombreCategoriaTrabajo']),
                                        );
                              }
                            ),
                        ),
                      ],
                    ),
               ],
               ),
                
                );}
            
          ),);
        });
  }
    
  
        @override
        Widget build(BuildContext context) {
          return Scaffold(
            appBar : AppBar(
              backgroundColor: Colors.green,
              title: Text("Lo Hago Por Vos"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.search,
                    semanticLabel: 'buscar',
                  ),
                  onPressed: (){
                    showSearch(context: context, delegate: DataSearch());
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.tune,
                    semanticLabel: 'filtro',
                  ),
                  onPressed: (){
                    _showFiltrosDialog();
                  },
                ),
              ],
    
            ),
            drawer: MenuLateral(),
            body: ListarTrabajosPage(),
            resizeToAvoidBottomInset: false,
          );
        }


}

class DataSearch extends SearchDelegate<String>{
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear), onPressed: () {},
      ),
      IconButton(
        icon: Icon(Icons.send), onPressed: () {
          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ListarTrabajosBusqueda(query:query)));
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow, 
        progress: transitionAnimation, 
      ), onPressed: () {
        Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ListaFiltros()));
  
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(itemBuilder: (BuildContext context, int index) {},

    );
  }
  
}
