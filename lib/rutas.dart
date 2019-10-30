import 'package:flutter/material.dart';
import 'package:flutter_app/app/drawer.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/pages/contraOlvidada.dart';
import 'package:flutter_app/pages/crearTrabajo.dart';
import 'package:flutter_app/pages/detallesTrabajo.dart';
import 'package:flutter_app/pages/listaHabilidades.dart';
import 'package:flutter_app/pages/login.dart';
import 'package:flutter_app/pages/register.dart';
import 'package:flutter_app/pages/verCategorias.dart';
import 'package:flutter_app/pages/verPerfil.dart';
import 'package:flutter_app/pages/verTrabajos.dart';
import 'home.dart';

Map <String, WidgetBuilder> buildAppRoutes(){
  var i;
  

    return{
      '/login': (BuildContext context) => new LoginPage(),
      '/register': (BuildContext context) => new RegisterPage(),
      '/contraolvidada': (BuildContext context) => new ContraOlvidadaPage(),
      '/verperfil': (BuildContext context) => new VerPerfilPage(),
      '/vertrabajos': (BuildContext context) => new ListarTrabajosPage(),
      '/creartrabajo': (BuildContext context) => new CrearTrabajoPage(),
      '/crearperfil': (BuildContext context) => new ListaHabilidadesPage(),
      '/vercategorias': (BuildContext context) => new VerCategoriasPage(),
      '/home': (BuildContext context) => new HomePage(),
      '/menulateral': (BuildContext context) => new MenuLateral(),
      '/main': (BuildContext context) => new LoHagoPorVos(),
      '/detallestrabajos': (BuildContext context) => new DetallesTrabajosPage(index: i),

    
  };
}