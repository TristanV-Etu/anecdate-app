import 'dart:convert';
import 'dart:core';

import 'package:anecdate_app/utils/globals.dart';
import 'package:anecdate_app/widgets/connection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Uri> getUri({required String path, Map<String, dynamic>? queryParam}) async {
  return Uri.http(Globals.getApiAdresse(), path, queryParam);
}

Future<List<dynamic>> getAllAnecdates() async{
  var response = await http.get(await getUri(path: "/api/anecdate"));
  return jsonDecode(response.body);
}

Future<List<dynamic>> getCommentsFromAnecdate(int idAnecdate) async{
  var response = await http.get(await getUri(path: "/api/anecdate/"+idAnecdate.toString()+"/comments"));
  return jsonDecode(response.body);
}

Future<Map<String, dynamic>> getSpecificUserById(int idUser) async{
  var response = await http.get(await getUri(path: "/api/user/"+idUser.toString()));
  return jsonDecode(response.body);
}

Future<List<dynamic>> getAllCategories() async {
  var response = await http.get(await getUri(path: "/api/category"));
  return jsonDecode(response.body);
}

Future<void> login(String username, String password, BuildContext ctx) async {
  var response = await http.post(await getUri(path: "/api/login"), body: <String, String> { "username": username, "password": password});
  Map<String, dynamic> result = jsonDecode(response.body);
  if (result["success"] as bool) {
    Globals.isConnect = true;
    Globals.userName = username;
    Globals.tokenAuth = result["token"];
    Globals.pushPreferences();
  }
  print(response.statusCode);
  print(result);

  ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
  if (response.statusCode == 403) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text("Pseudo ou Mot de passe incorrect.")));
    return;
  }
  else if (response.statusCode != 200) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text("Une erreur est survenu.")));
    return;
  }
  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text("Connection réussie. Bonjour $username.")));

  Navigator.pop(ctx);
}

Future<void> signIn(String username, String password, String mail, BuildContext ctx) async {
  var response = await http.post(
      await getUri(path: "/api/user"),
      body: <String, dynamic> {
        "role": "2",
        "pseudo": username,
        "password": password,
        "mail": mail,
        "mode_quiz": "0"
      }
  );

  ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
  if (response.statusCode != 200) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text("Une erreur est survenu.")));
    return;
  }
  Map<String, dynamic> result = jsonDecode(response.body);
  print(result);
  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text("Inscription réussie. Veuillez vous connecter.")));

  Navigator.pop(ctx);
  Navigator.push(ctx, MaterialPageRoute(builder: (context) => LoginPage()));
}