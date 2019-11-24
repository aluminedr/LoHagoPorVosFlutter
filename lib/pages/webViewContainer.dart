import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
//import 'package:webview_flutter/webview_flutter.dart';
class WebViewContainer extends StatefulWidget {
  final url;  
  WebViewContainer(this.url);  
  @override
  createState() => _WebViewContainerState(this.url);
}
class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  _WebViewContainerState(this._url); 
   void initState() {
        super.initState();
        final fWPlugin = new FlutterWebviewPlugin();
        fWPlugin.onDestroy.listen((_) => exit(0));
        fWPlugin.onUrlChanged.listen((String url) { // Cada vez que se produce un cambio en la url
          if (url.contains('localhost')){ // si la url contiene la palabra localhost, debemos cambiarla por la ipv4
            fWPlugin.stopLoading();    // Pausamos por un momento la carga
            String ipv4;
            String urlIPV4;
            ipv4="http://192.168.1.36/"; // Definimos la ipv4
            var urlSinLocalHost=(url.split("http://localhost/").last); // Eliminamos 'localhost' de la url
            urlIPV4= ipv4+urlSinLocalHost; // Seteamos la ipv4 + resto de la url
            fWPlugin.reloadUrl(urlIPV4); // Cargamos la nueva url
          } 
        });
      }


    @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
          url:_url,
          appBar: new AppBar(
            backgroundColor: Colors.green,
            title: new Text("Pago"),
          ),
          withLocalStorage: true,
          hidden: true,
        );
  }
  
}