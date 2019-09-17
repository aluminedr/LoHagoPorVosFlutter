import 'package:flutter/material.dart';
import 'package:flutter_app/pages/login.dart';
import 'package:flutter_app/rutas.dart';
import 'package:flutter_app/theme.dart';

void main()=> runApp(new NuestraApp());

class NuestraApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_NuestraAppState();
}

class _NuestraAppState extends State<NuestraApp>{

  Widget paginaInicio = LoginPage();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lo Hago Por Vos',
      home: paginaInicio,
      routes: buildAppRoutes(),
      theme: buildAppTheme(),
    );

  }

}