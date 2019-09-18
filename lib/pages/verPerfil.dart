import 'package:flutter/material.dart';

class VerPerfilPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _VerPerfilPageState();
  
  
  }
  
  class _VerPerfilPageState extends State<VerPerfilPage>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Perfil"),
      ),
    );
  }
}