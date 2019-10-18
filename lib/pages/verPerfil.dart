import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';



class VerPerfilPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _VerPerfilPageState();
  
  
  }
  
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  String nombrePersona;
  String apellidoPersona;
  String dniPersona;
  String telefonoPersona;
  String imagenPersona;
  String mailUsuario;
  String nombreUsuario;
  String claveUsuario;
  int idUsuario;
  var valor;
  var nuevoValor;
  var nuevoMail;
  var clave;

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
    _scaffoldKey.currentState.showSnackBar(snackBar);
   }



  class _VerPerfilPageState extends State<VerPerfilPage>{
    
    @override
    void initState() {
      getDetalles();
      super.initState();
    }


    void getDetalles() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var idPersona =  localStorage.getInt('idPersona');
    var usuarioJson = localStorage.getString('user');
    var usuario = json.decode(usuarioJson);
    mailUsuario= usuario['mailUsuario'];
    nombreUsuario= usuario['nombreUsuario'];
    idUsuario= usuario['idUsuario'];
    var data ={
      'idPersona': idPersona,
    };
    var res = await CallApi().postData(data,'perfil');
    var persona = json.decode(res.body);

    setState(() {
      nombrePersona = persona['persona']['nombrePersona'];
      apellidoPersona = persona['persona']['apellidoPersona'];
      dniPersona = persona['persona']['dniPersona'];
      telefonoPersona = persona['persona']['telefonoPersona'];
      imagenPersona = persona['persona']['imagenPersona'];
    });
    

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey,
      appBar: AppBar(
        title: new Text("Perfil"),
        actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: Colors.white,
                      ), onPressed: () {},
                    )]
      ),
        backgroundColor: Color.fromRGBO(255, 255, 255, .9),
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 330,
                    color: Colors.lightGreen,
                  ),
                  
                  Column(
                    children: <Widget>[
                      Container(
                        height: 90,
                        margin: EdgeInsets.only(top: 60),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          //child: PNetworkImage(rocket),
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.all(4),
                      ),
                      Text(
                        "$nombrePersona",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.all(4),
                      ),
                      Text(
                        "$apellidoPersona",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 77),
                        padding: EdgeInsets.all(10),
                        child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                      padding:
                                          EdgeInsets.only(top: 15, bottom: 5),
                                      child: Text("Photos",
                                          style: TextStyle(
                                              color: Colors.black54))),
                                  Container(
                                      padding: EdgeInsets.only(bottom: 15),
                                      child: Text("5,000",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16))),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                      padding:
                                          EdgeInsets.only(top: 15, bottom: 5),
                                      child: Text("Followers",
                                          style: TextStyle(
                                              color: Colors.black54))),
                                  Container(
                                      padding: EdgeInsets.only(bottom: 15),
                                      child: Text("5,000",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16))),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 5),
                                      child: Text("Followings",
                                          style: TextStyle(
                                              color: Colors.black54))),
                                  Container(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text("5,000",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      UserInfo()
                    ],
                  )
                ],
              ),
            ],
          ),
        ));
  }
}

class UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Mis datos",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Divider(
                    color: Colors.black38,
                  ),
                  Container(
                      child: Column(
                      children: <Widget>[
                        FlatButton(
                          textColor: Colors.black,
                          child: ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                  leading: Icon(Icons.person),
                                  title: Text("NOMBRE"),
                                  subtitle: Text("$nombrePersona"),
                                ),
                          onPressed: (){
                            showAlertDialog(context,nombrePersona,'Nombre','nombrePersona');
                          },
                        ),
                      ])
                  ),
                  Container(
                      child: Column(
                      children: <Widget>[
                        FlatButton(
                          textColor: Colors.black,
                          child: ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                  leading: Icon(Icons.person),
                                  title: Text("APELLIDO"),
                                  subtitle: Text("$apellidoPersona"),
                                ),
                          onPressed: (){
                            showAlertDialog(context,apellidoPersona,'Apellido','apellidoPersona');
                          },
                        ),
                      ])
                   ),
                  Container(
                      child: Column(
                      children: <Widget>[
                        FlatButton(
                          textColor: Colors.black,
                          child: ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                  leading: Icon(Icons.email),
                                  title: Text("MAIL"),
                                  subtitle: Text("$mailUsuario"),
                                ),
                          onPressed: (){
                            showAlertDialogMail(context,mailUsuario,'Mail','mailUsuario');
                          },
                        ),
                      ])
                   ),
                  Container(
                      child: Column(
                      children: <Widget>[
                        FlatButton(
                          textColor: Colors.black,
                          child: ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                  leading: Icon(Icons.phone),
                                  title: Text("Telefono"),
                                  subtitle: Text("$telefonoPersona"),
                                ),
                          onPressed: (){
                            showAlertDialog(context,telefonoPersona,'Telefono','telefonoPersona');
                          },
                        ),
                      ])
                   ),
                   Container(
                      child: Column(
                      children: <Widget>[
                        FlatButton(
                          textColor: Colors.black,
                          child: ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                  leading: Icon(Icons.vpn_key),
                                  title: Text("CONTRASEÑA"),
                                  subtitle: Text("$claveUsuario"),
                                ),
                          onPressed: (){
                            showAlertDialog(context,claveUsuario,'Contraseña','claveUsuario');
                          },
                        ),
                      ])
                   ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

  void _actualizar(nuevoValor,columna) async {
    if (nuevoValor != null && nuevoValor!=''){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var idPersona =  localStorage.getInt('idPersona');
      var data = {
          'idPersona' : idPersona,
          columna : nuevoValor,
      };

      var res = await CallApi().postData(data, 'actualizarPerfil');
      var body = json.decode(res.body);

      nuevoValor = null;
      if(body['success']){
        _mostrarMensaje(body['mensaje']);
      }else{
        _mostrarMensaje(body['mensaje']);
      }
      
    }
  }

  void _actualizarMail(nuevoMail,clave) async {

    if (nuevoMail != null && nuevoMail != '' && clave != null && clave != ''){
      var data = {
          'idUsuario' : idUsuario,
          'mailUsuario' : nuevoMail,
          'clave' : clave
      };
      print(data);
      var res = await CallApi().postData(data, 'actualizarMail');
      var body = json.decode(res.body);
      print(body);
      nuevoMail = null;
      clave = null;

      if(body['success']){
        _mostrarMensaje(body['mensaje']);
      }else{
        _mostrarMensaje(body['mensaje']);
      }
      
    }
  }
    
showAlertDialog(BuildContext context,valor,subTitulo,columna) {

  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancelar"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Guardar"),
    onPressed:  () {
      _actualizar(nuevoValor,columna);
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Modificar dato"),
    content: new Row(
          children: <Widget>[
            new Expanded(
                child: new TextField(
              autofocus: true,
              decoration: new InputDecoration(
                  labelText: subTitulo, hintText: valor),
              onChanged: (valorIngresado) {
                nuevoValor = valorIngresado;
              },
            ))
          ],
        ),
        actions: [
          cancelButton,
          continueButton, 
          ]   
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialogMail(BuildContext context,valor,subTitulo,columna) {

  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancelar"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Guardar"),
    onPressed:  () {
      _actualizarMail(nuevoMail,clave);
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Modificar Mail"),
    content:new Column(
      children: <Widget>[
          new Row(
                  children: <Widget>[
                    new Expanded(
                        child: new TextField(
                        autofocus: true,
                        decoration: new InputDecoration(
                            labelText: subTitulo, hintText: valor),
                        onChanged: (valorIngresado) {
                          nuevoMail = valorIngresado;
                        },
                      )
                    ),
                  ]),
          new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText:'Contraseña', hintText: ''),
                  onChanged: (valorIngresado) {
                    clave = valorIngresado;
                  },
                )
              ),
            ],
          ),
      ]
    
    ),
        actions: [
          cancelButton,
          continueButton, 
          ]   
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );


}
