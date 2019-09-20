import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String mailUsuario;
class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LoginPageState();


}
 

class _LoginPageState extends State<LoginPage>{
  TextEditingController mailUsuarioController = new TextEditingController();
  TextEditingController  claveUsuarioController = new TextEditingController();
  String mensajeError='';

  Future<List> login() async {
    final respuesta = await http.post("http://192.168.1.36/LoHagoPorVosFlutter/lib/conexion/Login.php",
        body: {
          "mailUsuario": mailUsuarioController.text,
          "claveUsuario": claveUsuarioController.text,
        });                                                                       

    var datosUsuario= json.decode(respuesta.body);

    if(datosUsuario.length == 0){
      setState(() {
        mensajeError="Mail o contraseña incorrectos" ;
      });
    }else{
      Navigator.pushReplacementNamed(context, '/vertrabajos');
      setState(() {
        mailUsuario = datosUsuario[0]['mailUsuario'];
      });
    }     
    return datosUsuario;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Ingreso"),
      ),
      resizeToAvoidBottomPadding: false,
      body: Form(
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
                    child: TextField(
                      controller: claveUsuarioController,
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
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 6,
                        right: 32,
                      ),
                      child: Text(
                        'Olvide mi contraseña',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  new RaisedButton(
                          child: new Text(
                            '       Ingresar      ',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)
                          ),
                          onPressed: (){
                            login();
                            Navigator.pop(context);
                          },
                        ),
                     
            new RaisedButton(
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/register');
                          },
                          child: Text(
                            "   Registrarme   ",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                
              Text(mensajeError)
              ]),
            )
          ],
        ),
        ),
      ),
    );
  }
}