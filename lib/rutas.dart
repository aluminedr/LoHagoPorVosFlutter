import 'package:flutter/material.dart';
import 'package:flutter_app/pages/contraOlvidada.dart';
import 'package:flutter_app/pages/crearPerfil.dart';
import 'package:flutter_app/pages/crearTrabajo.dart';
import 'package:flutter_app/pages/login.dart';
import 'package:flutter_app/pages/register.dart';
import 'package:flutter_app/pages/verCategorias.dart';
import 'package:flutter_app/pages/verPerfil.dart';
import 'package:flutter_app/pages/verTrabajos.dart';
import 'app/MenuLateral.dart';
import 'home.dart';

Map <String, WidgetBuilder> buildAppRoutes(){
  return{
    '/login': (BuildContext context) => new LoginPage(),
    '/register': (BuildContext context) => new RegisterPage(),
    '/contraolvidada': (BuildContext context) => new ContraOlvidadaPage(),
    '/verperfil': (BuildContext context) => new VerPerfilPage(),
    '/vertrabajos': (BuildContext context) => new ListarTrabajosPage(),
    '/creartrabajo': (BuildContext context) => new CrearTrabajoPage(),
    '/crearperfil': (BuildContext context) => new CrearPerfilPage(),
    '/vercategorias': (BuildContext context) => new VerCategoriasPage(),
    '/home': (BuildContext context) => new HomePage(),
    '/menulateral': (BuildContext context) => new MenuLateral(),
    

  };
}