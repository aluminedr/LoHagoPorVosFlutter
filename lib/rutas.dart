import 'package:flutter/material.dart';
import 'package:flutter_app/pages/contraOlvidada.dart';
import 'package:flutter_app/pages/login.dart';
import 'package:flutter_app/pages/register.dart';

Map <String, WidgetBuilder> buildAppRoutes(){
  return{
    '/login': (BuildContext context) => new LoginPage(),
    '/register': (BuildContext context) => new RegisterPage(),
    '/contraolvidada': (BuildContext context) => new ContraOlvidadaPage(),
  };
}