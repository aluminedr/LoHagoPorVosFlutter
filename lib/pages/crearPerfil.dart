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
  Img.Image smallerImg = Img.copyResize(image, width:130, height:130);

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
  Img.Image smallerImg = Img.copyResize(image, width:130, height:130);

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

 var _scaffoldKey = new GlobalKey<ScaffoldState>();
 ScaffoldState scaffoldState;
  _mostrarMensaje(msg) async {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Cerrar',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey,
      appBar: AppBar(
        title: new Text("Perfil"),
      ),
      resizeToAvoidBottomPadding: false,
      body: Form(
        key: _formkey,
        child: Container(
        padding: const EdgeInsets.all(16.0),
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.lightGreen,
              Colors.green
            ]
          )
        ),
        child: ListView(
                  children: <Widget>[
                    new Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 40.0,bottom: 20.0),
                          height: 80,
                          child:  new Image(
                            width: 135,
                            height: 135,
                            image: new AssetImage('assets/images/LoHagoPorVosLogo.png'),
                          ),
                        ),
                        Text("Lo hago por vos".toUpperCase(), style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold
                        ),),
                        SizedBox(height: 40.0),
                      Container(
                        child: ListTile(
                          title: new TextFormField(
                            controller: nombrePersonaController,
                            validator:nombrePersonaValidator,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              prefixIcon: Container(
                                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                                margin: const EdgeInsets.only(right: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                    bottomRight: Radius.circular(10.0)
                                  )
                                ),
                                child: Icon(Icons.person, color: Colors.lightGreen,)),
                              hintText: "Ingrese su nombre",
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                            ),
                            
                          ),
                        ),
                      ),SizedBox(height: 10.0),
                      Container(
                        child: ListTile(
                          title: new TextFormField(
                            controller: apellidoPersonaController,
                            validator:apellidoPersonaValidator,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              prefixIcon: Container(
                                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                                margin: const EdgeInsets.only(right: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                    bottomRight: Radius.circular(10.0)
                                  )
                                ),
                                child: Icon(Icons.person, color: Colors.lightGreen,)),
                              hintText: "Ingrese su apellido",
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                            ),
                            
                          ),
                        ),
                      ),SizedBox(height: 10.0),
                      Container(
                        child: ListTile(
                          title: new TextFormField(
                            controller: dniPersonaController,
                            validator:dniPersonaValidator,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              prefixIcon: Container(
                                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                                margin: const EdgeInsets.only(right: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                    bottomRight: Radius.circular(10.0)
                                  )
                                ),
                                child: Icon(Icons.credit_card, color: Colors.lightGreen,)),
                              hintText: "Ingrese su DNI",
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                            ),
                            
                          ),
                        ),
                        ),SizedBox(height: 10.0),
                      Container(
                        child: ListTile(
                          title: new TextFormField(
                            controller: telefonoPersonaController,
                            validator:telefonoPersonaValidator,
                              decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              prefixIcon: Container(
                                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                                margin: const EdgeInsets.only(right: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                    bottomRight: Radius.circular(10.0)
                                  )
                                ),
                                child: Icon(Icons.phone_android, color: Colors.lightGreen,)),
                              hintText: "Ingrese su telefono",
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                            ),
                            
                          ),
                        ),
                      ),SizedBox(height: 10.0),
                      Container(
                        child: ListTile(
                          title:Column(
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
                  ),SizedBox(height: 10.0),
                      Container(
                        child: ListTile(
                          title: DropdownButtonFormField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              prefixIcon: Container(
                                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                                margin: const EdgeInsets.only(right: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                    bottomRight: Radius.circular(10.0)
                                  )
                                ),
                                child: Icon(Icons.map, color: Colors.lightGreen,),),
                                 hintText: "Seleccione una provincia",
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                            ),
                            value: _dropdownValuePro,
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
                      ),SizedBox(height: 10.0),
                        _addSecondDropdown(),

                        Padding(padding: EdgeInsets.only(top: .0),

                        ),
                        SizedBox(
                        width: double.infinity,
                        child: new RaisedButton(
                          child: new Text(_cargando ? 'Creando'.toUpperCase() : 'Guardar datos'.toUpperCase()),
                          color: Colors.white,
                          textColor: Colors.lightGreen,
                          padding: const EdgeInsets.all(20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)
                          ),
                          onPressed: () {
                            _cargando ? null : _crearPerfil(); 
                            } 
                        ),),
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

                        new RaisedButton(
                          child: new Text("    Cerrar sesion    "),
                          color: Colors.green,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)
                          ),
                          onPressed: () {
                            logout();
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
          child: ListTile(
                          title: _dropdownValuePro != null
          ? DropdownButtonFormField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              prefixIcon: Container(
                                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                                margin: const EdgeInsets.only(right: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                    bottomRight: Radius.circular(10.0)
                                  )
                                ),
                                child: Icon(Icons.map, color: Colors.lightGreen,),),
                                 hintText: "Seleccione una provincia",
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                            ),
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
          : Container(),
        )); // Return an empty Container instead.
  }

  void logout() async{
      // logout from the server ... 
      var res = await CallApi().getData('logout');
      var body = json.decode(res.body);
      print(body);
      if(body['success']){
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.remove('user');
        localStorage.remove('token');
        localStorage.remove('persona');
        //localStorage.setBool('token', null);
    
        
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => LoHagoPorVos()));
      }
     
  }
  
  void _crearPerfil() async {
    setState(() {
       _cargando = true;
    });
    String imagenPersona= base64Encode(_image.readAsBytesSync()); 
      String nombreImagen = _image.path.split("/").last;
    var data = {
      "idUsuario":idUsuario,
      "nombrePersona":nombrePersonaController.text,
      "apellidoPersona":apellidoPersonaController.text,
      "dniPersona":dniPersonaController.text,
      "telefonoPersona":telefonoPersonaController.text,
      "imagenPersona":imagenPersona,
      "nombreImagen":nombreImagen,
      "idLocalidad":mostrarIdLocalidad(), // invocamos a la funcion mostrarIdLocalidad que es la Localidad seleccionada
    };

    var res = await CallApi().postData(data, 'crearPerfil');
    var body = json.decode(res.body);
    print(body);
    if(body['success']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setInt('idPersona', body['idPersona']);
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



