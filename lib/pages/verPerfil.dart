import 'package:flutter/material.dart';

class VerPerfilPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _VerPerfilPageState();
  
  
  }
  
  class _VerPerfilPageState extends State<VerPerfilPage>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Perfil"),
      ),
    );
  }
}



   /* return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white12,
              Colors.lightGreen[50]
            ]
          )
        ),
        child: Column(
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
              color: Colors.green[700],
              fontSize: 24.0,
              fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 40.0),
            TextField(
              controller: mailUsuarioController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16.0),
                prefixIcon: Container(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                  margin: const EdgeInsets.only(right: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.lightGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(10.0)
                    )
                  ),
                  child: Icon(Icons.email, color: Colors.green[700],)),
                hintText: "Ingrese su mail",
                hintStyle: TextStyle(color: Colors.green[700]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none
                ),
                filled: true,
                fillColor: Colors.lightGreen.withOpacity(0.1),
              ),
              
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: claveUsuarioController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16.0),
                prefixIcon: Container(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                  margin: const EdgeInsets.only(right: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.lightGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(10.0)
                    )
                  ),
                  child: Icon(Icons.vpn_key, color: Colors.green[700],)),
                hintText: "Ingrese su contraseña",
                hintStyle: TextStyle(color: Colors.green[700]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none
                ),
                filled: true,
                fillColor: Colors.lightGreen.withOpacity(0.1),
              ),
              obscureText: true,
            ),
            SizedBox(height: 30.0),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                color: Colors.lightGreen,
                textColor: Colors.green[700],
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  _cargando?"Ingresando...".toUpperCase():"Ingresar".toUpperCase()
                
                ),
                onPressed: (){
                  _cargando ? null : _login();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)
                ),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              FlatButton(
                textColor: Colors.green[700],
                child: Text("Registrarme".toUpperCase()),
                onPressed: (){
                  Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => RegisterPage()));
                },
              ),
              Container(
                color: Colors.green[700],
                width: 2.0,
                height: 20.0,
              ),
              FlatButton(
                textColor: Colors.green[700],
                child: Text("Olvide mi contraseña".toUpperCase()),
                onPressed: (){
                },
              ),

            ],),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }*/