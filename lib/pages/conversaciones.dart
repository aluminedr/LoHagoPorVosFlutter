import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/pages/chatScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ListaConversaciones extends StatefulWidget{


  @override
  _ListaConversacionesState createState() => _ListaConversacionesState();
}

class _ListaConversacionesState extends State<ListaConversaciones> with SingleTickerProviderStateMixin{
  AnimationController _controller;
  Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
    )..forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.9, curve: Curves.fastOutSlowIn),
      reverseCurve: Curves.fastOutSlowIn,
    )..addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.dismissed)
        _controller.forward();
      else if (status == AnimationStatus.completed)
        _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.stop();
    super.dispose();
  }

    //funcion que trae el listado de aspirantes en formato json para luego decodificarlo
  Future<List> getListaConversaciones() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    int idPersonaLogeada = localStorage.getInt('idPersona');
    var data = {
      "idPersona": idPersonaLogeada,
    };
    var res = await CallApi().postData(data,'listarConversaciones');
    var listaConversaciones = json.decode(res.body);
    //print(listaConversaciones);
    return listaConversaciones;

  }
  

Widget _buildIndicators(BuildContext context, Widget child) {
    final List<Widget> indicators = <Widget>[
      const SizedBox(
        width: 200.0,
        child: LinearProgressIndicator(),
      ),
      const LinearProgressIndicator(),
      const LinearProgressIndicator(),
    ];
    return Column(
      children: indicators
        .map<Widget>((Widget c) => Container(child: c, margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0)))
        .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var listaConversaciones =getListaConversaciones();
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: new Text("Conversaciones"),
      ),
      body: new FutureBuilder<List>(
        future: listaConversaciones,
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new ItemList(
                  list: snapshot.data,
                )
              : new Center(
                  child:Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: _buildIndicators,
                  ),
                  ),        
                );
        },
      ),
    );
  }
}

class ItemList extends StatefulWidget {
  final List list;
  ItemList({this.list});
  @override
  State<StatefulWidget> createState() => _ItemListState();
  
  
  }
  
  class _ItemListState extends State<ItemList>{

  void initState(){
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    List list=widget.list;
    final primary = Color(0xff696b9e);
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          padding: const EdgeInsets.all(10.0),            
            child:new GestureDetector(
            onTap: () => Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new ChatScreen(
                            idConversacion: list[i]['idConversacionChat'],                           
                          )),
                ), 
            child: new Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
              child: new ListTile(
                title:Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: new Text(
                  'hola',//list[i][0]['nombrePersona']+' '+list[i][0]['apellidoPersona'],
                  style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),),
                
                leading:Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 3, color: Colors.purple),
                    image: DecorationImage(
                        image: AssetImage('../LoHagoPorVosLaravel/public/storage/perfil/'/*+list[i][0]['imagenTrabajo']*/),
                        fit: BoxFit.fill),
                  ),
                ),
                subtitle:Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column( 
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          new Icon(Icons.chat),
                          SizedBox(
                            width: 5,
                          ),
                      ],),                  
                    ],
              ),),
            ),
        )
            ),
        );
      },
    );
    
  }
}

