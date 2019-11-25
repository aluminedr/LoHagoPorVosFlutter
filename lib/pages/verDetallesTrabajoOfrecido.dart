import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:flutter_app/MercadoPago/enviarDatosMP.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/pages/comentarios.dart';
import 'package:flutter_app/pages/listaAspirantes.dart';
import 'package:flutter_app/pages/valorar.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'webViewContainer.dart';




class DetallesHistorialPage extends StatefulWidget{
  final index;
  final idEstado;
  DetallesHistorialPage({Key key, this.index, this.idEstado}) : super(key: key);

  @override
  _DetallesHistorialPageState createState() => _DetallesHistorialPageState();
}

class _DetallesHistorialPageState extends State<DetallesHistorialPage> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  String titulo;
  String descripcion;
  int monto;
  String imagenTrabajo;
  int idPersonaTrabajo;
  int idPersonaLogeada;
  int idTrabajo;
  bool asignado= false;
  bool pagado=false;
  bool valorado=false;

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
    //Busco si el trabajo ya tiene asignado un postulante
    var datosAsignado={
      'idTrabajo': widget.index,
    };
    var resAsignado = await CallApi().postData(datosAsignado,'buscarTrabajoAsingado');
    var trabajoAsignado = json.decode(resAsignado.body);
    if(trabajoAsignado.length!=0){
      asignado= true;
    }
    //Busco si el trabajo ya fue abonado
    var datosPagado={
      'idTrabajo': widget.index,
    };
    var resPagado = await CallApi().postData(datosPagado,'buscarPagoTrabajo');
    var trabajoPagado = json.decode(resPagado.body);
    if(trabajoPagado.length!=0){
      pagado= true;
    }
    //Busco si el trabajo ya fue valorado
    var datosValorado={
      'idTrabajo': widget.index,
      'idPersonaLogeada':idPersonaLogeada,
    };
    var resValorado = await CallApi().postData(datosValorado,'buscarValoracionTrabajo');
    var trabajoValorado = json.decode(resValorado.body);
    if(trabajoValorado.length!=0){
      valorado= true;
    }
    setState(() {
        idTrabajo= widget.index;
        titulo= trabajoDetalle['titulo'];
        descripcion= trabajoDetalle['descripcion'];
        monto= trabajoDetalle['monto'];
        imagenTrabajo= trabajoDetalle['imagenTrabajo'];
        idPersonaTrabajo= trabajoDetalle['idPersona'];
        if(imagenTrabajo==null){
          imagenTrabajo='hoja.jpg';
        }
        asignado=asignado;
        pagado=pagado;
        valorado=valorado;
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
    int idEstado=widget.idEstado;
      return Scaffold(
        key:_scaffoldKey,
      body: Stack(
        children: <Widget>[
          Container(
            foregroundDecoration: BoxDecoration(
              color: Colors.black26
            ),
            height: 400,
            child: Image.asset('../LoHagoPorVosLaravel/public/storage/trabajos/$imagenTrabajo', fit: BoxFit.cover)),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16.0,bottom: 20.0),
            child: Column(
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
                            (idEstado==2 && asignado && !pagado) ? "pagar".toUpperCase() : (idEstado==5) ? "este anuncio ha finalizado".toUpperCase() : (idEstado==2 && !asignado) ? "ver postulantes".toUpperCase() : (idEstado==4 && !valorado) ? "Confirmar trabajo finalizado".toUpperCase() : "esperando postulaciones...".toUpperCase(),
                             style: TextStyle(
                            fontWeight: FontWeight.normal
                          ),),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 32.0,
                          ),
                          onPressed: () {
                            (idEstado==2 && asignado && !pagado) ? enviarDatos() : (idEstado==5) ? "este anuncio ha finalizado".toUpperCase() : (idEstado==2 && !asignado) ?  
                            Navigator.of(context).push(
                              new MaterialPageRoute(
                                  builder: (BuildContext context) => new ListaAspirantes(
                                        index: idTrabajo, 
                                      )),
                            ) : (idEstado==4 && !valorado) ? valorar() : "esperando postulaciones...".toUpperCase();
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
          ),
        ],
      ),
    );
  }
  Future enviarDatos() async {
    var data = {
        'idTrabajo' : widget.index,
        'titulo' : titulo,
        'monto' : monto,
    };

    var url = await CallApi().postData(data, 'datosMP');
    var urlDecode=jsonDecode(url.body);
    print(urlDecode);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(urlDecode)));

  }
  /*void postularse() async {
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
    
    
  }*/
  void valorar() async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Valorar(widget.index,idPersonaLogeada)));
    
  }


}
  


