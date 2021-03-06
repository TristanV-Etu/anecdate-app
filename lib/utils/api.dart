import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:anecdate_app/model/anecdate.dart';
import 'package:anecdate_app/utils/globals.dart';
import 'package:anecdate_app/widgets/connection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../main.dart';

List<dynamic> getListIdCategoriesChoices() {
  List<dynamic> categories = [];

  Globals.choiceCategories.forEach((key, value) {
    if (value){
      categories.add(Globals.idsCategories[key]);
    }
  });

  return categories;
}

Future<Uri> getUri(
    {required String path, Map<String, dynamic>? queryParam}) async {
  return Uri.http(Globals.getApiAdresse(), path, queryParam);
}

Future<List<dynamic>> getAnecdatesOfTheDay() async {
  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  var response = await http.get(await getUri(path: "/api/anecdate/date/" + date));
  List<dynamic> categories = getListIdCategoriesChoices();
  List<dynamic> result = [];

  for (var element in jsonDecode(response.body)) {
    if (categories.contains(element["idCategory"]) && element["status"] == "active") {
      result.add(element);
    }
  }
  return result;
}

Future<Map<Anecdate, dynamic>> getQuizzOfTheDay() async {
  Map<Anecdate, dynamic> result = {};
  Anecdate temp;

  List list = await getAnecdatesOfTheDay();
  for (var element in list) {
    temp = Anecdate.fromJson(element);
    if(temp.idQuiz != null) {
      var response = await http.get(await getUri(path: "/api/anecdate/" + temp.idQuiz.toString() + "/quiz"));
      result[temp] = jsonDecode(response.body);
    }
  }
  return result;
}

Future<Map<String, dynamic>> getSpecificAnecdate(int idAnecdate) async {
  var response = await http.get(await getUri(path: "/api/anecdate/" + idAnecdate.toString()));
  return jsonDecode(response.body);
}

Future<List<dynamic>> getCommentsFromUser(int idAuthor) async {
  var response = await http.get(await getUri(path: "/api/user/" + idAuthor.toString() + "/comments"));
  List<dynamic> result = [];

  for (var element in jsonDecode(response.body)) {
    if (element["status"] == "active") {
      result.add(element);
    }
  }
  return result;
}

Future<List<dynamic>> getAnecdatesFromUser() async {
  var response = await http
      .get(await getUri(path: "/api/user/${Globals.idUser}/anecdates"));
  List<dynamic> result = [];

  for (var element in jsonDecode(response.body)) {
    if (element["status"] == "active" || element["status"] == "waiting") {
      result.add(element);
    }
  }
  return result;
}

Future<List<dynamic>> getCommentsFromAnecdate(int idAnecdate) async {
  var response = await http.get(await getUri(
      path: "/api/anecdate/" + idAnecdate.toString() + "/comments"));
  List<dynamic> result = [];

  for (var element in jsonDecode(response.body)) {
    if (element["status"] == "active") {
      result.add(element);
    }
  }
  return result;
}

Future<int> getNumberCommentsFromAnecdate(int idAnecdate) async {
  var response = await http.get(await getUri(
      path: "/api/anecdate/" + idAnecdate.toString() + "/comments"));
  List<dynamic> result = [];

  for (var element in jsonDecode(response.body)) {
    if (element["status"] == "active") {
      result.add(element);
    }
  }
  return result.length;
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

      Globals.idAnecdateLike = Globals.saveUserLikes[username] ?? [];
      Globals.idAnecdateDislike = Globals.saveUserDislikes[username] ?? [];

      Globals.pushPreferences();
    }

    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    if (result["message"] == "Account disactivate") {
      ScaffoldMessenger.of(ctx)
          .showSnackBar(SnackBar(content: Text("Compte d??sactiv??.")));
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
        SnackBar(content: Text("Connexion r??ussie. Bonjour $username.")));

    streamController.add("reloadQuizz");
    Navigator.pop(ctx);
  } on SocketException catch (_) {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text("Aucune connexion d??tect??.")));
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

    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    if (response.body.contains("pseudo") && response.statusCode != 200) {
      ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text("Ce pseudo a d??j?? ??t?? utilis??.")));
      return;
    } else if (response.body.contains("mail") && response.statusCode != 200) {
      ScaffoldMessenger.of(ctx)
          .showSnackBar(SnackBar(content: Text("Ce mail a d??j?? ??t?? utilis??.")));
      return;
    } else if (response.statusCode != 200) {
      ScaffoldMessenger.of(ctx)
          .showSnackBar(SnackBar(content: Text("Une erreur est survenu.")));
      return;
    }

    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text("Inscription r??ussie. Veuillez vous connecter.")));

    Navigator.pushReplacement(
        ctx, MaterialPageRoute(builder: (context) => LoginPage(username: username)));
  } on SocketException catch (_) {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text("Aucune connexion d??tect??.")));
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
        SnackBar(content: Text("Votre commentaire a ??t?? envoy??.")));
  } on SocketException catch (_) {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text("Aucune connexion d??tect??.")));
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
        .showSnackBar(SnackBar(content: Text("Votre report a ??t?? envoy??.")));
    Navigator.pop(ctx);
  } on SocketException catch (_) {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text("Aucune connexion d??tect??.")));
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

    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    if (res.statusCode != 200) {
      ScaffoldMessenger.of(ctx)
          .showSnackBar(SnackBar(content: Text("Une erreur est survenu.")));
      return;
    }
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text("Votre anec'date a ??t?? envoy??.\nElle est actuellement en mod??ration pour la mettre en ligne.")));

    Navigator.pop(ctx);
  } on SocketException catch (_) {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text("Aucune connexion d??tect??.")));
  }
}


Future<void> updateAnecDate(
    int id,
    String title,
    String date,
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
    http.MultipartRequest('POST', await getUri(path: "/api/anecdate/" + id.toString()));

    request.fields["title"] = title;
    request.fields["date"] = date;
    request.fields["description"] = desc;
    request.fields["sources"] = sources;
    request.fields["question"] = question!;
    request.fields["true_answer"] = goodAnswer!;
    request.fields["wrong_answer1"] = bad1Answer!;
    request.fields["wrong_answer2"] = bad2Answer!;
    request.fields["wrong_answer3"] = bad3Answer!;

    request.headers["Authorization"] = Globals.tokenAuth;

    var res = await request.send();

    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    if (res.statusCode != 200) {
      ScaffoldMessenger.of(ctx)
          .showSnackBar(SnackBar(content: Text("Une erreur est survenu.")));
      return;
    }
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text("Votre anec'date a ??t?? modifi??.")));

    Navigator.pop(ctx);
  } on SocketException catch (_) {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text("Aucune connexion d??tect??.")));
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
        SnackBar(content: Text("Votre mot de passe a ??t?? modifi??.")));
    Navigator.pop(ctx);
  } on SocketException catch (_) {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text("Aucune connexion d??tect??.")));
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
        SnackBar(content: Text("Votre compte a bien ??t?? d??sactiv??.")));

    Globals.userName = "";
    Globals.isConnect = false;
    Globals.idUser = -1;
    Globals.tokenAuth = "";
    Globals.pushPreferences();

    Navigator.of(ctx).popUntil((route) => route.isFirst);
  } on SocketException catch (_) {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text("Aucune connexion d??tect??.")));
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
        .showSnackBar(SnackBar(content: Text("Aucune connexion d??tect??.")));
  }
}

Future<void> unlikeAnecdate(Anecdate anecdate, BuildContext ctx, {bool like = true}) async{
  try {
    var response = await http.put(
        await getUri(path: "/api/anecdate/" + anecdate.id.toString() + "/un" + (like ? "" : "dis") + "like"),
        headers: {
          "Authorization": Globals.tokenAuth
        });

  } on SocketException catch (_) {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text("Aucune connexion d??tect??.")));
  }
}