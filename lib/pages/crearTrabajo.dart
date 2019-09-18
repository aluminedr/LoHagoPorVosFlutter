import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class CrearTrabajoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CrearTrabajoPageState();
  
  
  }

  class _CrearTrabajoPageState extends State<CrearTrabajoPage>{
  TextEditingController descripcionController = new TextEditingController();
  TextEditingController  montoController = new TextEditingController();
  //TextEditingController  idCategoriaTrabajoController = new TextEditingController();
  
  String mensajeError='';
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
       "http://192.168.1.36/LoHagoPorVosFlutter/lib/conexion/ListarCategorias.php", // script que trae los datos
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
  String  mostrarIdCategoria()
{
var usdKey=listarCategoriaM.keys.firstWhere((K)=> listarCategoriaM[K]== _dropdownValue, //Devuelve la clave del obj
orElse: ()=>null
);
return usdKey;
}



  void crear(){
    var url="http://192.168.1.36/LoHagoPorVosFlutter/lib/conexion/NuevoTrabajo.php";
    http.post(url,body:{
      "descripcion":descripcionController.text,
      "monto":montoController.text,
      "idCategoriaTrabajo":mostrarIdCategoria(), // invocamos a la funcion mostrarIdCategoria que es la categoria seleccionada
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
                            controller: descripcionController,
                            validator:descripcionValidator,
                            decoration: new InputDecoration(
                              labelText: "Descripcion",
                            ),
                          ),
                        ),
                        new ListTile(
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
                        new ListTile(
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
                    )
                  ]
            ),
              ),
            ),
        
    );
  }
}
