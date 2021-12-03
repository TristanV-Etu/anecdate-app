import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:anecdate_app/utils/api.dart';
import 'package:anecdate_app/utils/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedParameters {
  static SharedPreferences? pref;

  static Future<void> initializePreference() async {
    pref = await SharedPreferences.getInstance();

    if (pref!.getBool("firstUse") == null) {
      await _initializeFirstUse();
    }
    else {
      await _initializePrefInGlobals();
    }
  }

  static Future<void> _initializeFirstUse() async {
    await pref!.setBool("firstUse", true);

    await pref!.setBool("isConnect", Globals.isConnect);
    await changeUserName(Globals.userName);
    await changeidUser(Globals.idUser);
    await changeTokenAuth(Globals.tokenAuth);

    await changeIdAnecdateLike(Globals.idAnecdateLike);

    await pref!.setBool("quizzMode", Globals.quizzMode);

    await pref!.setBool("darkTheme", Globals.darkTheme);
    await pref!.setBool("swipeMode", Globals.swipeMode);
    await pref!.setBool("activeNotif", Globals.activeNotif);
    await changeHourNotif(Globals.hourNotif, Globals.minuteNotif);
    await changeDaysNotif(Globals.choiceDays);

    List<dynamic> categories = await getAllCategories();
    Map<String, dynamic> choiceCategories = {};
    Map<String, dynamic> idsCategories = {};
    for (var category in categories) {
      if (category["status"] == "active") {
        choiceCategories[category["name"]] = false;
        idsCategories[category["name"]] = category["id"];
      }
    }

    Globals.choiceCategories = choiceCategories;
    Globals.idsCategories = idsCategories;
    changeChoiceCategories(choiceCategories);
    changeIdsCategories(idsCategories);
  }


  static Future<void> _initializePrefInGlobals() async {
    try {
      Globals.isConnect = (pref!.getBool("isConnect"))!;
      Globals.userName = (pref!.getString("userName"))!;
      Globals.idUser = (pref!.getInt("idUser"))!;
      Globals.tokenAuth = (pref!.getString("tokenAuth"))!;

      Globals.idAnecdateLike = jsonDecode(pref!.getString("idAnecdateLike")!);

      Globals.quizzMode = (pref!.getBool("quizzMode"))!;

      Globals.darkTheme = (pref!.getBool("darkTheme"))!;
      Globals.swipeMode = (pref!.getBool("swipeMode"))!;
      Globals.activeNotif = (pref!.getBool("activeNotif"))!;

      Globals.hourNotif = (pref!.getInt("hourNotif"))!;
      Globals.minuteNotif = (pref!.getInt("minuteNotif"))!;

      Globals.choiceDays = jsonDecode(pref!.getString("choiceDays")!);

      Globals.choiceCategories = jsonDecode(pref!.getString("choiceCategories")!);
      Globals.idsCategories = jsonDecode(pref!.getString("idsCategories")!);

      Map<String, dynamic> choiceCategories = jsonDecode(pref!.getString("choiceCategories")!);
      Map<String, dynamic> idsCategories = jsonDecode(pref!.getString("idsCategories")!);
      List<dynamic> categories = await getAllCategories();

      if (categories.length != choiceCategories.length){
        _reloadCategories(categories, choiceCategories, idsCategories);
      }

      Globals.choiceCategories = jsonDecode(pref!.getString("choiceCategories")!);
      Globals.idsCategories = jsonDecode(pref!.getString("idsCategories")!);

    } on Exception catch (_) {
      initializePreference();
    }
  }

  static void _reloadCategories(List<dynamic> categories, Map<String, dynamic> choiceCategories, Map<String, dynamic> idsCategories) {
    // List<dynamic> copyCategories = json.decode(json.encode(categories));
    for (var category in categories) {
      if(category["status"] == "active" && choiceCategories.containsKey(category["name"])){
        choiceCategories[category["name"]] = false;
        idsCategories[category["name"]] = category["id"];
        // copyCategories.remove(category);
      }
    }
    //
    // if(copyCategories.isNotEmpty){
    //   for (var category in copyCategories) {
    //     choiceCategories.remove(category["name"]);
    //     idsCategories.remove(category["name"]);
    //   }
    // }

    changeChoiceCategories(choiceCategories);
    changeIdsCategories(idsCategories);
  }


  static Future<void> changeHourNotif(int hour, int minute) async {
    await pref!.setInt("hourNotif", hour);
    await pref!.setInt("minuteNotif", minute);
  }

  static Future<void> changeParamBoolean(String key) async {
    bool? current = await pref!.getBool(key);
    await pref!.setBool(key, !current!);
  }

  static Future<void> changeUserName(String username) async {
    await pref!.setString("userName", username);
  }

  static Future<void> changeidUser(int idUser) async {
    await pref!.setInt("idUser", idUser);
  }

  static Future<void> changeTokenAuth(String tokenAuth) async {
    await pref!.setString("tokenAuth", tokenAuth);
  }

  static Future<void> changeIdAnecdateLike(List<dynamic> list) async {
    String json = jsonEncode(list);
    await pref!.setString("idAnecdateLike", json);
  }

  static Future<void> changeDaysNotif(Map<String, dynamic> map) async {
    await _factorChangeMapAndKey(map, "choiceDays");
  }

  static Future<void> changeChoiceCategories(Map<String, dynamic> map) async {
    await _factorChangeMapAndKey(map, "choiceCategories");
  }

  static Future<void> changeIdsCategories(Map<String, dynamic> map) async {
    await _factorChangeMapAndKey(map, "idsCategories");
  }

  static Future<void> _factorChangeMapAndKey(Map map, String key) async {
    String json = jsonEncode(map);
    await pref!.setString(key, json);
  }

}
