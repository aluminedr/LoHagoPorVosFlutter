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
    leerDatosUsuario();
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
            accountEmail: Text("$mailUsuario"), 
            accountName: Text("$nombreUsuario"),
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
          new Divider(
            color: Colors.deepPurple,
            height: 5.0,
          ),
          new ListTile(
            title: new Text("Salir"),
            onTap: (){
              logout();
                          },
                        ),
                      ],
                    ),
                  );
                }
                leerDatosUsuario() async { // Leemos los datos del usuario que estan cargado en preference
                  final prefs = await SharedPreferences.getInstance();
                  setState((){
                    mailUsuario = prefs.getString("mailUsuario");
                    nombreUsuario = prefs.getString("nombreUsuario");
                    rememberToken = prefs.getString("rememberToken");
                    idRol = prefs.getString("idRol");
                    idUsuario = prefs.getString("idUsuario");
                    
                  });
                }
              
                Future<bool> logout() async { // Funcion donde hace logout
                  
                  SharedPreferences prefs = await SharedPreferences.getInstance(); // Inicializa
                  prefs.remove("mailUsuario"); 
                  prefs.remove("nombreUsuario");
                  prefs.remove("rememberToken");
                  prefs.remove("idRol");
                  prefs.remove("idUsuario");
                  
                  // Removemos los valores del usuario y redireccionamos a login (pag principal)
                  Navigator.pushReplacementNamed(context, '/login');
                  return true;
                }

}
