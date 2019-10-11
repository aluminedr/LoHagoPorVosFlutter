import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';

import 'package:flutter_app/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';


class RegisterPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{
  TextEditingController mailUsuarioController = new TextEditingController();
  TextEditingController claveUsuarioController = new TextEditingController();
  TextEditingController nombreUsuarioController = new TextEditingController();
   
  bool _cargando = false;


    
 Function(String) mailValidator = (String value){
  if (value.isEmpty) {
    return 'mail no puede estar vacío';
  }
  // Regex para validación de email
  String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
      "\\@" +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
      "(" +
      "\\." +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
      ")+";
  RegExp regExp = new RegExp(p);
  if (regExp.hasMatch(value)) {
    return null;
  }
  return 'El Email suministrado no es válido. Intente otro correo electrónico';
};
 Function(String) nombreUsuarioValidator = (String value){
   if(value.isEmpty){
     return "Ingrese un nombre de usuario";
   }
   if(value.length>255){
    return 'El nombre de usuario es demasiado extenso';
  }
   return null;
 };
  Function(String) passValidator = (String value){
   if(value.isEmpty){
     return "Ingrese una contraseña";
   }
   if(value.length<8){
    return 'La contraseña debe contener 8 o mas caracteres';
  }
   return null;
 };

 ScaffoldState scaffoldState;
  _mostrarMensaje(msg) async {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label : 'Cerrar',
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
      body: Form(
        child: Container(
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
              ),
            ),
            Text("Lo hago por vos".toUpperCase(), style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 40.0),
            TextFormField(
              controller: nombreUsuarioController,
              validator:nombreUsuarioValidator,
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
                  child: Icon(Icons.person, color: Colors.lightGreen,)),
                hintText: "Ingrese un nombre de usuario",
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
            TextFormField(
              controller: mailUsuarioController,
              validator:mailValidator,
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
                  child: Icon(Icons.email, color: Colors.lightGreen,)),
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
            TextFormField(
              controller: claveUsuarioController,
              validator:passValidator,
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
                  child: Icon(Icons.vpn_key, color: Colors.lightGreen,)),
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
                  _cargando?"Guardando...".toUpperCase():"Registrarme".toUpperCase()
                
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
                child: Text("Ingresar".toUpperCase()),
                onPressed: (){
                  Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => LoginPage()));
                },
              ),
            ],),
            SizedBox(height: 10.0),
          ],
        ),
      ),
      ),
    );
  }

void _login() async {
    setState(() {
       _cargando = true; 
    });

    var data = {
        'nombreUsuario' : nombreUsuarioController.text,
        'mailUsuario' : mailUsuarioController.text,
        'claveUsuario' : claveUsuarioController.text,
    };

    var res = await CallApi().postData(data, 'register');
    var body = json.decode(res.body);
    if(body['success']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      localStorage.setString('user', json.encode(body['user']));
      
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