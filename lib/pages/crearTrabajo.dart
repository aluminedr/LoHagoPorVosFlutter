import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import '../main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Img;
import 'dart:math' as Math;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrearTrabajoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CrearTrabajoPageState();

  }

  class _CrearTrabajoPageState extends State<CrearTrabajoPage>{
  TextEditingController descripcionController = new TextEditingController();
  TextEditingController tituloController = new TextEditingController();
  TextEditingController montoController = new TextEditingController();
  
  bool _cargando = false;
  String mensajeError='';
  String idUsuario;
  String idPersona;
  var _formkey= GlobalKey<FormState>();
  var idProvincia;
  var horaSeleccionada;
  var diaSeleccionado;
  File _image;
  @override
  void initState(){ // Se setea inicio
    
    super.initState(); // se super setea inicio
        listarCategorias(); // llamamos a la funcion listar categorias
        listarProvincias(); // llamamos a la funcion listar provincias
  }

  List listaCategorias;
  Future<Null> listarCategorias() async {

    final response = await CallApi().getData('listarCategorias');
    var respuestaCategorias = json.decode(response.body);
   // print(respuestaCategorias);
    listaCategorias = respuestaCategorias;
  imprimirCategorias(); // Llamamos a la funcion que va a imprimir los datos del select
  }
  String _dropdownValueCategoria;  // seteamos por defecto a null
  Map<int,String>listarCategoriaM=Map(); // Lo mapeamos y le indicamos que es clave int y valor string

  void imprimirCategorias(){
    for(var i=0; i<listaCategorias.length;i++){ // Seteamos los valores
      listarCategoriaM[listaCategorias[i]['idCategoriaTrabajo']]=listaCategorias[i]['nombreCategoriaTrabajo'];
    }
    //print(listarCategoriaM);
    _dropdownValueCategoria=null;
  }

// funcion devuelve el id (la clave) de la categoria seleccionada
  int  mostrarIdCategoria(){
    var usdKey=listarCategoriaM.keys.firstWhere((K)=> listarCategoriaM[K]== _dropdownValueCategoria, //Devuelve la clave del obj
      orElse: ()=>null
    );
    return usdKey;
  }

  List listaProvincias;
  Future<Null> listarProvincias() async {

    final response = await CallApi().getData('listarProvincias');
    setState(() {
      listaProvincias = json.decode(response.body);
    });
  imprimirProvincias(); // Llamamos a la funcion que va a imprimir los datos del select
  }
  String _dropdownValueProvincia;  // seteamos por defecto a null
  Map<int,String>listarProvinciaM=Map(); // Lo mapeamos y le indicamos que es clave int y valor string

  void imprimirProvincias(){
    for(var i=0; i<listaProvincias.length;i++){ // Seteamos los valores
      listarProvinciaM[listaProvincias[i]['idProvincia']]=listaProvincias[i]['nombreProvincia'];
    }
    _dropdownValueProvincia=null;
  }

// funcion devuelve el id (la clave) de la provincia seleccionada
  int  mostrarIdProvincia(){
    var usdKey=listarProvinciaM.keys.firstWhere((K)=> listarProvinciaM[K]== _dropdownValueProvincia, //Devuelve la clave del obj
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
    var response = await CallApi().postData(data,'listarLocalidades');    
    setState(() {
      listaLocalidades = json.decode(response.body); // decode
    });
  imprimirLocalidades(); // Llamamos a la funcion que va a imprimir los datos del select
  }
  String _dropdownValueLocalidad;  // seteamos por defecto a null
  Map<int ,String>listarLocalidadM=Map(); // Lo mapeamos

  void imprimirLocalidades(){
    listarLocalidadM.clear(); // Limpiamos el map para que imprima las localidades desde 0
    for(var i=0; i<listaLocalidades.length;i++){ // Seteamos los valores
      listarLocalidadM[listaLocalidades[i]['idLocalidad']]=listaLocalidades[i]['nombreLocalidad'];
    }
    _dropdownValueLocalidad=null;
  }

// funcion devuelve el id (la clave) de la Localidad seleccionada
  int  mostrarIdLocalidad(){
    var usdKey=listarLocalidadM.keys.firstWhere((K)=> listarLocalidadM[K]== _dropdownValueLocalidad, //Devuelve la clave del obj
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

  
 Function(String) descripcionValidator = (String value){
   if(value.isEmpty){
     return "Ingrese una descripcion";
   }
   return null;
 };

 Function(String) tituloValidator = (String value){
   if(value.isEmpty){
     return "Ingrese un titulo";
   }
   return null;
 };
  Function(String) montoValidator = (String value){
   if(value.isEmpty){
     return "Ingrese un monto";
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
        title: new Text("Publicar un trabajo"),
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
              Colors.white60,
              Colors.white
            ]
          )
        ),
          child:  ListView(
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
                          color: Colors.green,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold
                        ),),
                        SizedBox(height: 40.0),
                        SingleChildScrollView(
                          child: Center(  
                          child: Column(
                            children: <Widget>[
                              Center(
                                child: _image==null
                                ? new Text("Seleccione una imagen")
                                : new Image.file(_image),
                              ),
                              Center(child: 
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
                              )],
                          ),),
                        ),SizedBox(height: 10.0),
                      Container(
                        child: ListTile(
                          title: new TextFormField(
                            controller: tituloController,
                            validator:tituloValidator,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              prefixIcon: Container(
                                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                                margin: const EdgeInsets.only(right: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                    bottomRight: Radius.circular(10.0)
                                  )
                                ),
                                child: Icon(Icons.text_fields, color: Colors.white60,)),
                              hintText: "Ingrese un titulo",
                              hintStyle: TextStyle(color: Colors.green),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none
                              ),
                              filled: true,
                              fillColor: Colors.green.withOpacity(0.1),
                            ),
                            
                          ),
                        ),
                      ),SizedBox(height: 10.0),
                             Container(
                        child: ListTile(
                          title: new TextFormField(
                            controller: descripcionController,
                            validator:descripcionValidator,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              prefixIcon: Container(
                                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                                margin: const EdgeInsets.only(right: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                    bottomRight: Radius.circular(10.0)
                                  )
                                ),
                                child: Icon(Icons.text_fields, color: Colors.white60,)),
                              hintText: "Ingrese una descripcion",
                              hintStyle: TextStyle(color: Colors.green),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none
                              ),
                              filled: true,
                              fillColor: Colors.green.withOpacity(0.1),
                            ),
                            
                          ),
                        ),
                      ),SizedBox(height: 10.0),
                             Container(
                        child: ListTile(
                          title: new TextFormField(
                            controller: montoController,
                            validator:montoValidator,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              prefixIcon: Container(
                                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                                margin: const EdgeInsets.only(right: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                    bottomRight: Radius.circular(10.0)
                                  )
                                ),
                                child: Icon(Icons.monetization_on, color: Colors.white60,)),
                              hintText: "Ingrese un monto",
                              hintStyle: TextStyle(color: Colors.green),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none
                              ),
                              filled: true,
                              fillColor: Colors.green.withOpacity(0.1),
                            ),
                            
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
                                  color: Colors.green,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                    bottomRight: Radius.circular(10.0)
                                  )
                                ),
                                child: Icon(Icons.list, color: Colors.white60,),),
                                 hintText: "Seleccione una categoria",
                              hintStyle: TextStyle(color: Colors.green),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none
                              ),
                              filled: true,
                              fillColor: Colors.green.withOpacity(0.1),
                            ),
                            value: _dropdownValueCategoria,
                            onChanged: (String newValue) {
                              setState(() {
                                _dropdownValueCategoria = newValue;
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
                                  color: Colors.green,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                    bottomRight: Radius.circular(10.0)
                                  )
                                ),
                                child: Icon(Icons.map, color: Colors.white60,),),
                                 hintText: "Seleccione una provincia",
                              hintStyle: TextStyle(color: Colors.green),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none
                              ),
                              filled: true,
                              fillColor: Colors.green.withOpacity(0.1),
                            ),
                            value: _dropdownValueProvincia,
                            onChanged: (String newValue) {
                              setState(() {
                                _dropdownValueProvincia = newValue;
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
                      ),SizedBox(height: 5.0),
                        _addSecondDropdown(),
                        SizedBox(height: 5.0),
                        ////// Date Picker Dialog.
                         SizedBox(
                        width: double.infinity,
                        child: new RaisedButton(
                          child: Text('Seleccione dia de finalizacion del anuncio'),
                          color: Colors.green.withOpacity(0.1),
                          textColor: Colors.green,
                          padding: const EdgeInsets.all(20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)
                          ),
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2018),
                              lastDate: DateTime(2025),
                            ).then<DateTime>((DateTime value) {
                              if (value != null) {
                                diaSeleccionado= value;
                              }
                            });
                          },
                        ),),
                         SizedBox(height: 10.0),
                        ////// Time Picker Dialog.
                      SizedBox(
                        width: double.infinity,
                        child: new RaisedButton(
                          color: Colors.green.withOpacity(0.1),
                          textColor: Colors.green,
                          padding: const EdgeInsets.all(20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)
                          ),
                          child: Text('Seleccione hora de finalizacion del anuncio'),
                          onPressed: () {
                            DateTime now = DateTime.now();
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
                            ).then<String>((TimeOfDay value) {
                              if (value != null) {
                              horaSeleccionada=value;
                              }
                            });
                          },
                        ),),
                        SizedBox(height: 20.0),
                        SizedBox(
                        width: double.infinity,
                        child: new RaisedButton(
                          child: new Text(_cargando ? 'Creando'.toUpperCase() : 'Crear anuncio'.toUpperCase()),
                          color: Colors.green,
                          textColor: Colors.white60,
                          padding: const EdgeInsets.all(20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)
                          ),
                          onPressed: () {
                            _cargando ? null : _crear(); 
                            } 
                        ),),
                         SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                          FlatButton(
                            textColor: Colors.green,
                            child: Text("borrar".toUpperCase()),
                            onPressed: (){
                              Navigator.pushReplacementNamed(context,"/crearTrabajo");
                            },
                          ),
                        ],),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ]),
    ),),);
        

  }

 Widget _addSecondDropdown() {
              
        return Container(
          child: ListTile(
                          title: _dropdownValueProvincia != null
          ? DropdownButtonFormField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              prefixIcon: Container(
                                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                                margin: const EdgeInsets.only(right: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                    bottomRight: Radius.circular(10.0)
                                  )
                                ),
                                child: Icon(Icons.map, color: Colors.white60,),),
                                 hintText: "Seleccione una provincia",
                              hintStyle: TextStyle(color: Colors.green),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none
                              ),
                              filled: true,
                              fillColor: Colors.green.withOpacity(0.1),
                            ),
              value: _dropdownValueLocalidad,
              items: listarLocalidadM.values
                                .map((value) =>DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value)
                                ))
                                .toList(),
              onChanged: (newValue) {
                setState(() {
                  _dropdownValueLocalidad = newValue;
                });
              })
          : Container(),
        )); // Return an empty Container instead.
  }
  

  void _crear() async {

      setState(() {
        _cargando = true;
      });
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var idPersona = localStorage.getInt('idPersona');
      String imagenTrabajo; 
      String nombreImagen;

      if (_image!=null){
        nombreImagen = _image.path.split("/").last;
        imagenTrabajo= base64Encode(_image.readAsBytesSync()); 
      } else {
        nombreImagen = null;
        imagenTrabajo= null;
      }
      var data = {
        "titulo":tituloController.text,
        "descripcion":descripcionController.text,
        "monto":montoController.text,
        "idCategoriaTrabajo":mostrarIdCategoria(), // invocamos a la funcion mostrarIdCategoria que es la categoria seleccionada
        "idPersona":idPersona,
        "imagenTrabajo":imagenTrabajo,
        "horaSeleccionada": horaSeleccionada.toString(),
        "diaSeleccionado":diaSeleccionado.toString(),
        "nombreImagen":nombreImagen,
        "idLocalidad":mostrarIdLocalidad(), // invocamos a la funcion mostrarIdLocalidad que es la Localidad seleccionada
    };

      var res = await CallApi().postData(data, 'storeTrabajo');
      var body = json.decode(res.body);
      print(body);
      if (body['success']){
        Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => LoHagoPorVos()));
      }else{
      _mostrarMensaje(body['error']);
      setState(() {
        _cargando = false;
      });
    }

  }
}