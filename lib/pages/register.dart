import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _RegisterPageState();

  

}

class _RegisterPageState extends State<RegisterPage>{
  TextEditingController mailUsuarioController = new TextEditingController();
  TextEditingController  claveUsuarioController = new TextEditingController();
  String mensajeError='';
  var _formkey= GlobalKey<FormState>();

  void register(){
    var url="http://192.168.0.5/LoHagoPorVosFlutter/lib/conexion/NewUser.php";
    http.post(url,body:{
      'mailUsuario':mailUsuarioController.text,
      'claveUsuario':claveUsuarioController.text,
    });
  }
    
        

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Form(
        key: _formkey,
        child: Container(
        child: Column(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.only(top: 77.0),
              child: new CircleAvatar(
                backgroundColor: Color(0xf81f7f3),
                child: new Image(
                  width: 135,
                  height: 135,
                  image: new AssetImage('assets/images/LoHagoPorVosLogo.png'),
                ),
              ),
              width: 170,
              height: 170,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top:93),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    padding: EdgeInsets.only(
                      top: 4,right: 16,left: 16,bottom: 4
                      ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Colors.grey,
                      boxShadow: [BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5
                      )]
                    ),
                    child: TextFormField(
                      controller: mailUsuarioController,
                      validator: (value){
                        if(value.isEmpty) return "Ingrese un email";
                      },
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.email,
                          color: Colors.black,
                        ),
                        hintText: 'Mail',
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: 50,
                    margin: EdgeInsets.only(
                      top: 32,
                    ),
                    padding: EdgeInsets.only(
                      top: 4, left: 16,right: 16,bottom: 4
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Colors.grey,
                      boxShadow: [BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5
                      )]
                    ),
                    child: TextFormField(
                      controller: claveUsuarioController,
                      validator: (value){
                        if(value.isEmpty) return "Ingrese una contraseña";
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.vpn_key,
                          color: Colors.black,
                        ),
                      hintText: 'Contraseña',
                      ),
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: new RaisedButton(
                          child: new Text('Registrarme'),
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)
                          ),
                          onPressed: (){
                            if(_formkey.currentState.validate()){
                              register();
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: FlatButton(
                          color: Colors.green,
                          padding: EdgeInsets.all(8.0),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: Text(
                            "Ya tengo una cuenta",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ),
                    ]),
                  Text(mensajeError)
                ],
              ),
            )
          ],
        ),
        ),
      ),
    );
  }
}