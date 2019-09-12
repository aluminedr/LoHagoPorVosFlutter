import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/behavior/hiddenScrollBehavior.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LoginPageState();


}

class _LoginPageState extends State<LoginPage>{
  var _mailUsuarioController = new TextEditingController();
  var _claveUsuarioController = new TextEditingController();
  var data;


              Future<String> getData(String mailUsuario) async {
                var response = await http.get(
                    Uri.encodeFull(
                        "http://192.168.200.142/www/FlutterTraining/Login.php?mailUsuario=${mailUsuario}"),
                    headers: {"Accept": "application/json"});

                print(response.body);
                setState(() {
                  var convertDataToJson = json.decode(response.body);
                  data = convertDataToJson['result'];
                });
              }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
          return Scaffold(
           appBar: AppBar(
             title: Text('Ingresar'),
           ),
           body: Container(
             padding: EdgeInsets.all(20.0),
               child: ScrollConfiguration(
                 behavior: HiddenScrollBehavior(),
                 child: Form(
                   child: ListView(
                     children: <Widget>[
                       TextFormField(
                         controller: _mailUsuarioController,
                         autocorrect: false,
                         keyboardType: TextInputType.emailAddress,
                         decoration: InputDecoration(
                           labelText: 'Mail'
                         ),
                       ),
                       TextFormField(
                         controller: _claveUsuarioController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña'
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Text('Bienvenido a ¡Lo Hago Por Vos!'),
                  ),
                  FlatButton(
                    child: Text('Olvide mi contraseña'),
                    onPressed: (){
                      Navigator.of(context).pushNamed('/contraolvidada');
                    },
                  ),
                  FlatButton(
                    child: Text('Registrarme'),
                    onPressed: (){
                      Navigator.of(context).pushNamed('/register');
                    },
                  )
                ],
              ),
            ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          getData(_mailUsuarioController.text);
        },
        child: Icon(Icons.account_circle),
      ),
      persistentFooterButtons: <Widget>[
        FlatButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: Text('No tengo una cuenta. ¡Registrarme!'),
        )
      ],
      );
  }
}