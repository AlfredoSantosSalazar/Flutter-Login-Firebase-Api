import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logincloud/models/Gif.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final FirebaseAuth _auth = FirebaseAuth.instance;

class Api extends StatefulWidget {
  const Api({Key key}) : super(key: key);

  @override
  State<Api> createState() => ApiState();
}

class ApiState extends State<Api> {
  Future<List<Gif>> _listadoGifs;

  Future<List<Gif>> _getGifs() async {
    final response = await http.get(Uri.parse(
        "https://api.giphy.com/v1/gifs/trending?api_key=zxkic0c7ZVlWRo20ae9Sp8MgHMWgwl22&limit=10&rating=g"));

    List<Gif> gifs = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);

      for (var item in jsonData["data"]) {
        gifs.add(Gif(item["title"], item["images"]["downsized"]["url"]));
      }

      return gifs;
    } else {
      throw Exception("Fallo la conexion");
    }
  }

  @override
  void initState() {
    super.initState();
    _listadoGifs = _getGifs();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Api Gif',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Consumo de una Api'),
          ),
          body: FutureBuilder(
            future: _listadoGifs,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.count(
                  crossAxisCount: 2,
                  children: _listGifs(snapshot.data),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text("Error");
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
    );
  }

  List<Widget> _listGifs(data) {
    List<Widget> gifs = [];

    for (var gif in data) {
      gifs.add(Card(
          child: Column(
        children: [
          Expanded(
            child: Image.network(
              gif.url,
              fit: BoxFit.fill,
            ),
          ),
        ],
      )));
    }

    return gifs;
  }
}
