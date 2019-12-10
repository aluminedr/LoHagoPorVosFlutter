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
  int idPersonaLogueada;
  
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
    verPersonaLog();
    super.dispose();
  }
void verPersonaLog() async{
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      idPersonaLogueada = localStorage.getInt('idPersona');
        setState(() {
          idPersonaLogueada=idPersonaLogueada;
        });
      }
    //funcion que trae el listado de aspirantes en formato json para luego decodificarlo
  Future<List> getListaConversaciones() async {
    var data = {
      "idPersona": idPersonaLogueada,
    };
    var res = await CallApi().postData(data,'listarConversaciones');
    var listaConversaciones = json.decode(res.body);
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
                  idPersonaLogueada: idPersonaLogueada,
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
  final int idPersonaLogueada;
  ItemList({this.list,this.idPersonaLogueada});
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
    int idPersonaLogueada= widget.idPersonaLogueada;
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        String nombrePersona = (idPersonaLogueada == list[i]['idPersona1']) ? list[i]['persona1'][0]['nombrePersona']+' '+list[i]['persona1'][0]['apellidoPersona'] : list[i]['persona2'][0]['nombrePersona']+' '+list[i]['persona2'][0]['apellidoPersona'];
        String imagenPersona = (idPersonaLogueada == list[i]['idPersona1']) ? list[i]['persona1'][0]['imagenPersona'] : list[i]['persona2'][0]['imagenPersona'];
        return new Container(
          decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0)
                                  )
                                ),
          
          padding: const EdgeInsets.all(10.0),            
            child:new GestureDetector(
            onTap: () => Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new ChatScreen(
                            idConversacion: list[i]['idConversacionChat'],
                            deshabilitado: list[i]['deshabilitado'],                           
                          )),
                ), 
            child: new Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            children: <Widget>[
              new Container(
                margin:const EdgeInsets.only(right: 16.0),
                child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                        image: AssetImage('assets/imagenPerfil/$imagenPersona'),
                        fit: BoxFit.fill),
                  ),
                ),
                  
              ),
              new Expanded(                                             
                child: new Column(  
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection:TextDirection.ltr, 
                children: <Widget>[
                  new Text('$nombrePersona', style: TextStyle(fontWeight:FontWeight.bold)),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text('Toca aquí para continuar conversando'),
                  ),
            ],
          ),
              ),
        ],
            
      ),
        
      ),
            ),
        );
      },
    );
    
  }
}