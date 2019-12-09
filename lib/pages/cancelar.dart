import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/home.dart';
import 'dart:convert';


class Cancelar extends StatefulWidget{
  final idPersonaLogeada;
  final idTrabajo;
  Cancelar(this.idPersonaLogeada, this.idTrabajo);
  @override
  _CancelarState createState() => _CancelarState();
}

class _CancelarState extends State<Cancelar> {
  
  TextEditingController motivoController = new TextEditingController();
  var _formkey= GlobalKey<FormState>();
  bool _cargando = false;


   void initState(){
    super.initState();  
  }

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
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

 @override
 Widget build(BuildContext context) {
    //print(widget.idTrabajo);
    return Scaffold(
      key:_scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: new Text('Cancelar'),
      ),
        body: Container(
          key: _formkey,
          child: Column(children: <Widget>[
            
            SizedBox(height: 40.0),
            new TextFormField(
                            controller: motivoController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              prefixIcon: Container(
                                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                                margin: const EdgeInsets.only(right: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                    bottomRight: Radius.circular(10.0)
                                  )
                                ),
                                child: Icon(Icons.add_comment, color: Colors.white60,)),
                              hintText: "Motivo...",
                              hintStyle: TextStyle(color: Colors.green),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none
                              ),
                              filled: true,
                              fillColor: Colors.green.withOpacity(0.1),
                            ),
                            
                          ),

            SizedBox(height: 40.0),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                color: Colors.purple,
                textColor: Colors.white,
                child: new Text(_cargando ? 'Cancelando'.toUpperCase() : 'Cancelar anuncio'.toUpperCase()),
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 32.0,
                ),
                onPressed: () {
                _cargando ? null : cancelar(); 
                },
              ),
            ),
          ],)
        )
    );
 }
 void cancelar() async{
    setState(() {
      _cargando = true;
    });
    var idTrabajo = widget.idTrabajo;
    var idPersonaLogeada = widget.idPersonaLogeada;

    var data = {
            'idPersona':idPersonaLogeada,
            'idTrabajo':idTrabajo,
            'motivo' : motivoController.text, 
            'flutter':true
    };
    var res = await CallApi().postData(data, 'cancelarTrabajo');
    var body = json.decode(res.body);
    print(body);
    if (body['success']){
        Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => HomePage()));
      }else{
      _mostrarMensaje('No se ha podido cancelar el anuncio');
      setState(() {
        _cargando = false;
      });
    }
 }
}
