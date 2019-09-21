import 'package:flutter/material.dart';
import 'package:flutter_app/pages/crearPerfil.dart';
import 'package:flutter_app/pages/crearTrabajo.dart';
import 'package:flutter_app/pages/login.dart';
import 'package:flutter_app/pages/verCategorias.dart';
import 'package:flutter_app/pages/verTrabajos.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuLateral extends StatefulWidget {
  State<StatefulWidget> createState() => _MenuLateralState();
}


  class _MenuLateralState extends State<MenuLateral>{
    String _mailUsuario = "";
    
    @override
  void initState() {
    readData();
        super.initState();
      }
      @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple[400],
            ),
            accountEmail: Text("aluminede@gmail.com"), 
            accountName: Text("$mailUsuario"),
            currentAccountPicture: new CircleAvatar(
              backgroundImage: new NetworkImage("https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/cc/cc1b5c41b82f09ebfcb72790dd689d8d68c48f7a.jpg"),
            ),
          ),
          new ListTile(
            title: new Text("Perfil"),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.push(context, new MaterialPageRoute(
                builder: (BuildContext context)=> new CrearPerfilPage()
              ));
            },
          ),
          new Divider(
            color: Colors.deepPurple,
            height: 5.0,
          ),
          new ListTile(
            title: new Text("Nuevo anuncio"),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.push(context, new MaterialPageRoute(
                builder: (BuildContext context)=> new CrearTrabajoPage()
              ));
            },
          ),
          new Divider(
            color: Colors.deepPurple,
            height: 5.0,
          ),
          new ListTile(
            title: new Text("Categorias"),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.push(context, new MaterialPageRoute(
                builder: (BuildContext context)=> new VerCategoriasPage()
              ));
            },
          ),
          new Divider(
            color: Colors.deepPurple,
            height: 5.0,
          ),
          new ListTile(
            title: new Text("Historial"),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.push(context, new MaterialPageRoute(
                builder: (BuildContext context)=> new VerCategoriasPage()
              ));
            },
          ),
          new Divider(
            color: Colors.deepPurple,
            height: 5.0,
          ),
          new ListTile(
            title: new Text("Trabajos"),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.push(context, new MaterialPageRoute(
                builder: (BuildContext context)=> new ListarTrabajosPage()
              ));
            },
          ),

        ],
      ),
    );
  }
  readData() async {
    final prefs = await SharedPreferences.getInstance();
    setState((){
      mailUsuario = prefs.getString("mailUsuario");
    });
  }

}
