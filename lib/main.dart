import 'package:flutter/material.dart';
import 'package:flutter_app/pages/register.dart';
import 'package:flutter_app/rutas.dart';
import 'package:flutter_app/theme.dart';

void main()=> runApp(new NuestraApp());

class NuestraApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_NuestraAppState();
}

class _NuestraAppState extends State<NuestraApp>{

  Widget paginaInicio = RegisterPage();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Lo Hago Por Vos',
      home: paginaInicio,
      routes: buildAppRoutes(),
      theme: buildAppTheme(),
    );

  }

}