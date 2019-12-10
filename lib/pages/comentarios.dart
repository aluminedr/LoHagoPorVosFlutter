import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Comentarios extends StatefulWidget {
  final index;
  Comentarios({this.index});

  State<StatefulWidget> createState() => _ComentariosState();
}


  class _ComentariosState extends State<Comentarios> with SingleTickerProviderStateMixin{
  var idPersonaLogeada;
  var idPersonaTrabajo;
  bool esDuenio = false;
    Future<List> buscarComentarios() async {
        var data = {
          "idTrabajo": widget.index,
        };
        var res = await CallApi().postData(data,'buscarComentarios');
        var listaComentarios = json.decode(res.body);
        return listaComentarios;
    }

    void verPersonaTrabajo() async{
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      idPersonaLogeada = localStorage.getInt('idPersona');
      var data = {
            "idTrabajo": widget.index,
          };
      var res = await CallApi().postData(data,'buscarPersonaTrabajo');
      var idPersonaTrabajo = json.decode(res.body);
      if(idPersonaLogeada == idPersonaTrabajo){
        setState(() {
          esDuenio=true;
        });
      }
    }

AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    verPersonaTrabajo();
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
    var listaComentarios =buscarComentarios();
    return new Scaffold(     
      body: new FutureBuilder<List>(
        future: listaComentarios,
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new ItemList(
                  list: snapshot.data,
                  index:widget.index,
                  duenio:esDuenio,
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
  final int index;
  final bool duenio;
  ItemList({this.list, this.index, this.duenio});
  State<StatefulWidget> createState() => _ItemListState();
  }
  class _ItemListState extends State<ItemList>{
  TextEditingController comentarioController = new TextEditingController();
  Function(String) comentarioValidator = (String value){
    if(value.isEmpty){
      return "Ingrese un comentario";
    }
    return null;
  };
  @override
  Widget build(BuildContext context) {
    List list= widget.list;
    bool duenio= widget.duenio;
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: new Text("Comentarios".toUpperCase()),
      ),
      body:ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        bool hijos=true;
        List listaHijos;
        String nombreUsuario= list[i]['idPersona'][0]['nombreUsuario'];
        String comentario= list[i]['contenido'];
        int idComentario=list[i]['idComentario'];
        String fechaComentario=list[i]['created_at'];
        listaHijos= list[i]['hijos'];
        if(listaHijos.length == 0){
          hijos=false;
        }
        return new Container(
          padding: const EdgeInsets.all(10.0),
          child: new Column(
            children:
              <Widget>[
                _buildRowPadre(nombreUsuario, comentario,idComentario,duenio,fechaComentario),
                hijos ?  ListView.builder(
                  itemCount: listaHijos == null ? 0 : listaHijos.length,
                  itemBuilder: (context, i) {
                    String nombreUsuario= listaHijos[i]['idPersona'][0]['nombreUsuario'];
                    String comentario= listaHijos[i]['contenido'];
                    String fechaComentario= listaHijos[i]['created_at'];
                    return new Container(
                      padding: const EdgeInsets.all(10.0),
                      child: new Column(
                        children:
                          <Widget>[
                            _buildRowHijo(nombreUsuario, comentario,fechaComentario),
                          ],
                      ),
                    );
                  },
                  shrinkWrap: true, // todo comment this out and check the result
                  physics: ClampingScrollPhysics(), // todo comment this out and check the result
                ): 
                Container(),
              ],
          ),
        );
      },
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        _alertNuevoComentario(context);
      },
      child: Icon(Icons.add_comment,semanticLabel: "Agregar nuevo comentario",),
      backgroundColor: Colors.green,
    ),
    );
  }


  Widget _buildRowPadre(nombreUsuario,comentario,idComentario,duenio,fechaComentario) {
    return Container(
     decoration: BoxDecoration(
        color: Colors.white60,
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.0),
          bottomLeft: Radius.circular(5.0),
          topRight: Radius.circular(5.0),
          bottomRight: Radius.circular(5.0)
        ),
    ),                                 
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child:
       Column(
         children: [
            Row(
              children: <Widget>[
                Text(nombreUsuario+' dijo:',
                style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0
                            ),)
              ],
            ),
            Row(
              children: <Widget>[
                Text(comentario),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: <Widget>[
                Text('$fechaComentario',style:
                TextStyle(fontStyle: FontStyle.italic, fontWeight:FontWeight.w200))
              ],
            ),
            duenio ?
            Row(
              children: <Widget>[
                FlatButton(
                textColor: Colors.green,
                child: Text("Responder".toUpperCase()),
                onPressed: (){
                  _alertComentar(context,idComentario);
                },
              ),
              ],
            ): 
            Row(),
      ]),
    );
  }
 Widget _buildRowHijo(nombreUsuario,comentario,fechaComentario) {
    return Container(
     decoration: BoxDecoration(
        color: Colors.white60,
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.0),
          bottomLeft: Radius.circular(5.0),
          topRight: Radius.circular(5.0),
          bottomRight: Radius.circular(5.0)
        ),
    ),                                 
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child:
       Column(
         children: [
            Row(
              children: <Widget>[
                Text(nombreUsuario+' dijo:',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0
                            ),)
              ],
            ),
            Row(
              children: <Widget>[
                Text(comentario),
                Text(fechaComentario),
              ],
            ),
      ]),
    );
  }
 _alertNuevoComentario(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Deje su comentario'),
            content: TextField(
              controller: comentarioController,
              decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              hintText: "Ingrese un comentario",
                              hintStyle: TextStyle(color: Colors.green),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none
                              ),
                              filled: true,
                              fillColor: Colors.green.withOpacity(0.1),
                            ),
                            
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('cancelar'.toUpperCase()),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Container(
                color: Colors.greenAccent,
                width: 2.0,
                height: 20.0,
              ),
              new FlatButton(
                child: new Text('comentar'.toUpperCase()),
                onPressed: () {
                  crear();
                },
              )
            ],
          );
        });
  }
     _alertComentar(BuildContext context,idComentario) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Deje su comentario'),
            content: TextField(
              controller: comentarioController,
              decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              hintText: "Ingrese un comentario",
                              hintStyle: TextStyle(color: Colors.green),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none
                              ),
                              filled: true,
                              fillColor: Colors.green.withOpacity(0.1),
                            ),
                            
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('cancelar'.toUpperCase()),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Container(
                color: Colors.greenAccent,
                width: 2.0,
                height: 20.0,
              ),
              new FlatButton(
                child: new Text('comentar'.toUpperCase()),
                onPressed: () {
                  responder(idComentario);
                },
              )
            ],
          );
        });
  }
  void responder(idComentario) async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    int idPersona=localStorage.getInt('idPersona');
    var data = {
      "idComentarioPadre":idComentario,
      "idTrabajo":widget.index,
      "idPersona":idPersona,
      "contenido":comentarioController.text,
      'flutter':true,
    };  
    var res = await CallApi().postData(data, 'guardarComentario');
    var body = json.decode(res.body);
    int index=widget.index;
      if (body['success']){
        Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => Comentarios(index: index)));
      }
    }
void crear() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    int idPersona=localStorage.getInt('idPersona');
    var data = {
      "idComentarioPadre":null,
      "idTrabajo":widget.index,
      "idPersona":idPersona,
      "contenido":comentarioController.text,
      'flutter':true,
    };  
    var res = await CallApi().postData(data, 'guardarComentario');
    var body = json.decode(res.body);
    int index=widget.index;
      if (body['success']){
        Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => Comentarios(index: index)));
      }
    }

}

 

  
