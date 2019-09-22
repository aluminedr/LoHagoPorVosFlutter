import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class CrearTrabajoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CrearTrabajoPageState();
  
  
  }

  class _CrearTrabajoPageState extends State<CrearTrabajoPage>{
  TextEditingController descripcionController = new TextEditingController();
  TextEditingController  montoController = new TextEditingController();
  //TextEditingController  idCategoriaTrabajoController = new TextEditingController();
  
  String mensajeError='';
  String idUsuario;
  var _formkey= GlobalKey<FormState>();
  
  @override
  void initState(){ // Se setea inicio
    super.initState(); // se super setea inicio
    listarCategorias(); // llamamos a la funcion listar categorias
  }

  List listaCategorias;
  Future<Null> listarCategorias() async {
    var respuesta;
    final response = await http.post(
       "http://192.168.1.36/LoHagoPorVosFlutter/lib/conexion/Listas/ListarCategorias.php", // script que trae los datos
        body: {});
    setState(() {
      respuesta = json.decode(response.body); // decode
      listaCategorias = respuesta;
    });
  imprimirCategorias(); // Llamamos a la funcion que va a imprimir los datos del select
  }
  String _dropdownValue;  // seteamos por defecto a null
  Map<String ,String>listarCategoriaM=Map(); // Lo mapeamos

  void imprimirCategorias(){
    for(var i=0; i<listaCategorias.length;i++){ // Seteamos los valores
      listarCategoriaM[listaCategorias[i]['idCategoriaTrabajo']]=listaCategorias[i]['nombreCategoriaTrabajo'];
    }
    _dropdownValue=null;
  }

// funcion devuelve el id (la clave) de la categoria seleccionada
  String  mostrarIdCategoria(){
    var usdKey=listarCategoriaM.keys.firstWhere((K)=> listarCategoriaM[K]== _dropdownValue, //Devuelve la clave del obj
      orElse: ()=>null
    );
    return usdKey;
  }



  void crear(){
    var url="http://192.168.1.36/LoHagoPorVosFlutter/lib/conexion/Trabajo/NuevoTrabajo.php";
    http.post(url,body:{
      "descripcion":descripcionController.text,
      "monto":montoController.text,
      "idCategoriaTrabajo":mostrarIdCategoria(), // invocamos a la funcion mostrarIdCategoria que es la categoria seleccionada
      "idUsuario":idUsuario,
    });
  }
    
 Function(String) descripcionValidator = (String value){
   if(value.isEmpty){
     return "Ingrese una descripcion";
   }
   return null;
 };
  Function(String) montoValidator = (String value){
   if(value.isEmpty){
     return "Ingrese un monto";
   }
   return null;
 };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Publicar un trabajo"),
      ),
      resizeToAvoidBottomPadding: false,
      body: Form(
        key: _formkey,
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child:  ListView(
                  children: <Widget>[
                    new Column(
                      children: <Widget>[
                        new Container(
                                padding: EdgeInsets.only(top: 10.0),
                                child: new CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: new Image(
                                    width: 135,
                                    height: 135,
                                    image: new AssetImage('assets/images/LoHagoPorVosLogo.png'),
                                  ),
                                ),
                                width: 150,
                                height: 150,
                      ),
                      Container(
                              width: MediaQuery.of(context).size.width/1.2,
                              height: 60,
                              margin: EdgeInsets.only(
                                top: 10,
                              ),
                              padding: EdgeInsets.only(
                                top: 4, left: 16,right: 16,bottom: 4
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                color: Colors.grey,
                                boxShadow: [BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5
                                )]
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.text_fields, color: Colors.black,),
                                title: new TextFormField(
                                  controller: descripcionController,
                                  validator:descripcionValidator,
                                  decoration: new InputDecoration(
                                    labelText: "Titulo",
                                  ),
                                ),
                              ),
                            ),
                             Container(
                              width: MediaQuery.of(context).size.width/1.2,
                              height: 60,
                              margin: EdgeInsets.only(
                                top: 10,
                              ),
                              padding: EdgeInsets.only(
                                top: 4, left: 16,right: 16,bottom: 4
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                color: Colors.grey,
                                boxShadow: [BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5
                                )]
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.text_fields, color: Colors.black,),
                                title: new TextFormField(
                                  controller: descripcionController,
                                  validator:descripcionValidator,
                                  decoration: new InputDecoration(
                                    labelText: "Descripcion",
                                  ),
                                ),
                              ),
                            ),
                             Container(
                              width: MediaQuery.of(context).size.width/1.2,
                              height: 60,
                              margin: EdgeInsets.only(
                                top: 10,
                              ),
                              padding: EdgeInsets.only(
                                top: 4, left: 16,right: 16,bottom: 4
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                color: Colors.grey,
                                boxShadow: [BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5
                                )]
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.monetization_on, color: Colors.black,),
                                title: new TextFormField(
                                  controller: montoController,
                                  validator:montoValidator,
                                  decoration: new InputDecoration(
                                    hintText: "500",
                                    labelText: "Monto",
                                  ),
                                ),
                              ),
                            ),
                             Container(
                              width: MediaQuery.of(context).size.width/1.2,
                              height: 60,
                              margin: EdgeInsets.only(
                                top: 10,
                              ),
                              padding: EdgeInsets.only(
                                top: 4, left: 16,right: 16,bottom: 4
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                color: Colors.grey,
                                boxShadow: [BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5
                                )]
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.text_fields, color: Colors.black,),
                                title: new DropdownButton<String>(
                                  value: _dropdownValue,
                                  hint: Text("Seleccione una categoria..."),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _dropdownValue = newValue;
                                    });
                                  },
                                  items: listarCategoriaM.values
                                    .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    })
                                    .toList(),
                                ),
                              ),
                            ),
                        
                        Padding(padding: EdgeInsets.only(top: .0),

                        ),
                        new RaisedButton(
                          child: new Text("  Publicar  "),
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
                            Navigator.pushReplacementNamed(context,"/creartrabajo");
                          },
                        ),
                      ],
                    ),
                  ]),
    )));
        

  }

  leerDatosUsuario() async { // Leemos los datos del usuario que estan cargado en preference
                  final prefs = await SharedPreferences.getInstance();
                  setState((){
                    
                    idUsuario = prefs.getString("idUsuario");
                    print(idUsuario);
                    
                  });
                }
}