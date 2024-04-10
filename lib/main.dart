import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget{
  const HomePage({super.key, this.resultado});

  final String? resultado;

  @override
  State<HomePage> createState() => _HomePage();

}

class _HomePage extends State<HomePage> {
  
  String _text = 'Presione el botón para obtener las películas';

  Future<void> getMovies() async {

    setState(() {
      _text = 'Cargando...';
    });

    var url = Uri.https('api.themoviedb.org',
      '/3/movie/popular',
      {
        'api_key':'bba0b4eda2fca322605576adf5f83de6',
        'language':'es-Mx',
        'page':'1',
      },
    );
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      print(jsonResponse);
      setState(() {
        //Set the _text with the length of the results and the list of movies
        _text = 'Results: ${jsonResponse['results'].length}\n';
        for (var movie in jsonResponse['results']) {
          _text += '${movie['title']}\n';
        }
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
      setState(() {
        _text = 'Request failed with status: ${response.statusCode}.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body:Center(child: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: getMovies,
            child: Text('Get Movies'),
          ),
          Text(_text),
        ],
      ),) 
    );
  }
}