import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/pages/verDetallesTrabajoOfrecido.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HistorialTrabajosPage extends StatefulWidget{
  final int idEstado;
  HistorialTrabajosPage({this.idEstado});

  @override
  State<StatefulWidget> createState() => _HistorialTrabajosPageState();
  
  
  }
  
  class _HistorialTrabajosPageState extends State<HistorialTrabajosPage> with SingleTickerProviderStateMixin{

  int idPersonaLogeada;
  
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    getPersona();
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
//busco el id de la persona que se encuentra logueada
   void getPersona() async {
   SharedPreferences localStorage = await SharedPreferences.getInstance();
    idPersonaLogeada = localStorage.getInt('idPersona');
    setState(() {
      idPersonaLogeada=idPersonaLogeada;
    });
  }
    //funcion que trae el listado de trabajos en formato json para luego decodificarlo
  Future<List> getListaTrabajos() async {
    var data = {
      "idPersona": idPersonaLogeada,
      "idEstado":widget.idEstado,
      "flutter":true,
    };
    var res = await CallApi().postData(data,'historialTrabajos');
    var listaTrabajos = json.decode(res.body);
    //print(listaTrabajos);
      return listaTrabajos;

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
    var listaTrabajos =getListaTrabajos();
    return new Scaffold(
      
      /*floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new AddData(),
            )),
      ),*/
      body: new FutureBuilder<List>(
        future: listaTrabajos,
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new ItemList(
                  list: snapshot.data,
                  idEstado: widget.idEstado,
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
  final int idEstado;
  ItemList({this.list,this.idEstado});
  State<StatefulWidget> createState() => _ItemListState();

  }

  class _ItemListState extends State<ItemList>{
  
  @override
  Widget build(BuildContext context) {
    List list= widget.list;
     final primary = Color(0xff696b9e);
  final secondary = Color(0xfff29a94);
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        var imagenTrabajo=list[i]['imagenTrabajo'];
        var monto=list[i]['monto'];
        if(list[i]['imagenTrabajo']==null){
          list[i]['imagenTrabajo']='hola.jpg';
        }
        return new Container(
          padding: const EdgeInsets.all(10.0),
          child: new GestureDetector(
            onTap: () => Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new DetallesHistorialPage(
                            index: list[i]['idTrabajo'],
                            idEstado: widget.idEstado,
                            
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
                  list[i]['titulo'],
                  style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),),
                
                leading: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 3, color: secondary),
                    image: DecorationImage(
                        image: AssetImage('assets/imagenCategoria/$imagenTrabajo'),
                        fit: BoxFit.fill),
                  ),
                ),
                subtitle:Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column( 
                    children: <Widget>[
              new Text(
                  list[i]['descripcion'],
                  style: TextStyle(
                      color: primary, fontSize: 13, letterSpacing: .3)),
               SizedBox(
                  height: 8,
                ),
              new Row(
                  children: <Widget>[
                    Icon(
                      Icons.monetization_on,
                      color: secondary,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('$monto',
                        style: TextStyle(
                            color: primary, fontSize: 13, letterSpacing: .3)),
                  ],
                ),
                    ],
              ),),),
            ),
          ),
        );
      },
    );
  }
}

