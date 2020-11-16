import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'Post.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _urlBase = "https://jsonplaceholder.typicode.com"; 

  Future<List<Post>> _recuperarPostagens() async {

    http.Response response = await http.get(_urlBase + "/posts");
    var dadosJson = json.decode(response.body); 

    
    List<Post> postagens = List();
    for(var post in dadosJson){

      print("post: " + post["title"]);
      Post p = Post(post["userId"], post["id"], post["title"], post["body"]);
      postagens.add(p);

    }

    return postagens; 

  }

  _post() async {

    var envio = json.encode(

      {
        "userId": 120,
        "id": null,
        "title": "titulo",
        "body": "Corpo"
      },

    );
    
    http.Response response = await http.post(
      _urlBase + '/posts',

      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
      },
        
      body: envio,
    );

    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");

    
  }

  _put() async{
    
    var envio = json.encode(

      {
        "userId": 120,
        "id": null,
        "title": "titulo alterado",
        "body": "Corpo alterado"
      },

    );
    
    http.Response response = await http.put(
      _urlBase + '/posts/1',

      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
      },
        
      body: envio,
    );

    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");
    
    
  }

  _patch() async{

    var envio = json.encode(

      {
        "userId": 120,
        "body": "Corpo alterado"
      },

    );
    
    http.Response response = await http.patch(
      _urlBase + '/posts/1',

      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
      },
        
      body: envio,
    );

    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");
    

  }

  _delete() async{

    http.Response response = await http.delete(
      _urlBase + '/posts/1');

     print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(title: Text("Consumo de serviço avançado"),),

      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                RaisedButton(
                  child: Text("Salvar"),
                  onPressed: _post,
                ),
                RaisedButton(
                  child: Text("Atualizar"),
                  onPressed: _patch,
                ),
                RaisedButton(
                  child: Text("Remover"),
                  onPressed: _delete,
                )
              ],
            ),

            Expanded(
              child: FutureBuilder<List<Post>>(
      future:  _recuperarPostagens(),
      builder: (context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
          return Center(
            child: CircularProgressIndicator(),
          );
         
          break;
          case ConnectionState.active:
          case ConnectionState.done:
          if(snapshot.hasError){
            print("lista: Erro ao carregar" ); 
          }else{

            print("lista: carregou!");
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index){

              List<Post> lista = snapshot.data;
              Post post = lista[index]; 

                
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.body),
              );
              });
            
          }
          break;
        }

      },
    ),

    ),
          ],
        ),
      ),
    );
  }
}
