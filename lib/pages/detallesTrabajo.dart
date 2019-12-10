
import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:flutter_app/MercadoPago/enviarDatosMP.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/pages/comentarios.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';





class DetallesTrabajosPage extends StatefulWidget{
  final index;
  DetallesTrabajosPage({Key key, this.index}) : super(key: key);

  @override
  _DetallesTrabajosPageState createState() => _DetallesTrabajosPageState();
}

class _DetallesTrabajosPageState extends State<DetallesTrabajosPage> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  String titulo;
  String descripcion;
  int monto;
  String imagenTrabajo;
  int idPersonaTrabajo;
  int idPersonaLogeada;
  bool postulado= false;

  var urlDecode;
    void _getDetalles() async {
    var data ={
      'idTrabajo': widget.index,
    };
    var res = await CallApi().postData(data,'detalleTrabajo');
    var trabajo = json.decode(res.body);
    var trabajoDetalle= trabajo[0];
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    idPersonaLogeada = localStorage.getInt('idPersona');
    var datosAspirante={
      'idTrabajo': widget.index,
      'idPersona':idPersonaLogeada,
    };
    var resAspirante = await CallApi().postData(datosAspirante,'buscarAspiranteTrabajo');
    var trabajoAspirante = json.decode(resAspirante.body);
    if(trabajoAspirante.length!=0){
      postulado= true;
    }
    setState(() {
        titulo= trabajoDetalle['titulo'];
        descripcion= trabajoDetalle['descripcion'];
        monto= trabajoDetalle['monto'];
        imagenTrabajo= trabajoDetalle['imagenTrabajo'];
        idPersonaTrabajo= trabajoDetalle['idPersona'];
        if(imagenTrabajo==null){
          imagenTrabajo='hoja.jpg';
        }
        postulado= postulado;
      }); 
  }
  
   void initState(){
    _getDetalles();
    super.initState();  
  }
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
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

  Widget build(BuildContext context) {
      return Scaffold(
        key:_scaffoldKey,
      body:Stack(
        children: <Widget>[
          Container(
            foregroundDecoration: BoxDecoration(
              color: Colors.black26
            ),
            height: 400,
            child: Image.asset('assets/imagenCategoria/$imagenTrabajo', fit: BoxFit.cover)),
          ListView(
            padding: const EdgeInsets.only(top: 16.0,bottom: 20.0),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 250),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:16.0),
                    child: Text(
                      "$titulo",
                      style: TextStyle(color: Colors.black, fontSize: 28.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      const SizedBox(width: 16.0),
                      Spacer(),
                      IconButton(
                        color: Colors.green,
                        icon: Icon(Icons.comment),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Comentarios(index: widget.index)));
                        },
                      ),
                      Text('Comentarios'.toUpperCase()),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(32.0),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text("\$$monto", style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0
                                ),),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 30.0),
                        SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                            color: Colors.purple,
                            textColor: Colors.white,
                            child:Text(
                              postulado ? "esperando asignación".toUpperCase() : "Postularme".toUpperCase(), 
                              style: TextStyle(
                              fontWeight: FontWeight.normal
                            ),),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 32.0,
                            ),
                            onPressed: () {
                              if (!(postulado)){
                                postularse();
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        Text("Descripcion".toUpperCase(), style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0
                        ),),
                        const SizedBox(height: 10.0),
                        Text(
                            "$descripcion", textAlign: TextAlign.justify, style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14.0
                            ),),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ],
              ),
            ],
                  //physics: ClampingScrollPhysics(), // todo comment this out and check the result
          ),
        ],
      ),
    );
  }

  void postularse() async {
    var data = {
      "idTrabajo":widget.index,
      "idPersona":idPersonaLogeada,
      "flutter":true,
    };

    var res = await CallApi().postData(data, 'postularme');
    var body = json.decode(res.body);
      if (body['success']){
        Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => LoHagoPorVos()));
      }else{
      _mostrarMensaje(body['error']);
    }
    
  }

}
  


