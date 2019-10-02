import 'package:flutter/material.dart';

class ContraOlvidadaPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ContraOlvidadaPageState();

  

}

class _ContraOlvidadaPageState extends State<ContraOlvidadaPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contraseña olvidada'),
      ),
    );
  }
}