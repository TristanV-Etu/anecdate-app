import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:anecdate_app/model/anecdate.dart';
import 'package:anecdate_app/utils/globals.dart';
import 'package:anecdate_app/widgets/connection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<Uri> getUri(
    {required String path, Map<String, dynamic>? queryParam}) async {
  return Uri.http(Globals.getApiAdresse(), path, queryParam);
}

Future<List<dynamic>> getAnecdatesOfTheDay() async {
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

Future<int> getNumberCommentsFromAnecdate(int idAnecdate) async {
  var response = await http.get(await getUri(
      path: "/api/anecdate/" + idAnecdate.toString() + "/comments"));
  return (jsonDecode(response.body) as List<dynamic>).length;
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
  try {
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
    if (result["message"] == "Account disactivate") {
      ScaffoldMessenger.of(ctx)
          .showSnackBar(SnackBar(content: Text("Compte désactivé.")));
      return;
    } else if (result["message"] == "Incorrect username or password") {
      ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text("Pseudo ou Mot de passe incorrect.")));
      return;
    } else if (response.statusCode != 200) {
      ScaffoldMessenger.of(ctx)
          .showSnackBar(SnackBar(content: Text("Une erreur est survenu.")));
      return;
    }
    ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text("Connexion réussie. Bonjour $username.")));

    Navigator.pop(ctx);
  } on SocketException catch (_) {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text("Aucune connexion détecté.")));
  }
}

Future<void> signIn(
    String username, String password, String mail, BuildContext ctx) async {
  try {
    var response = await http
        .post(await getUri(path: "/api/user"), body: <String, dynamic>{
      "role": "2",
      "pseudo": username,
      "password": password,
      "mail": mail,
      "mode_quiz": "0"
    });

    print(response.body);
    print(response.statusCode);

    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    if (response.body.contains("pseudo") && response.statusCode != 200) {
      ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text("Ce pseudo a déjà été utilisé.")));
      return;
    } else if (response.body.contains("mail") && response.statusCode != 200) {
      ScaffoldMessenger.of(ctx)
          .showSnackBar(SnackBar(content: Text("Ce mail a déjà été utilisé.")));
      return;
    } else if (response.statusCode != 200) {
      ScaffoldMessenger.of(ctx)
          .showSnackBar(SnackBar(content: Text("Une erreur est survenu.")));
      return;
    }

    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text("Inscription réussie. Veuillez vous connecter.")));

    Navigator.pushReplacement(
        ctx, MaterialPageRoute(builder: (context) => LoginPage(username: username)));
  } on SocketException catch (_) {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text("Aucune connexion détecté.")));
  }
}

Future<void> postComment(
    String message, int idAnecdate, BuildContext ctx) async {
  try {
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
    ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text("Votre commentaire a été envoyé.")));
  } on SocketException catch (_) {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text("Aucune connexion détecté.")));
  }
}

Future<void> postReport(
    String comment, int idAnecdate, String object, BuildContext ctx) async {
  try {
    var response = await http
        .post(await getUri(path: "/api/report"), body: <String, dynamic>{
      "idAuthor": Globals.idUser.toString(),
      "comment": comment,
      "object": object,
      "idAnecdate": idAnecdate.toString()
    }, headers: {
      "Authorization": Globals.tokenAuth
    });

    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    if (response.statusCode != 200) {
      ScaffoldMessenger.of(ctx)
          .showSnackBar(SnackBar(content: Text("Une erreur est survenu.")));
      return;
    }
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text("Votre report a été envoyé.")));
    Navigator.pop(ctx);
  } on SocketException catch (_) {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text("Aucune connexion détecté.")));
  }
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
    BuildContext ctx) async {
  try {
    var request =
        http.MultipartRequest('POST', await getUri(path: "/api/anecdate"));

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

    request.files.add(await http.MultipartFile.fromPath("image", image.path));

    request.headers["Authorization"] = Globals.tokenAuth;

    var res = await request.send();
    var result = String.fromCharCodes(await res.stream.toBytes());
    print(result);

    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    if (res.statusCode != 200) {
      ScaffoldMessenger.of(ctx)
          .showSnackBar(SnackBar(content: Text("Une erreur est survenu.")));
      return;
    }
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text("Votre anec'date a été envoyé.")));

    Navigator.pop(ctx);
  } on SocketException catch (_) {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text("Aucune connexion détecté.")));
  }
}

Future<Map<String, dynamic>> getUser(int idUser) async {
  var response =
      await http.get(await getUri(path: "/api/user/" + idUser.toString()));
  return jsonDecode(response.body);
}

Future<void> changePassword(String password, BuildContext ctx) async {
  try {
    var response = await http.put(
        await getUri(path: "/api/user/" + Globals.idUser.toString()),
        body: <String, dynamic>{
          "password": password,
        },
        headers: {
          "Authorization": Globals.tokenAuth
        });

    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    if (response.statusCode != 200) {
      ScaffoldMessenger.of(ctx)
          .showSnackBar(SnackBar(content: Text("Une erreur est survenu.")));
      return;
    }
    ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text("Votre mot de passe a été modifié.")));
    Navigator.pop(ctx);
  } on SocketException catch (_) {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text("Aucune connexion détecté.")));
  }
}

Future<void> inactivateUser(BuildContext ctx) async {
  try {
    var response = await http.put(
        await getUri(path: "/api/user/" + Globals.idUser.toString()),
        body: <String, dynamic>{
          "status": "inactive",
        },
        headers: {
          "Authorization": Globals.tokenAuth
        });

    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    if (response.statusCode != 200) {
      ScaffoldMessenger.of(ctx)
          .showSnackBar(SnackBar(content: Text("Une erreur est survenu.")));
      return;
    }
    ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text("Votre compte a bien été désactivé.")));

    Globals.userName = "";
    Globals.isConnect = false;
    Globals.idUser = -1;
    Globals.tokenAuth = "";
    Globals.pushPreferences();

    Navigator.of(ctx).popUntil((route) => route.isFirst);
  } on SocketException catch (_) {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text("Aucune connexion détecté.")));
  }
}

Future<void> likeAnecdate(Anecdate anecdate, BuildContext ctx, {bool like = true}) async{
  try {
    var response = await http.put(
        await getUri(path: "/api/anecdate/" + anecdate.id.toString() + "/" + (like ? "" : "dis") + "like"),
        headers: {
          "Authorization": Globals.tokenAuth
        });

  } on SocketException catch (_) {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text("Aucune connexion détecté.")));
  }
}