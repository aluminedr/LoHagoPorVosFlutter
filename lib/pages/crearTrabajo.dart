import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class CrearTrabajoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CrearTrabajoPageState();
  
  
  }
  
  class _CrearTrabajoPageState extends State<CrearTrabajoPage>{
  TextEditingController descripcionController = new TextEditingController();
  TextEditingController  montoController = new TextEditingController();
  String mensajeError='';
  var _formkey= GlobalKey<FormState>();

  Future<List> traerCategorias() async {
    final respuesta = await http.post("http://192.168.1.39/LoHagoPorVosFlutter/lib/conexion/ListarCategorias.php",
                                                                              

    var datosUsuario= json.decode(respuesta.body);
    return datosUsuario;
  }
  void crear(){
    var url="http://192.168.1.39/LoHagoPorVosFlutter/lib/conexion/NuevoTrabajo.php";
    http.post(url,body:{
      "descripcion":descripcionController.text,
      "monto":montoController.text,
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
                          leading: const Icon(Icons.person, color: Colors.black,),
                          title: new TextFormField(
                            controller: descripcionController,
                            validator:descripcionValidator,
                            decoration: new InputDecoration(
                              labelText: "Descripcion",
                            ),
                          ),
                        ),
                        new ListTile(
                          leading: const Icon(Icons.mail, color: Colors.black,),
                          title: new TextFormField(
                            controller: montoController,
                            validator:montoValidator,
                            decoration: new InputDecoration(
                              hintText: "500",
                              labelText: "Monto",
                            ),
                          ),
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
                          child: new Text("  Borrar  "),
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
