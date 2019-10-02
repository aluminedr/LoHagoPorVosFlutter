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
   bool emailValid = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
   if(value.isEmpty){
     return "Ingrese un email";
   }else if(!emailValid){
     return "Ingrese un email valido";
   }
   return null;
 };
 Function(String) nombreUsuarioValidator = (String value){
   if(value.isEmpty){
     return "Ingrese un nombre de usuario";
   }
   return null;
 };
  Function(String) passValidator = (String value){
   if(value.isEmpty){
     return "Ingrese una contraseña";
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
      appBar: AppBar(
        title: new Text("Registro"),
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomPadding: false,
      body: Form(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child:  ListView(
                  children: <Widget>[
                    new Column(
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
                      // Ingreso de email //
                      Container(
                              width: MediaQuery.of(context).size.width/1.2,
                              height: 60,
                              margin: EdgeInsets.only(
                                top: 10,
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
                        child: ListTile(
                          leading: const Icon(Icons.mail, color: Colors.black,),
                          title: new TextFormField(
                            controller: mailUsuarioController,
                            validator:mailValidator,
                            decoration: new InputDecoration(
                              hintText: "mimail@gmail.com",
                              labelText: "Mail",
                            ),
                          ),
                        ),
                      ),
                      // Ingreso de nombre de usuario
                      Container(
                              width: MediaQuery.of(context).size.width/1.2,
                              height: 60,
                              margin: EdgeInsets.only(
                                top: 10,
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
                        child: ListTile(
                          leading: const Icon(Icons.person, color: Colors.black,),
                          title: new TextFormField(
                            controller: nombreUsuarioController,
                            validator:nombreUsuarioValidator,
                            decoration: new InputDecoration(
                              labelText: "Nombre de usuario",
                            ),
                          ),
                        ),
                      ),
                      // Ingreso de contraseña
                      Container(
                              width: MediaQuery.of(context).size.width/1.2,
                              height: 60,
                              margin: EdgeInsets.only(
                                top: 10,
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
                        child: ListTile(
                          leading: const Icon(Icons.vpn_key, color: Colors.black,),
                          title: new TextFormField(
                            controller: claveUsuarioController,
                            validator:passValidator,
                            obscureText: true,
                            decoration: new InputDecoration(
                              hintText: "**********",
                              labelText: "Contraseña",
                            ),
                          ),
                        ),
                      ),
                      //Boton de registro
                        new RaisedButton(
                          child: new Text(_cargando ? 'Creando' : 'Registrarme'),
                          color: Colors.green,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)
                          ),
                          onPressed: () {
                               _cargando ? null : _login();                           
                          },
                        ),
                        //Tengo cuenta
                        new RaisedButton(
                          child: new Text("  Tengo cuenta  "),
                          color: Colors.green,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)
                          ),
                          onPressed: () {
                            Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => LoginPage()));
                          },
                        ),
                      ],
                    )
                  ]
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