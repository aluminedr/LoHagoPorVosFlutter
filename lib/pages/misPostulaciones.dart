import 'package:flutter/material.dart';
import 'package:flutter_app/pages/trabajosRealizados.dart';

class MisPostulaciones extends StatefulWidget {
  @override
  _MisPostulacionesState createState() => _MisPostulacionesState();
}

class _MisPostulacionesState extends State<MisPostulaciones> with SingleTickerProviderStateMixin{

  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.green,
        title: new Text("Trabajos realizados"),
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.purple,
          tabs: [
          new Tab(
            text: 'POSTULADOS',
          ),
          new Tab(
            text: 'ASIGNADOS',
          ),
          new Tab(
            text: 'FINALIZADOS',
          )
        ],
        controller: _tabController,
        indicatorColor: Colors.purple,
        indicatorSize: TabBarIndicatorSize.tab,),
        bottomOpacity: 1,
      ),
      body: TabBarView(
        children: [
          new TrabajosRealizados(idEstado: 1),
          new TrabajosRealizados(idEstado: 2),
          new TrabajosRealizados(idEstado: 3),
        ],
      controller: _tabController,),
    );
  }
}