import 'package:flutter/material.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/pages/listaFiltros.dart';
import 'package:flutter_app/pages/listaHabilidades.dart';
import 'package:flutter_app/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(LoHagoPorVos());

class LoHagoPorVos extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<LoHagoPorVos> {
  bool _isLoggedIn = false;
  bool _hasProfile = false;

  @override
  void initState() {
    _checkIfLoggedIn();
    _checkIfHasProfile();
    super.initState();
  }
  void _checkIfLoggedIn() async{
      // check if token is there
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var token = localStorage.getString('token');
      if(token!= null){
         setState(() {
            _isLoggedIn = true;
         });
      }
  }
  void _checkIfHasProfile() async{
      //busca si el usuario tiene un perfil
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var idPersona = localStorage.getInt('idPersona');
      if(idPersona!=null){
         setState(() {
            _hasProfile = true;
         });
      }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LO HAGO POR VOS',
      home: Scaffold(
        body: (_isLoggedIn && _hasProfile) ? ListaFiltros() : (_isLoggedIn && !_hasProfile) ? ListaHabilidadesPage() : LoginPage(),
      ),
      
    );
  }
}