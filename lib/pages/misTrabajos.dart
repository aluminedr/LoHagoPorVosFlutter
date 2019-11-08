import 'package:flutter/material.dart';
import 'package:flutter_app/pages/verHistorial.dart';

class MisTrabajos extends StatefulWidget {
  @override
  _MisTrabajosState createState() => _MisTrabajosState();
}

class _MisTrabajosState extends State<MisTrabajos> with SingleTickerProviderStateMixin{

  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.green,
        title: new Text("Trabajos ofrecidos"),
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.purple,
          tabs: [
          new Tab(
            text: 'PUBLICADOS',
          ),
          new Tab(
            text: 'EXPIRADOS',
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
          new HistorialTrabajosPage(idEstado: 1),
          new HistorialTrabajosPage(idEstado: 2),
          new HistorialTrabajosPage(idEstado: 4),
          new HistorialTrabajosPage(idEstado: 5),
        ],
      controller: _tabController,),
    );
  }
}