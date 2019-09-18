import 'package:flutter/material.dart';

class CrearPerfilPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CrearPerfilPageState();
  
  
  }
  
  class _CrearPerfilPageState extends State<CrearPerfilPage>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Crear Perfil"),
      ),
    );
  }
}