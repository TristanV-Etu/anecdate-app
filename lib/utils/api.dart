import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:http_parser/http_parser.dart';
import 'package:anecdate_app/utils/globals.dart';
import 'package:anecdate_app/widgets/connection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<Uri> getUri(
    {required String path, Map<String, dynamic>? queryParam}) async {
  return Uri.http(Globals.getApiAdresse(), path, queryParam);
}

Future<List<dynamic>> getAllAnecdates() async {
  var response = await http.get(await getUri(path: "/api/anecdate"));
  return jsonDecode(response.body);
}

Future<List<dynamic>> getAnecdatesWithCommentsFromUser() async {
  var response = await http.get(await getUri(path: "/api/anecdate"));
  return jsonDecode(response.body);
}

Future<List<dynamic>> getAnecdatesFromUser() async {
  var response = await http
      .get(await getUri(path: "/api/user/${Globals.idUser}/anecdates"));
  return jsonDecode(response.body);
}

Future<List<dynamic>> getCommentsFromAnecdate(int idAnecdate) async {
  var response = await http.get(await getUri(
      path: "/api/anecdate/" + idAnecdate.toString() + "/comments"));
  return jsonDecode(response.body);
}

Future<Map<String, dynamic>> getSpecificUserById(int idUser) async {
  var response =
      await http.get(await getUri(path: "/api/user/" + idUser.toString()));
  return jsonDecode(response.body);
}

Future<List<dynamic>> getAllCategories() async {
  var response = await http.get(await getUri(path: "/api/category"));
  return jsonDecode(response.body);
}

Future<void> login(String username, String password, BuildContext ctx) async {
  var response = await http.post(await getUri(path: "/api/login"),
      body: <String, String>{"username": username, "password": password});
  Map<String, dynamic> result = jsonDecode(response.body);
  if (result["success"] as bool) {
    Globals.isConnect = true;
    Globals.userName = username;
    Globals.idUser = result["id"];
    Globals.tokenAuth = result["token"];
    Globals.pushPreferences();
  }

  ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
  if (response.statusCode == 403) {
    ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text("Pseudo ou Mot de passe incorrect.")));
    return;
  } else if (response.statusCode != 200) {
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text("Une erreur est survenu.")));
    return;
  }
  ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(content: Text("Connection réussie. Bonjour $username.")));

  Navigator.pop(ctx);
}

Future<void> signIn(
    String username, String password, String mail, BuildContext ctx) async {
  var response =
      await http.post(await getUri(path: "/api/user"), body: <String, dynamic>{
    "role": "2",
    "pseudo": username,
    "password": password,
    "mail": mail,
    "mode_quiz": "0"
  });

  ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
  if (response.statusCode != 200) {
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text("Une erreur est survenu.")));
    return;
  }
  ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(content: Text("Inscription réussie. Veuillez vous connecter.")));

  Navigator.pushReplacement(
      ctx, MaterialPageRoute(builder: (context) => LoginPage()));
}

Future<void> postComment(
    String message, int idAnecdate, BuildContext ctx) async {
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  var response = await http
      .post(await getUri(path: "/api/comment"), body: <String, dynamic>{
    "idAuthor": Globals.idUser.toString(),
    "message": message,
    "date": formattedDate,
    "idAnecdate": idAnecdate.toString()
  }, headers: {
    "Authorization": Globals.tokenAuth
  });

  if (response.statusCode != 200) {
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text("Une erreur est survenu.")));
    return;
  }
  ScaffoldMessenger.of(ctx)
      .showSnackBar(SnackBar(content: Text("Votre commentaire a été envoyé.")));
}

Future<void> postNewAnecDate(
  String title,
  String date,
  File image,
  String nameCat,
  String desc,
  String sources,
  String? question,
  String? goodAnswer,
  String? bad1Answer,
  String? bad2Answer,
  String? bad3Answer,
) async {
  var request =
      http.MultipartRequest('POST', Uri.parse("http://"+ Globals.getApiAdresse() + "/api/anecdate"));


  request.fields["title"] = title;
  request.fields["date"] = date;
  request.fields["idCategory"] = Globals.idsCategories[nameCat].toString();
  request.fields["description"] = desc;
  request.fields["sources"] = sources;
  request.fields["idAuthor"] = Globals.idUser.toString();
  request.fields["question"] = question!;
  request.fields["true_answer"] = goodAnswer!;
  request.fields["wrong_answer1"] = bad1Answer!;
  request.fields["wrong_answer2"] = bad2Answer!;
  request.fields["wrong_answer3"] = bad3Answer!;

  request.files.add(await http.MultipartFile.fromPath(
      "image",
      image.path
  ));

  request.headers["Authorization"] = Globals.tokenAuth;

  var res = await request.send();
  var result = String.fromCharCodes(await res.stream.toBytes());

  print(res.statusCode);
  print(result);
}
