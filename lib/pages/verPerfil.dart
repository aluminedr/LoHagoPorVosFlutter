import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
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
  String valor;
  String nuevoValor;
  String nuevoMail;
  String clave;
  String claveNueva;
  String claveNuevaRepetida;
  String claveVieja;

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
      _getDetalles();
      super.initState();
    }


    void _getDetalles() async {
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
      localStorage.setString('imagenPersona', persona['persona']['imagenPersona']);

      setState(() {
        nombrePersona = persona['persona']['nombrePersona'];
        apellidoPersona = persona['persona']['apellidoPersona'];
        dniPersona = persona['persona']['dniPersona'];
        telefonoPersona = persona['persona']['telefonoPersona'];
        imagenPersona = persona['persona']['imagenPersona'];
        if(imagenPersona==null){
          imagenPersona='hola.jpg';
        }
      });
    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: new Text("Perfil")
        /*actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: Colors.white,
                      ), onPressed: () {},
                    )]*/
      ),
        backgroundColor: Color.fromRGBO(255, 255, 255, .9),
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 265,
                    color: Colors.lightGreen,
                  ),
                  
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Container(
                  width: 100,
                  height: 100,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width: 3),
                    image: DecorationImage(
                        image: AssetImage('../LoHagoPorVosLaravel/public/storage/perfiles/$imagenPersona'),
                        fit: BoxFit.fill),
                  ),
                ),
                        
        
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
                        margin: EdgeInsets.only(top: 30),
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

class UserInfo extends StatefulWidget {
  State<StatefulWidget> createState() => _UserInfoState();
  }

  class _UserInfoState extends State<UserInfo>{
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
                                  title: Text("TELEFONO"),
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
                                  title: Text("CAMBIAR CONTRASEÑA"),
                                ),
                          onPressed: (){
                            showAlertDialogClave(context,claveUsuario,'Contraseña actual','claveUsuario');
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


  void _actualizar(nuevoValor,columna) async {
    if (nuevoValor != null && nuevoValor!=''){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var idPersona =  localStorage.getInt('idPersona');
      var data = {
          'idPersona' : idPersona,
          columna : nuevoValor,
      };
      setState((){

      });
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
      var res = await CallApi().postData(data, 'actualizarMail');
      var body = json.decode(res.body);
      nuevoMail = null;
      clave = null;

      if(body['success']){
        _mostrarMensaje(body['mensaje']);
      }else{
        _mostrarMensaje(body['mensaje']);
      }
      
    }
  }
  
  void _actualizarContrasena(claveNueva,claveNuevaRepetida,claveVieja) async{
    if (claveVieja != null && claveVieja != '' && claveNueva != null && claveNueva != ''){
      var data = {
          'idUsuario' : idUsuario,
          'claveVieja' : claveVieja,
          'claveNueva' : claveNueva
      };
      var res = await CallApi().postData(data, 'actualizarClave');
      var body = json.decode(res.body);
      claveVieja = null;
      claveNueva = null;
      claveNuevaRepetida = null;
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
      if(columna == 'telefonoPersona'){
        print('aca');
        String p = "[0-9+]{6,12}";
        RegExp regExp = new RegExp(p);
        if (regExp.hasMatch(nuevoValor)) {
          _actualizar(nuevoValor,columna);
          Navigator.of(context).pop();
        }else{
          _mostrarMensaje('Telefono no valido');
          nuevoValor = null;
          Navigator.of(context).pop();
        }
      }else{
        if(nuevoValor != '' && nuevoValor != null){
          _actualizar(nuevoValor,columna);
          Navigator.of(context).pop();
        }else{
          _mostrarMensaje('No se realizaron cambios');
          nuevoValor = null;
          Navigator.of(context).pop();
        }
      }
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
                )
            )
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
      String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
      "\\@" +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
      "(" +
      "\\." +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
      ")+";
      RegExp regExp = new RegExp(p);
      if (clave!=null && clave!=''){
        if (regExp.hasMatch(nuevoMail)) {
          _actualizarMail(nuevoMail,clave);
          Navigator.of(context).pop();
        }else{
          _mostrarMensaje('Correo electronico no valido. Vuelva a intentarlo');
          Navigator.of(context).pop();
        }
      }else{
        _mostrarMensaje('La contraseña no puede estar vacia');
          Navigator.of(context).pop();
      }
      clave = null;
      
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
                  obscureText: true,
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

showAlertDialogClave(BuildContext context,valor,subTitulo,columna) {

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
      if(claveNueva == claveNuevaRepetida){
        if(claveNueva.length<8){
          _mostrarMensaje('La contraseña debe contener 8 o mas caracteres');
          Navigator.of(context).pop();
        }else{
          _actualizarContrasena(claveNueva,claveNuevaRepetida,claveVieja);
          Navigator.of(context).pop();
        }
      }else{
        _mostrarMensaje('Las contraseñas no coinciden');
        Navigator.of(context).pop();
      }
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Modificar contraseña"),
    content:new Column(
      children: <Widget>[
          new Row(
                  children: <Widget>[
                    new Expanded(
                        child: new TextField(
                          obscureText: true,
                        autofocus: true,
                        decoration: new InputDecoration(
                            labelText: subTitulo, hintText: valor),
                        onChanged: (valorIngresado) {
                          claveVieja = valorIngresado;
                        },
                      )
                    ),
                  ]),
          new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                    obscureText: true,
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText:'Contraseña nueva', hintText: ''),
                  onChanged: (valorIngresado) {
                    claveNueva = valorIngresado;
                  },
                )
              ),
            ],
          ),
          new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                    obscureText: true,
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText:'Repetir contraseña nueva', hintText: ''),
                  onChanged: (valorIngresado) {
                    claveNuevaRepetida = valorIngresado;
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


}
