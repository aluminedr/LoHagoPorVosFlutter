import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_app/pages/crearTrabajo.dart';
import 'package:flutter_app/pages/verCategorias.dart';
import 'package:flutter_app/pages/verPerfil.dart';
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
      home:Scaffold(
        appBar: AppBar(
          title: Text("Lo Hago Por Vos"),
        ),
        drawer: MenuLateral(),
      ),
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
            decoration: BoxDecoration(
              color: Colors.deepPurple[400],
            ),
            accountEmail: Text("aluminede@gmail.com"), 
            accountName: Text("AlumineDr"),
            currentAccountPicture: new CircleAvatar(
              backgroundImage: new NetworkImage("https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/cc/cc1b5c41b82f09ebfcb72790dd689d8d68c48f7a.jpg"),
            ),
          ),
          new ListTile(
            title: new Text("Perfil"),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.push(context, new MaterialPageRoute(
                builder: (BuildContext context)=> new VerPerfilPage()
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
        ],
      ),
    );
  }
  
}