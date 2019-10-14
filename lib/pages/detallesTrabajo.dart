import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';




class DetallesTrabajosPage extends StatefulWidget{
  final index;
  DetallesTrabajosPage({Key key, this.index}) : super(key: key);

  @override
  _DetallesTrabajosPageState createState() => _DetallesTrabajosPageState();
}

class _DetallesTrabajosPageState extends State<DetallesTrabajosPage> {
  Future getDetalles() async {
    var data ={
      'idTrabajo': widget.index,
    };
    var res = await CallApi().postData(data,'detalleTrabajo');
    var trabajo = json.decode(res.body);
    print(trabajo);
    return trabajo;
  }

  Widget build(BuildContext context) {
    var trabajo= getDetalles();
        return Scaffold(
          appBar: AppBar(
            title: new Text('Hello, $trabajo! How are you?'),
      ),

    );
  }
}
  
