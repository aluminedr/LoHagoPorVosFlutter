import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _RegisterPageState();

  

}

class _RegisterPageState extends State<RegisterPage>{
  TextEditingController mailUsuarioController = new TextEditingController();
  TextEditingController  claveUsuarioController = new TextEditingController();
  String mensajeError='';
  var _formkey= GlobalKey<FormState>();

  void register(){
    var url="http://192.168.1.39/LoHagoPorVosFlutter/lib/conexion/NewUser.php";
    http.post(url,body:{
      "mailUsuario":mailUsuarioController.text,
      "claveUsuario":claveUsuarioController.text,
    });
  }
    
 Function(String) mailValidator = (String value){
   if(value.isEmpty){
     return "Ingrese un email";
   }
   return null;
 };
  Function(String) passValidator = (String value){
   if(value.isEmpty){
     return "Ingrese una contraseña";
   }
   return null;
 };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Registro"),
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
                            controller: mailUsuarioController,
                            validator:mailValidator,
                            decoration: new InputDecoration(
                              hintText: "mimail@gmail.com",
                              labelText: "Mail",
                            ),
                          ),
                        ),
                        new ListTile(
                          leading: const Icon(Icons.mail, color: Colors.black,),
                          title: new TextFormField(
                            controller: claveUsuarioController,
                            validator:passValidator,
                            decoration: new InputDecoration(
                              hintText: "**********",
                              labelText: "Contraseña",
                            ),
                          ),
                        ),
                        new RaisedButton(
                          child: new Text("  Registrarme  "),
                          color: Colors.green,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)
                          ),
                          onPressed: () {
                            if(_formkey.currentState.validate()){
                              register();
                              Navigator.pop(context);
                            } 
                          },
                        ),
                        new RaisedButton(
                          child: new Text("  Tengo cuenta  "),
                          color: Colors.green,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context,"/login");
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