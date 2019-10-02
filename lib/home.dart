
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/pages/verTrabajos.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/MenuLateral.dart';


class HomePage extends StatefulWidget {
  State<StatefulWidget> createState() => _HomePageState();
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
    
    
        @override
        Widget build(BuildContext context) {
          return Scaffold(
            appBar : AppBar(
              title: Text("Lo Hago Por Vos"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.search,
                    semanticLabel: 'buscar',
                  ),
                  onPressed: (){
                    print('Boton Buscar');
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.tune,
                    semanticLabel: 'filtro',
                  ),
                  onPressed: (){
                    print('Boton Filtrar');
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

