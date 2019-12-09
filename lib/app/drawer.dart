import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/app/ovalRightClipper.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/pages/conversaciones.dart';
import 'package:flutter_app/pages/crearTrabajo.dart';
import 'package:flutter_app/pages/misPostulaciones.dart';
import 'package:flutter_app/pages/misTrabajos.dart';
import 'package:flutter_app/pages/verCategorias.dart';
import 'package:flutter_app/pages/verPerfil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuLateral extends StatefulWidget {
  State<StatefulWidget> createState() => _MenuLateralState();
}


  class _MenuLateralState extends State<MenuLateral>{
  var userData;
  var tokenData;
  var imagenPersona;
  String nombreUsuario;
  String mailUsuario;
  final Color primary = Colors.purple[700];
  final Color active = Colors.black87;
  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  void _getUserInfo() async {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var userJson = localStorage.getString('user');
      var userToken = localStorage.getString('token');
      var imagenPersona = localStorage.getString('imagenPersona');
      var user = json.decode(userJson);
      mailUsuario= user['mailUsuario'];
      nombreUsuario= user['nombreUsuario'];
      setState(() {
        userData = user;
        tokenData = userToken;
        imagenPersona=imagenPersona;
      });

  }
 
  Widget build(BuildContext context) {
    TextStyle tStyle = TextStyle(color: active, fontSize: 16.0);
    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 40),
          decoration: BoxDecoration(
              color: primary, boxShadow: [BoxShadow(color: Colors.black45)]),
          width: 300,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 90,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            colors: [Colors.pink, Colors.deepPurple])),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/imagenPerfil/$imagenPersona'),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    "$nombreUsuario",
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  Text(
                    "$mailUsuario",
                    style: TextStyle(color: active, fontSize: 16.0),
                  ),
                  SizedBox(height: 30.0),
                  _buildRow(Icons.person_pin,"Icono Mi Perfil","Perfil",VerPerfilPage()),
                  _buildDivider(),
                  _buildRow(Icons.add,"Icono nuevo anuncio", "Nuevo anuncio",CrearTrabajoPage()),
                  _buildDivider(),
                  _buildRow(Icons.list, "Icono ver categorias", "Categorias",VerCategoriasPage()),
                  _buildDivider(),
                  _buildRow(Icons.format_list_bulleted, "Icono mis anuncios" ,"Mis anuncios",MisTrabajos()),
                  _buildDivider(),
                  _buildRow(Icons.format_list_bulleted, "Icono mis postulaciones", "Mis postulaciones",MisPostulaciones()),
                  _buildDivider(),
                  _buildRow(Icons.chat, "Icono mis conversaciones", "Mis conversaciones",ListaConversaciones()),
                  _buildDivider(),
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child:new GestureDetector(
                            onTap: () => 
                              logout(),
                                child: Row(children: [
                                  IconButton(
                                    icon: Icon(
                                                  Icons.settings_power,
                                                  semanticLabel: "Icono cerrar sesion",
                                                  color: active,
                                                ),
                                                onPressed: () {
                                                  logout();
                                      },
                                    ),
                        SizedBox(width: 10.0),
                        Text(
                          'Cerrar sesion',
                          style: tStyle,
                        ),
                      ]),
                )),
                  _buildDivider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      color: active,
    );
  }

  Widget _buildRow(IconData icon, String semanticLabel, String title, dynamic press) {
    final TextStyle tStyle = TextStyle(color: active, fontSize: 16.0);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child:new GestureDetector(
            onTap: () => 
              Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context)=>  press
                          ),),
                child: Row(children: [
                  IconButton(
                    icon: Icon(
                                  icon,
                                  semanticLabel: semanticLabel,
                                  color: active,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                        Navigator.push(context, new MaterialPageRoute(
                          builder: (BuildContext context)=>  press
                        ));
                      },
                    ),
        SizedBox(width: 10.0),
        Text(
          title,
          style: tStyle,
        ),
      ]),
    ));
  }

  void logout() async{
      // logout from the server ... 
      var res = await CallApi().getData('logout');
      var body = json.decode(res.body);
      print(body);
      if(body['success']){
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.remove('user');
        localStorage.remove('token');
        localStorage.remove('idPersona');
        //localStorage.setBool('token', null);
    
        
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => LoHagoPorVos()));
      }
     
  }

}
