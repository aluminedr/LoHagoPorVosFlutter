import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart'; 
import 'package:flutter_app/api/api.dart';
import 'dart:convert';

import '../main.dart';

class Valorar extends StatefulWidget{
  final idPersonaLogeada;
  final idTrabajo;
  Valorar(this.idPersonaLogeada, this.idTrabajo);

  @override
  _ValorarState createState() => _ValorarState();
}

class _ValorarState extends State<Valorar> {

  var rating = 0.0;

   void initState(){
    buscarDatosPostulacion();
    super.initState();  
  }

 @override
 Widget build(BuildContext context) {
    print(widget.idTrabajo);
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: new Text('Valorar'),
      ),
        body: Container(
          child: Column(children: <Widget>[
            Center(
            child: SmoothStarRating(
              rating: rating,
              size: 45,
              starCount: 5,
              onRatingChanged: (value) {
                setState(() {
                  rating = value;
                });
              },
            )
            ),
            SizedBox(
              width: double.infinity,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                          color: Colors.purple,
                          textColor: Colors.white,
                          child:Text(
                            "Valorar", 
                            style: TextStyle(
                            fontWeight: FontWeight.normal
                          ),),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 32.0,
                          ),
                          onPressed: () {
                            enviarValoracion();
                          },
                        ),
                      ),
          ],)
        )
    );
 }
 void enviarValoracion () async{
    var idPersonaLogeada = widget.idPersonaLogeada;
    var idTrabajo = widget.idTrabajo;
    var valor = rating;
    var data = {
            'idPersonaLogeada':idPersonaLogeada,
            'idTrabajo':idTrabajo,
            'valor':valor,
            'flutter':true,
    };
    var res = await CallApi().postData(data, 'enviarValoracion');
    var body = json.decode(res.body);
    if (body['success']){
      Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => LoHagoPorVos()));
      }
 }

 void buscarDatosPostulacion() async {
    var idTrabajo = widget.idTrabajo;
    var data = {
      'idTrabajo':idTrabajo,
    };

    var res = await CallApi().postData(data, 'buscarDatosPostulacion');
    var body = json.decode(res.body);
    print(body);
 }
}
