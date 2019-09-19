import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class CrearPerfilPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CrearPerfilPageState();
  
  
  }

  class _CrearPerfilPageState extends State<CrearPerfilPage>{
  TextEditingController nombrePersonaController = new TextEditingController();
  TextEditingController  apellidoPersonaController = new TextEditingController();
  TextEditingController dniPersonaController = new TextEditingController();
  TextEditingController  telefonoPersonaController = new TextEditingController();
  TextEditingController idLocalidadController = new TextEditingController();
  //TextEditingController  idUsuarioController = new TextEditingController();
  
  String mensajeError='';
  var _formkey= GlobalKey<FormState>();
  
  @override
  void initState(){ // Se setea inicio
    super.initState(); // se super setea inicio
    listarProvincias();
    listarLocalidades(); // llamamos a la funcion listar Localidades
  }
//Listando provincias
 List listaProvincias;
  Future<Null> listarProvincias() async {
    var respuesta;
    final response = await http.post(
       "http://192.168.200.120/LoHagoPorVosFlutter/lib/conexion/ListarProvincias.php", // script que trae los datos
        body: {});
    setState(() {
      respuesta = json.decode(response.body); // decode
      listaProvincias = respuesta;
    });
  imprimirProvincias(); // Llamamos a la funcion que va a imprimir los datos del select
  }
  String _dropdownValuePro;  // seteamos por defecto a null
  Map<String ,String>listarProvinciaM=Map(); // Lo mapeamos

  void imprimirProvincias(){
    for(var i=0; i<listaProvincias.length;i++){ // Seteamos los valores
      listarProvinciaM[listaProvincias[i]['idProvincia']]=listaProvincias[i]['nombreProvincia'];
    }
    _dropdownValuePro=null;
  }
  //Listando localidades
  List listaLocalidades;
  Future<Null> listarLocalidades() async {
    var respuesta;
    final response = await http.post(
       "http://192.168.200.120/LoHagoPorVosFlutter/lib/conexion/ListarLocalidades.php", // script que trae los datos
        body: {});
    setState(() {
      respuesta = json.decode(response.body); // decode
      listaLocalidades = respuesta;
    });
  imprimirLocalidades(); // Llamamos a la funcion que va a imprimir los datos del select
  }
  String _dropdownValue;  // seteamos por defecto a null
  Map<String ,String>listarLocalidadM=Map(); // Lo mapeamos

  void imprimirLocalidades(){
    for(var i=0; i<listaLocalidades.length;i++){ // Seteamos los valores
      listarLocalidadM[listaLocalidades[i]['idLocalidad']]=listaLocalidades[i]['nombreLocalidad'];
    }
    _dropdownValue=null;
  }

// funcion devuelve el id (la clave) de la Localidad seleccionada
  String  mostrarIdLocalidad(){
    var usdKey=listarLocalidadM.keys.firstWhere((K)=> listarLocalidadM[K]== _dropdownValue, //Devuelve la clave del obj
      orElse: ()=>null
    );
    return usdKey;
  }



  void crear(){
    var url="http://192.168.200.120/LoHagoPorVosFlutter/lib/conexion/CrearPerfil.php";
    http.post(url,body:{
      "nombrePersona":nombrePersonaController.text,
      "apellidoPersona":apellidoPersonaController.text,
      "dniPersona":dniPersonaController.text,
      "telefonoPersona":telefonoPersonaController.text,
      "idLocalidad":mostrarIdLocalidad(), // invocamos a la funcion mostrarIdLocalidad que es la Localidad seleccionada
      //"idUsuario":idUsuarioController.text,
    });
  }
    
 Function(String) nombrePersonaValidator = (String value){
   if(value.isEmpty){
     return "Ingrese su nombre";
   }
   return null;
 };
  Function(String) apellidoPersonaValidator = (String value){
   if(value.isEmpty){
     return "Ingrese su apellido";
   }
   return null;
 };
  Function(String) dniPersonaValidator = (String value){
   if(value.isEmpty){
     return "Ingrese su DNI";
   }
   return null;
 };
  Function(String) telefonoPersonaValidator = (String value){
   if(value.isEmpty){
     return "Ingrese su telefono";
   }
   return null;
 };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Perfil"),
      ),
      resizeToAvoidBottomPadding: false,
      body: Form(
        key: _formkey,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child:  ListView(
                  children: <Widget>[
                    new Column(
                      children: <Widget>[
                        new Container(
                                padding: EdgeInsets.only(top: 77.0),
                                child: new CircleAvatar(
                                  backgroundColor: Color(0xf81f7f3),
                                  child: new Image(
                                    width: 135,
                                    height: 135,
                                    image: new AssetImage('assets/images/LoHagoPorVosLogo.png'),
                                  ),
                                ),
                                width: 170,
                                height: 170,
                      ),
                        new ListTile(
                          leading: const Icon(Icons.text_fields, color: Colors.black,),
                          title: new TextFormField(
                            controller: nombrePersonaController,
                            validator:nombrePersonaValidator,
                            decoration: new InputDecoration(
                              labelText: "Nombre",
                            ),
                          ),
                        ),
                        new ListTile(
                          leading: const Icon(Icons.text_fields, color: Colors.black,),
                          title: new TextFormField(
                            controller: apellidoPersonaController,
                            validator:apellidoPersonaValidator,
                            decoration: new InputDecoration(
                              labelText: "Apellido",
                            ),
                          ),
                        ),
                        new ListTile(
                          leading: const Icon(Icons.credit_card, color: Colors.black,),
                          title: new TextFormField(
                            controller: dniPersonaController,
                            validator:dniPersonaValidator,
                            decoration: new InputDecoration(
                              hintText: "40098234",
                              labelText: "DNI",
                            ),
                          ),
                        ),
                        new ListTile(
                          leading: const Icon(Icons.phone_android, color: Colors.black,),
                          title: new TextFormField(
                            controller: telefonoPersonaController,
                            validator:telefonoPersonaValidator,
                            decoration: new InputDecoration(
                              labelText: "Telefono",
                            ),
                          ),
                        ),
                        new ListTile(
                          leading: const Icon(Icons.text_fields, color: Colors.black,),
                          title: new DropdownButton<String>(
                            value: _dropdownValuePro,
                            hint: Text("Seleccione una provincia..."),
                            onChanged: (String newValue) {
                              setState(() {
                                _dropdownValuePro = newValue;
                              });
                            },
                            items: listarProvinciaM.values
                              .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              })
                              .toList(),
                          ),
                        ),
                        _addSecondDropdown(),

                        Padding(padding: EdgeInsets.only(top: .0),

                        ),
                        new RaisedButton(
                          child: new Text("   Finalizar   "),
                          color: Colors.green,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)
                          ),
                          onPressed: () {
                            if(_formkey.currentState.validate()){
                              crear();
                              Navigator.pop(context);
                            } 
                          },
                        ),
                        new RaisedButton(
                          child: new Text("    Borrar    "),
                          color: Colors.green,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context,"/crearperfil");
                          },
                        ),
                      ],
                    )
                  ]
            ),
              ),
            ),
        
    );
  }
  Widget _addSecondDropdown() {
    return _dropdownValuePro != null
        ? DropdownButton<String>(
            value: _dropdownValue,
            items: listarLocalidadM.values
                              .map((value) =>DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value)
                              ))
                              .toList(),
            onChanged: (newValue) {
              setState(() {
                _dropdownValue = newValue;
              });
            })
        : Container(); // Return an empty Container instead.
  }
}
