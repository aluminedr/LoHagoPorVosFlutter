import 'package:flutter/material.dart';
import 'package:flutter_app/pages/misTrabajos.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart'; 
import 'package:flutter_app/api/api.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Img;
import 'dart:math' as Math;
import 'package:path_provider/path_provider.dart';


class Valorar extends StatefulWidget{
  final idPersonaLogeada;
  final idTrabajo;
  Valorar(this.idPersonaLogeada, this.idTrabajo);

  @override
  _ValorarState createState() => _ValorarState();
}

class _ValorarState extends State<Valorar> {
  
  TextEditingController comentarioValoracionController = new TextEditingController();
  var rating = 0.0;
  File _image;
  var _formkey= GlobalKey<FormState>();
  bool _cargando = false;


   void initState(){
    buscarDatosPostulacion();
    super.initState();  
  }

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
    //print(widget.idTrabajo);
    return Scaffold(
      key:_scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: new Text('Valorar'),
      ),
        body: Container(
          key: _formkey,
          child: Column(children: <Widget>[
            Center(
            child: SmoothStarRating(
              allowHalfRating: false,
              color: Colors.green,
              borderColor: Colors.purple,
              rating: rating,
              size: 45,
              starCount: 5,
              onRatingChanged: (value) {
                setState(() {
                  rating = value;
                });
              },
            )
            ),
            SizedBox(height: 40.0),
            new TextFormField(
                            controller: comentarioValoracionController,
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
                                child: Icon(Icons.add_comment, color: Colors.white60,)),
                              hintText: "Deje un comentario...",
                              hintStyle: TextStyle(color: Colors.green),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none
                              ),
                              filled: true,
                              fillColor: Colors.green.withOpacity(0.1),
                            ),
                            
                          ),

            Center(  
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
                                  SizedBox(width: 90,),
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

            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                color: Colors.purple,
                textColor: Colors.white,
                child: new Text(_cargando ? 'Cargando'.toUpperCase() : 'Valorar'.toUpperCase()),
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 32.0,
                ),
                onPressed: () {
                _cargando ? null : enviarValoracion(); 
                },
              ),
            ),
          ],)
        )
    );
 }
 void enviarValoracion() async{
    setState(() {
      _cargando = true;
    });
    var idPersonaLogeada = widget.idPersonaLogeada;
    var idTrabajo = widget.idTrabajo;
    var valor = rating;
    String imagenValoracion; 
    String nombreImagen;
    if (_image!=null){
      nombreImagen = _image.path.split("/").last;
      imagenValoracion= base64Encode(_image.readAsBytesSync()); 
    } else {
      nombreImagen = null;
      imagenValoracion= null;
    }
    var data = {
            'idPersonaLogeada':idPersonaLogeada,
            'idTrabajo':idTrabajo,
            'valor':valor,
            'imagenValoracion':imagenValoracion,
            'nombreImagen':nombreImagen,
            'comentarioValoracion' : comentarioValoracionController.text, 
            'flutter':true,
    };
    var res = await CallApi().postData(data, 'enviarValoracion');
    var body = json.decode(res.body);
    print(body);
    if (body['success']){
        Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => MisTrabajos()));
      }else{
      _mostrarMensaje(body['error']);
      setState(() {
        _cargando = false;
      });
    }
    
 }

 void buscarDatosPostulacion() async {
    //var idTrabajo = widget.idTrabajo;
    //var data = {
    //  'idTrabajo':idTrabajo,
    //};

    //var res = await CallApi().postData(data, 'buscarDatosPostulacion');
    //var body = json.decode(res.body);
    //print(body);
     
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

}
