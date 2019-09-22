
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
      initialRoute: '/register',
      onGenerateRoute: _getRoute,
      debugShowCheckedModeBanner: false,
      title: 'LO HAGO POR VOS',
      home:HomePage(),
      routes: buildAppRoutes(),
      theme: buildAppTheme(),
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    if (settings.name != '/register') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => LoginPage(),
      fullscreenDialog: true,
    );
  }

}
