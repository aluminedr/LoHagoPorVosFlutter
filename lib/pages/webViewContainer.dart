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
  //final _key = UniqueKey(); 
  _WebViewContainerState(this._url); 
   void initState() {
        super.initState();
        final fWPlugin = new FlutterWebviewPlugin();
        fWPlugin.onDestroy.listen((_) => exit(0));
        fWPlugin.onUrlChanged.listen((String url) {
          print("URL: " + url);
          if (url.contains('localhost')){
            fWPlugin.stopLoading();      
            String ipv4;
            String urlIPV4;
            ipv4="http://192.168.1.36/";
            var urlSinLocalHost=(url.split("http://localhost/").last);
            urlIPV4= ipv4+urlSinLocalHost;
            //print(urlIPV4);
            fWPlugin.reloadUrl(urlIPV4);
          } else {
            print("no contiene");
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