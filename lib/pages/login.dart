import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';

import 'package:flutter_app/pages/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

String mailUsuario;
String nombreUsuario;
String rememberToken;
String idRol;
String idUsuario;

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}
 

class _LoginPageState extends State<LoginPage>{

  bool _cargando = false;

  TextEditingController mailUsuarioController = new TextEditingController();
  TextEditingController  claveUsuarioController = new TextEditingController();
  ScaffoldState scaffoldState;
  _mostrarMensaje(msg) async {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Cerrar',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.lightGreen,
              Colors.green
            ]
          )
        ),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 40.0,bottom: 20.0),
              height: 80,
              child:  new Image(
                width: 135,
                height: 135,
                image: new AssetImage('assets/images/LoHagoPorVosLogo.png'),
                semanticLabel: 'Logo de Lo Hago Por Vos',
              ),
            ),
            Text("Lo hago por vos".toUpperCase(), style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 40.0),
            TextField(
              controller: mailUsuarioController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16.0),
                prefixIcon: Container(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                  margin: const EdgeInsets.only(right: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(10.0)
                    )
                  ),
                  child: Icon(Icons.email, color: Colors.lightGreen,semanticLabel: "Icono ingrese un mail")),
                semanticCounterText: "Ingrese un mail", 
                hintText: "Ingrese su mail",
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
              ),
              
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: claveUsuarioController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16.0),
                prefixIcon: Container(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                  margin: const EdgeInsets.only(right: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(10.0)
                    )
                  ),
                  child: Icon(Icons.vpn_key, color: Colors.lightGreen,semanticLabel: "Icono ingrese su contraseña",)),
                semanticCounterText: "Ingrese su contraseña", 
                hintText: "Ingrese su contraseña",
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
              ),
              obscureText: true,
            ),
            SizedBox(height: 30.0),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                color: Colors.white,
                textColor: Colors.lightGreen,
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  _cargando?"Ingresando...".toUpperCase():"Ingresar".toUpperCase()
                
                ),
                onPressed: (){
                  _cargando ? null : _login();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)
                ),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              FlatButton(
                textColor: Colors.white,
                child: Text("Registrarme".toUpperCase()),
                onPressed: (){
                  Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => RegisterPage()));
                },
              ),
              Container(
                color: Colors.white54,
                width: 2.0,
                height: 20.0,
              ),
              FlatButton(
                textColor: Colors.white,
                child: Text("Olvide mi contraseña".toUpperCase()),
                onPressed: (){
                },
              ),

            ],),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

void _login() async{
    
    setState(() {
       _cargando = true;
    });

    var data = {
        'mailUsuario' : mailUsuarioController.text, 
        'claveUsuario' : claveUsuarioController.text
    };

    var res = await CallApi().postData(data, 'login');
    var body = json.decode(res.body);
    print(body);
    if(body ['success']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      localStorage.setString('user', json.encode(body['user']));
      localStorage.setInt('idPersona', body['idPersona']);
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => LoHagoPorVos()));
    }else{
      _mostrarMensaje(body['error']);
    }


    setState(() {
       _cargando = false;
    });

  


  }                              

}
