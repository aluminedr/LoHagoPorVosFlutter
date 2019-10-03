
import 'package:flutter/material.dart';
import 'package:flutter_app/app/theme.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/pages/login.dart';
import '../rutas.dart';


class LoVos extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_LoVosState();
}

class _LoVosState extends State<LoVos>{
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      onGenerateRoute: _getRoute,
      debugShowCheckedModeBanner: false,
      title: 'LO VOS',
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
