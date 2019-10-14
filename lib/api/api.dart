import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class CallApi{
    final String _url = 'http://192.168.1.36/LoHagoPorVosLaravel/public/api/';

    postData(data, apiUrl) async {
        var fullUrl = _url + apiUrl + await _getToken(); 
        return await http.post(
            fullUrl, 
            body: jsonEncode(data), 
            headers: _setHeaders()
        );
    }
    getData(apiUrl) async {
       var fullUrl = _url + apiUrl + await _getToken();
       return await http.get(
         fullUrl, 
         headers: _setHeaders()
       );
    }

    _setHeaders() => {
        'Content-type' : 'application/json',
        'Accept' : 'application/json',
    };

    _getToken() async {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        var token = localStorage.getString('token');
        return '?token=$token';
    }

    storeTrabajo(data, apiUrl) async {
        var fullUrl = _url + apiUrl; 
        return await http.post(
            fullUrl, 
            body: jsonEncode(data), 
            headers: _setHeaders()
        );
    }

    listarCategorias(apiUrl) async {
      var fullUrl = _url + apiUrl; 
        return await http.get(
            fullUrl, 
            headers: _setHeaders()
        );
    }

    listarProvincias(apiUrl) async {
      var fullUrl = _url + apiUrl; 
      //print(fullUrl);
        return await http.post(
            fullUrl, 
            body: null, 
            headers: _setHeaders()
        );
    }

    listarLocalidades(data, apiUrl) async {
      var fullUrl = _url + apiUrl; 
        //print(data);
        return await http.post(
            fullUrl, 
            body: jsonEncode(data), 
            headers: _setHeaders()
        );
    }

    listarTrabajos(apiUrl) async {
      var fullUrl = _url + apiUrl; 
        //print(data);
        return await http.post(
            fullUrl, 
            
            headers: _setHeaders()
        );
    }




}