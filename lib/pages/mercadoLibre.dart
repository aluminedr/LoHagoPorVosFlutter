import 'package:flutter/material.dart';

import 'MercadoLibre/services.dart';
import 'MercadoLibre/credentials.dart';

class MercadoLibrePage extends StatefulWidget{

  MercadoLibrePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _MercadoLibrePageState();

  }

  class _MercadoLibrePageState extends State<MercadoLibrePage>{
    final credentials = MercadoCredentials(
      publicKey: 'TEST-de665733-b459-45ad-bcef-8e5755c6aac8',
      accessToken:
          'TEST-5735929082039001-093016-75382964362cfcb4aa40d9dfa1e6b09c-198613707');

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("hola"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                MercadoPago(credentials)
                    .newUser(
                        firstname: 'Diego',
                        lastName: 'Montes',
                        email: 'diego@montes.com')
                    .then((responseObject) {
                    print('user created with id = [ $responseObject ]');
                });
              },
              child: Text('New User'),
            ),
            RaisedButton(
              onPressed: () {
                MercadoPago(credentials)
                    .newCard(
                        code: '333',
                        year: '2020',
                        month: 9,
                        card: '4009175332806176',
                        docNumber: '85695236',
                        docType: 'DNI', name: 'jkjk')
                    .then((responseObject) {
                  print("responseObject => $responseObject");
                });
              },
              child: Text('New Card'),
            ),
            RaisedButton(
              onPressed: () {
                /* MercadoPago(credentials)
                    .associateCardWithUser(
                        user: '387744186-Zw0inDybbSCugR',
                        card: '453c47432aabcf01c7923c6a52060a17')
                    .then((responseObject) {
                  print("responseObject => $responseObject");
                }); */

                MercadoPago(credentials)
                    .cardsFromUser(user: '475550565-2PEBu8L41A0zWB')
                    .then((responseObject) {
                  print("cards => ${responseObject.data}");
                });

                /* MercadoPago(credentials)
                    .tokenWithCard(
                      code: '222',
                      card: '1545133239176')
                    .then((responseObject) {
                  print("token => ${responseObject.data}");
                }); */
              },
              child: Text('New Card'),
            ),
            
            RaisedButton(
              onPressed: () {
                MercadoPago(credentials)
                    .createPayment(
                      total: 5.0,
                      cardToken: 'b6297a4d99cab8b5fe72b75117804274',
                      description: 'Test pay',
                      paymentMethod: 'visa',
                      userId: '475550565-2PEBu8L41A0zWB',
                      email: 'diego@montes.com'
                    )
                    .then((responseObject) {
                  print("payment => ${responseObject.data}");
                });
              },
              child: Text('New pay'),
            )
          ],
        ),
      ),
    );
  }





  }
