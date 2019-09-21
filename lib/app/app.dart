
import 'package:flutter/material.dart';
import 'package:flutter_app/app/theme.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/pages/login.dart';
import '../rutas.dart';


class LoHagoPorVos extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_LoHagoPorVosState();
}

class _LoHagoPorVosState extends State<LoHagoPorVos>{
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      onGenerateRoute: _getRoute,
      debugShowCheckedModeBanner: false,
      title: 'Lo Hago Por Vos',
      home:HomePage(),
      routes: buildAppRoutes(),
      theme: buildAppTheme(),
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => LoginPage(),
      fullscreenDialog: true,
    );
  }

}
