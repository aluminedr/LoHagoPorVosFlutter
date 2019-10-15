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
import 'package:flutter/cupertino.dart';


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
  File _image;
  DateTime _dateTime = DateTime.now();

  @override
  void initState(){ // Se setea inicio
    
    super.initState(); // se super setea inicio
        listarCategorias(); // llamamos a la funcion listar categorias
        listarProvincias(); // llamamos a la funcion listar provincias
  }

  List listaCategorias;
  Future<Null> listarCategorias() async {

    final response = await CallApi().listarCategorias('listarCategorias');
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

    final response = await CallApi().listarProvincias('listarProvincias');
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
    var response = await CallApi().listarLocalidades(data,'listarLocalidades');    
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
                                  controller: tituloController,
                                  validator:tituloValidator,
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
                                  value: _dropdownValueCategoria,
                                  hint: Text("Seleccione una cat."),
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
                            value: _dropdownValueProvincia,
                            hint: Text("Seleccione una provincia.."),
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
                      ),
                        _addSecondDropdown(),
                        
                        Padding(padding: EdgeInsets.only(top: .0),

                        ),
                        new RaisedButton(
                          child: new Text(_cargando ? 'Creando' : 'Crear Trabajo'),
                          color: Colors.green,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)
                          ),
                          onPressed: () {
                            if(_formkey.currentState.validate()){
                                _cargando ? null : _crear(); 
                              
                            } 
                          },
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 200,
                              child: CupertinoDatePicker(
                                initialDateTime: _dateTime,
                                onDateTimeChanged: (dateTime){
                                  setState((){
                                    _dateTime=dateTime;
                                  });
                                },
                              ),
                            ),
                          RaisedButton(
                            child: Text('Confirmar'),
                            onPressed: (){
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text("Seleccionado:"),
                                  content: Text('${_dateTime.day}/${_dateTime.month}/${_dateTime.year}\n${_dateTime.hour}:${_dateTime.minute}'),
                                )
                              );
                            },
                          )
                          ],
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
                          title: _dropdownValueProvincia != null
          ? DropdownButton<String>(
              value: _dropdownValueLocalidad,
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
      String imagenTrabajo= base64Encode(_image.readAsBytesSync()); 
      String nombreImagen = _image.path.split("/").last;
      var data = {
        "titulo":tituloController.text,
        "descripcion":descripcionController.text,
        "monto":montoController.text,
        "idCategoriaTrabajo":mostrarIdCategoria(), // invocamos a la funcion mostrarIdCategoria que es la categoria seleccionada
        "idPersona":idPersona,
        "imagenTrabajo":imagenTrabajo,
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