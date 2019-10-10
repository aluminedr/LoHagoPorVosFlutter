import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Img;
import 'dart:math' as Math;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';


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
  var idUsuario;
  bool _cargando = false;
  String mensajeError='';
  var _formkey= GlobalKey<FormState>();
  var idProvincia;

  File _image;
  @override
  void initState(){ // Se setea inicio
    super.initState(); // se super setea inicio
    listarProvincias();
    _getUserInfo();
  }

  void _getUserInfo() async {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var userJson = localStorage.getString('user');
      var user = json.decode(userJson);
      setState(() {
        idUsuario= user['idUsuario'];
      });

  }
 
  List listaProvincias;
  Future<Null> listarProvincias() async {

    final response = await CallApi().listarProvincias('listarProvincias');
    setState(() {
      listaProvincias = json.decode(response.body);
    });
  imprimirProvincias(); // Llamamos a la funcion que va a imprimir los datos del select
  }
  String _dropdownValuePro;  // seteamos por defecto a null
  Map<int,String>listarProvinciaM=Map(); // Lo mapeamos y le indicamos que es clave int y valor string

  void imprimirProvincias(){
    for(var i=0; i<listaProvincias.length;i++){ // Seteamos los valores
      listarProvinciaM[listaProvincias[i]['idProvincia']]=listaProvincias[i]['nombreProvincia'];
    }
    _dropdownValuePro=null;
  }

// funcion devuelve el id (la clave) de la provincia seleccionada
  int  mostrarIdProvincia(){
    var usdKey=listarProvinciaM.keys.firstWhere((K)=> listarProvinciaM[K]== _dropdownValuePro, //Devuelve la clave del obj
      orElse: ()=>null
    );
    return usdKey;
  }
  
  //Listando localidades
  List listaLocalidades;
  void listarLocalidades(idProvincia) async {
      var data ={
        "idProvincia":idProvincia
      };
    var response = await CallApi().listarLocalidades(data,'listarLocalidades');    
    setState(() {
      listaLocalidades = json.decode(response.body); // decode
    });
  imprimirLocalidades(); // Llamamos a la funcion que va a imprimir los datos del select
  }
  String _dropdownValue;  // seteamos por defecto a null
  Map<int ,String>listarLocalidadM=Map(); // Lo mapeamos

  void imprimirLocalidades(){
    listarLocalidadM.clear(); // Limpiamos el map para que imprima las localidades desde 0
    for(var i=0; i<listaLocalidades.length;i++){ // Seteamos los valores
      listarLocalidadM[listaLocalidades[i]['idLocalidad']]=listaLocalidades[i]['nombreLocalidad'];
    }
    _dropdownValue=null;
  }

// funcion devuelve el id (la clave) de la Localidad seleccionada
  int  mostrarIdLocalidad(){
    var usdKey=listarLocalidadM.keys.firstWhere((K)=> listarLocalidadM[K]== _dropdownValue, //Devuelve la clave del obj
      orElse: ()=>null
    );
    return usdKey;
  }

 

  Future getImageGallery() async{
  var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

  final tempDir =await getTemporaryDirectory();
  final path = tempDir.path;

  int rand= new Math.Random().nextInt(100000);

  Img.Image image= Img.decodeImage(imageFile.readAsBytesSync());
  Img.Image smallerImg = Img.copyResize(image, width:120, height:120);

  var compressImg= new File("$path/image_$rand.jpg")
  ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));

  setState(() {
      _image = compressImg;
    });
}

Future getImageCamera() async{
  var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

  final tempDir =await getTemporaryDirectory();
  final path = tempDir.path;

  int rand= new Math.Random().nextInt(100000);

  Img.Image image= Img.decodeImage(imageFile.readAsBytesSync());
  Img.Image smallerImg = Img.copyResize(image, width:120, height:120);

  var compressImg= new File("$path/image_$rand.jpg")
  ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));


  setState(() {
      _image = compressImg;
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

 ScaffoldState scaffoldState;
  _mostrarMensaje(msg) async {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label : 'Cerrar',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
   }

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
                      Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: 50,
                    margin: EdgeInsets.only(
                      top: 32,
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
                            controller: nombrePersonaController,
                            validator:nombrePersonaValidator,
                            decoration: new InputDecoration(
                              labelText: "Nombre",
                            ),
                          ),
                        ),
                      ),
                      Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: 50,
                    margin: EdgeInsets.only(
                      top: 32,
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
                            controller: apellidoPersonaController,
                            validator:apellidoPersonaValidator,
                            decoration: new InputDecoration(
                              labelText: "Apellido",
                            ),
                          ),
                        ),
                      ),
                      Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: 50,
                    margin: EdgeInsets.only(
                      top: 32,
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
                      ),
                      Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: 50,
                    margin: EdgeInsets.only(
                      top: 32,
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
                          leading: const Icon(Icons.phone_android, color: Colors.black,),
                          title: new TextFormField(
                            controller: telefonoPersonaController,
                            validator:telefonoPersonaValidator,
                            decoration: new InputDecoration(
                              labelText: "Telefono",
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
              child: Column(
          children: <Widget>[
            Center(
              child: _image==null
              ? new Text("Seleccione una imagen")
              : new Image.file(_image),
            ),

            
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Icon(Icons.image),
                  onPressed: getImageGallery,
                ),
                 RaisedButton(
                  child: Icon(Icons.camera_alt),
                  onPressed: getImageCamera,
                ),
                Expanded(child: Container(),),
                 

              ],
            ),
          ],
        ),
      ),
                      Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: 50,
                    margin: EdgeInsets.only(
                      top: 32,
                    ),
                    padding: EdgeInsets.only(
                      top: 4, left: 16,right: 0,bottom: 4
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
                          leading: const Icon(Icons.map, color: Colors.black,),
                          title: new DropdownButton<String>(
                            isExpanded: true,
                            elevation: 1,
                            value: _dropdownValuePro,
                            hint: Text("Seleccione una provincia.."),
                            onChanged: (String newValue) {
                              setState(() {
                                _dropdownValuePro = newValue;
                                var idProvinciaSeleccionada = mostrarIdProvincia();
                              listarLocalidades(idProvinciaSeleccionada);
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
                      ),
                        _addSecondDropdown(),

                        Padding(padding: EdgeInsets.only(top: .0),

                        ),
                        new RaisedButton(
                          child: new Text(_cargando ? 'Creando' : 'Guardar datos'),
                          color: Colors.green,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)
                          ),
                          onPressed: () {
                            _cargando ? null : _crearPerfil(); 
                            } 
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
              
        return Container(
          width: MediaQuery.of(context).size.width/1.2,
                    height: 50,
                    margin: EdgeInsets.only(
                      top: 32,
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
                          leading: const Icon(Icons.map, color: Colors.black,),
                          title: _dropdownValuePro != null
          ? DropdownButton<String>(
              value: _dropdownValue,
              isExpanded: true,
              hint:Text("Seleccione una localidad.."),
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
          : Container(),
        )); // Return an empty Container instead.
  }
  
  void _crearPerfil() async {
    setState(() {
       _cargando = true;
    });
    String imagenPerfil= base64Encode(_image.readAsBytesSync()); 
    var data = {
      "idUsuario":idUsuario,
      "nombrePersona":nombrePersonaController.text,
      "apellidoPersona":apellidoPersonaController.text,
      "dniPersona":dniPersonaController.text,
      "telefonoPersona":telefonoPersonaController.text,
      "imagenPersona":imagenPerfil,
      "idLocalidad":mostrarIdLocalidad(), // invocamos a la funcion mostrarIdLocalidad que es la Localidad seleccionada
    };

    var res = await CallApi().postData(data, 'crearPerfil');
    var body = json.decode(res.body);
    print(body);
    if(body['success']){
      
       Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => LoHagoPorVos()));
    }else{
      _mostrarMensaje(body['error']);
    }

    setState(() {
       _cargando = false; 
    });
    
    
    
  }

}



