import 'package:flutter/material.dart';
import 'package:flutter_app/pages/crearTrabajo.dart';
import 'package:flutter_app/pages/login.dart';
import 'package:flutter_app/rutas.dart';
import 'package:flutter_app/theme.dart';

void main()=> runApp(new NuestraApp());

class NuestraApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_NuestraAppState();
}

class _NuestraAppState extends State<NuestraApp>{

  Widget paginaInicio = CrearTrabajoPage();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lo Hago Por Vos',
      home:paginaInicio, /*Scaffold(
        appBar: AppBar(
          title: Text("Lo Hago Por Vos"),
        ),
        drawer: MenuLateral(),
      ),*/
      routes: buildAppRoutes(),
      theme: buildAppTheme(),
    );

  }

}

class MenuLateral extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountEmail: Text("aluminede@gmail.com"), 
            accountName: Text("AlumineDr"),
          ),
          new ListTile(

          ),
        ],
      ),
    );
  }
  
}