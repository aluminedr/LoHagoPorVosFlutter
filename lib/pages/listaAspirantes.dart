import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/pages/misTrabajos.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';



class ListaAspirantes extends StatefulWidget{
  final index;
  ListaAspirantes({this.index});

  @override
  _ListaAspirantesState createState() => _ListaAspirantesState();
}

class _ListaAspirantesState extends State<ListaAspirantes> with SingleTickerProviderStateMixin{
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
  Future<List> getListaAspirantes() async {
    var data = {
      "idTrabajo": widget.index,
    };
    var res = await CallApi().postData(data,'listarAspirantesTrabajo');
    var listaAspirantes = json.decode(res.body);
    //print(listaAspirantes);
    return listaAspirantes;

  }
  
  // void _handleTap() {
  //   setState(() {
  //     // valueAnimation.isAnimating is part of our build state
  //     if (_controller.isAnimating) {
  //       _controller.stop();
  //     } else {
  //       switch (_controller.status) {
  //         case AnimationStatus.dismissed:
  //         case AnimationStatus.forward:
  //           _controller.forward();
  //           break;
  //         case AnimationStatus.reverse:
  //         case AnimationStatus.completed:
  //           _controller.reverse();
  //           break;
  //       }
  //     }
  //   });
  // }
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
    var listaAspirantes =getListaAspirantes();
    return new Scaffold(
      
      /*floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new AddData(),
            )),
      ),*/
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: new Text("Lista de aspirantes"),
      ),
      body: new FutureBuilder<List>(
        future: listaAspirantes,
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new ItemList(
                  list: snapshot.data,
                  idTrabajo: widget.index,
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
  final int idTrabajo;
  ItemList({this.list,this.idTrabajo});
  @override
  State<StatefulWidget> createState() => _ItemListState();
  
  
  }
  
  class _ItemListState extends State<ItemList>{

  void initState(){
    //verPersonaTrabajo();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    List list=widget.list;
    final primary = Color(0xff696b9e);
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        var localidad= list[i][0]['idLocalidad'][0]['nombreLocalidad']; //busque y traje obj localidad dentro de idLocalidad por eso se accede con [idLocalidad][0]
        var habilidad1= list[i][0]['habilidades'][0]['idHabilidad'][0]['nombreHabilidad']; //busque y traje obj habilidadPersona dentro de habilidad por eso se accede con [habilidad][0] y dentro esta el obj habilidad por eso [idHabilidad][0][nombreHabilidad]
        var habilidad2= list[i][0]['habilidades'][1]['idHabilidad'][0]['nombreHabilidad']; //busque y traje obj habilidadPersona dentro de habilidad por eso se accede con [habilidad][0] y dentro esta el obj habilidad por eso [idHabilidad][0][nombreHabilidad]
        var habilidad3= list[i][0]['habilidades'][2]['idHabilidad'][0]['nombreHabilidad']; //busque y traje obj habilidadPersona dentro de habilidad por eso se accede con [habilidad][0] y dentro esta el obj habilidad por eso [idHabilidad][0][nombreHabilidad]
        var rating= list[i][0]['valoracion']+.0;
        //if(rating)
        //print(rating);
        return new Container(
          padding: const EdgeInsets.all(10.0),            
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
                  list[i][0]['nombrePersona']+' '+list[i][0]['apellidoPersona'],
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
                        image: AssetImage('assets/trabajo/'+list[i][0]['imagenTrabajo']),
                        fit: BoxFit.fill),
                  ),
                ),
                subtitle:Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column( 
                    children: <Widget>[
                      Row(
                            children: <Widget>[
                              Center(
                                  child: SmoothStarRating(
                                    allowHalfRating: false,
                                    color: Colors.green,
              borderColor: Colors.purple,
                                    rating: rating,
                                    size: 20,
                                    starCount: 5,
                                  )
                                  ),
                                ],
                          ),
                      new Row(
                        children: <Widget>[
                          new Icon(Icons.my_location),
                          SizedBox(
                            width: 5,
                          ),
                          new Text(
                              '$localidad',
                                style: TextStyle(
                                      color: primary, fontSize: 13, letterSpacing: .3)),
                                    
                            SizedBox(
                                height: 8,
                              ),
                                    ],),
                                    SizedBox(
                                height: 8,
                              ),
                      new Row(
                        children: <Widget>[
                          new Text(
                              'Habilidades:',
                                style: TextStyle(
                                      color: primary, fontSize: 13, letterSpacing: .3)),           
                                    ],),
                                    SizedBox(
                            width: 5,
                            height: 8,
                          ),
                      new Row(
                        children: <Widget>[
                          new Icon(Icons.keyboard_arrow_right),
                          SizedBox(
                            width: 5,
                          ),
                          new Text(
                              '$habilidad1',
                                style: TextStyle(
                                      color: primary, fontSize: 13, letterSpacing: .3)),           
                                    ],),
                        new Row(
                        children: <Widget>[
                          new Icon(Icons.keyboard_arrow_right),
                          SizedBox(
                            width: 5,
                          ),
                          new Text(
                              '$habilidad2',
                                style: TextStyle(
                                      color: primary, fontSize: 13, letterSpacing: .3)),    
                                    ],),
                                    new Row(
                        children: <Widget>[
                          new Icon(Icons.keyboard_arrow_right),
                          SizedBox(
                            width: 5,
                          ),
                          new Text(
                              '$habilidad3',
                                style: TextStyle(
                                      color: primary, fontSize: 13, letterSpacing: .3)),   
                                    ],),
                        new Row(
                            children: <Widget>[                                                                                                                                 
                              RaisedButton(
                                child: new Text('Asignar trabajo'.toUpperCase()),
                                    color: Colors.green,
                                    textColor: Colors.white,
                                    padding: const EdgeInsets.all(2.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0)
                                    ),
                                onPressed: () {
                                elegirAspirante(list[i][0]['idPersona'],widget.idTrabajo);
                              },
                              ),
                            ],
                          ),
                        
                    ],
              ),),),
            ),
        );
      },
    );
    
  }
  void elegirAspirante(idPersona,idTrabajo) async {
    var data = {
      "idTrabajo":idTrabajo,
      "idPersona":idPersona,
      "flutter": true,
    };  
    var res = await CallApi().postData(data, 'elegirAspirante');
    var body = json.decode(res.body);
      if (body['success']){
        Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => MisTrabajos()));
      }
    }
}

