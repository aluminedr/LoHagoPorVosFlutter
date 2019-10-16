import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/pages/detallesTrabajo.dart';
import 'package:http/http.dart' as http;


class ListarTrabajosPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ListarTrabajosPageState();
  
  
  }
  
  class _ListarTrabajosPageState extends State<ListarTrabajosPage> with SingleTickerProviderStateMixin{
  //funcion que trae el listado de trabajos en formato json para luego decodificarlo
  Future<List> getListaTrabajos() async {
    
    var res = await CallApi().listarTrabajos('listarTrabajos');
    var listaTrabajos = json.decode(res.body);
    return listaTrabajos;

  }
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

  void _handleTap() {
    setState(() {
      // valueAnimation.isAnimating is part of our build state
      if (_controller.isAnimating) {
        _controller.stop();
      } else {
        switch (_controller.status) {
          case AnimationStatus.dismissed:
          case AnimationStatus.forward:
            _controller.forward();
            break;
          case AnimationStatus.reverse:
          case AnimationStatus.completed:
            _controller.reverse();
            break;
        }
      }
    });
  }
Widget _buildIndicators(BuildContext context, Widget child) {
    final List<Widget> indicators = <Widget>[
      const SizedBox(
        width: 200.0,
        child: LinearProgressIndicator(),
      ),
      const LinearProgressIndicator(),
      const LinearProgressIndicator(),
      LinearProgressIndicator(value: _animation.value),
      /*Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const CircularProgressIndicator(),
          SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(value: _animation.value),
          ),
          SizedBox(
            width: 100.0,
            height: 20.0,
            child: Text('${(_animation.value * 100.0).toStringAsFixed(1)}%',
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),*/
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

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          padding: const EdgeInsets.all(10.0),
          child: new GestureDetector(
            onTap: () => Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new DetallesTrabajosPage(
                            index: list[i]['idTrabajo'],
                            
                          )),
                ),
            
            child: new Card(
              child: new ListTile(
                title: new Text(
                  list[i]['titulo'],
                  style: TextStyle(fontSize: 20.0, color: Colors.purple),
                ),
                /*
                leading: new Icon(
                  Icons.person_pin,
                  size: 77.0,
                  color: Colors.orangeAccent,
                ),
                */
                subtitle: 
                new Text(
                  list[i]['descripcion'],
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

