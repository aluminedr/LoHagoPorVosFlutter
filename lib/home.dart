
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/login.dart';
import 'package:flutter_app/pages/verTrabajos.dart';

import 'app/MenuLateral.dart';


class HomePage extends StatefulWidget {
  State<StatefulWidget> createState() => _HomePageState();
}


  class _HomePageState extends State<HomePage>{
    String _mailUsuario = "";

    @override
  void initState() {
    getMailUsuarioPreference().then(updateMailUsuario);
        super.initState();
      }
    
    
        @override
        Widget build(BuildContext context) {
          // TODO: Return an AsymmetricView (104)
          // TODO: Pass Category variable to AsymmetricView (104)
          return Scaffold(
            appBar : AppBar(
              title: Text('Lo Hago por Vos'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.search,
                    semanticLabel: 'buscar',
                  ),
                  onPressed: (){
                    print('Boton Buscar');
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.tune,
                    semanticLabel: 'filtro',
                  ),
                  onPressed: (){
                    print('Boton Filtrar');
                  },
                ),
              ],
    
            ),
            drawer: MenuLateral(),
            body: ListarTrabajosPage(),
            resizeToAvoidBottomInset: false,
          );
        }
      
      void updateMailUsuario(String mailUsuario) {
        setState(() {
          this._mailUsuario = mailUsuario;
          
        });
  }
}


