import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';




class DetallesTrabajosPage extends StatefulWidget{
  final index;
  DetallesTrabajosPage({Key key, this.index}) : super(key: key);

  @override
  _DetallesTrabajosPageState createState() => _DetallesTrabajosPageState();
}

class _DetallesTrabajosPageState extends State<DetallesTrabajosPage> {
  String titulo;
  String descripcion;
  int monto;
  String imagen;
  int idPersonaTrabajo;
  int idPersonaLogeada;

  @override
   void initState(){
    _getDetalles();
    super.initState();
  }
  void _getDetalles() async {
    var data ={
      'idTrabajo': widget.index,
    };
    var res = await CallApi().postData(data,'detalleTrabajo');
    var trabajo = json.decode(res.body);
    var trabajoDetalle= trabajo[0];
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    idPersonaLogeada = localStorage.getInt('idPersona');
    setState(() {
        titulo= trabajoDetalle['titulo'];
        descripcion= trabajoDetalle['descripcion'];
        monto= trabajoDetalle['monto'];
        imagen= trabajoDetalle['imagen'];
        idPersonaTrabajo= trabajoDetalle['idPersona'];
      }); 
  }

  Widget build(BuildContext context) {
      return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            foregroundDecoration: BoxDecoration(
              color: Colors.black26
            ),
            height: 400,
            child: Text("$imagen")),//Image.asset(imagen, fit: BoxFit.cover)),
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
                      color: Colors.white,
                      icon: Icon(Icons.favorite_border),
                      onPressed: () {},
                    )
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
                          child:Text((idPersonaTrabajo == idPersonaLogeada) ? "Pagar".toUpperCase():"Postularme".toUpperCase(), style: TextStyle(
                            fontWeight: FontWeight.normal
                          ),),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 32.0,
                          ),
                          onPressed: () {
                            (idPersonaTrabajo == idPersonaLogeada) ? "Pagar".toUpperCase():"Postularme".toUpperCase();
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
}
  
