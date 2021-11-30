// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:anecdate_app/utils/globals.dart';
import 'package:anecdate_app/widgets/about_page.dart';
import 'package:anecdate_app/widgets/categories_page.dart';
import 'package:anecdate_app/widgets/connection.dart';
import 'package:anecdate_app/widgets/settings_page.dart';
import 'package:anecdate_app/widgets/tuto_page.dart';
import 'package:flutter/material.dart';

class NavDrawer extends StatefulWidget {
  @override
  NavDrawerState createState() => NavDrawerState();
}

class NavDrawerState extends State<NavDrawer> {

  final List<String> _strings = [
    "Mon compte",
    "Commentaires",
    "Anec'dates",
    "Déconnexion",
    "Catégories",
    "Ajout",
    "Réglages",
    "Aide",
    "A propos"
];

  final List<Icon> _icons = [
    const Icon(Icons.menu),
    const Icon(Icons.menu),
    const Icon(Icons.menu),
    const Icon(Icons.menu),
    const Icon(Icons.menu),
    const Icon(Icons.menu),
    const Icon(Icons.menu),
    const Icon(Icons.menu),
    const Icon(Icons.menu)
  ];

  late BuildContext _ctx;
  late List<Function> _functions;

  @override
  Widget build(BuildContext context) {
    _functions = [
      _print1,
      _print2,
      _print3,
      _deconnection,
      _goToCategoriesPage,
      _goToAddAnecdatePage,
      _goToSettingsPage,
      _goToTutoPage,
      _goToAboutPage
    ];
    _ctx = context;
    return Drawer(
      child: ListView(children: _createList()),
    );
  }

  List<Widget> _createList() {
    List<Widget> list = [];
    int i = 0;

    if (! Globals.isConnect) {
      _addConnectPart(list);
      i = 4;
    }

    for(; i < _strings.length; i++) {
      if (i == 4 || i == 6) {
        list.add(const Divider());
      }
      list.add(_createTile(_strings[i], _icons[i], _functions[i]));
    }

    return list;
  }

  ListTile _createTile(String text, Icon icon, Function f) {
    return ListTile(
      title: Text(text),
      leading: icon,
      onTap: () {
        f.call();
      },
    );
  }

  List<Widget> _addConnectPart(List<Widget> list) {
    list.add(
        _createTile(_strings[0], _icons[0], _functions[0])
    );
    list.add(
        _createConnectButton("Connexion", (){
          _pop();
          Navigator.push(_ctx,
              MaterialPageRoute(builder: (context) => LoginPage()));
        })
    );
    list.add(
        _createConnectButton("Se connecter", (){
          _pop();
          Navigator.push(_ctx,
              MaterialPageRoute(builder: (context) => SignUpPage()));
        })
    );
    return list;
  }

  ListTile _createConnectButton(String text, Function f) {
    return ListTile(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(300)),

      ),
      tileColor: Colors.white,
      focusColor: Colors.redAccent,
      onTap: () {
        f.call();
      },
    );
  }

  void _pop(){
    Navigator.pop(_ctx);
  }

  void _goToCategoriesPage() {
    _pop();
    Navigator.push(_ctx,
        TransparentRoute(builder: (context) => CategoriesPage())
    );
  }

  void _goToAddAnecdatePage() {
    if (Globals.isConnect) {
      print("Add page");
    } else
    {
      _pop();
      Navigator.push(_ctx,
          MaterialPageRoute(builder: (context) => SignUpPage())
      );
    }
  }

  void _goToSettingsPage() {
    _pop();
    Navigator.push(_ctx,
        MaterialPageRoute(builder: (context) => SettingsPage())
    );
  }

  void _goToTutoPage() {
    _pop();
    Navigator.push(_ctx,
        TransparentRoute(builder: (context) => TutoPage())
    );
  }

  void _goToAboutPage() {
    _pop();
    Navigator.push(_ctx,
        MaterialPageRoute(builder: (context) => AboutPage())
    );
  }

  void _deconnection() {
    _pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vous vous êtes déconnecté.")));
    Globals.userName = "";
    Globals.isConnect = false;
    Globals.tokenAuth = "";
    Globals.pushPreferences();
  }



  void _print1(){print(1);_pop();}
  void _print2(){print(2);_pop();}
  void _print3(){print(3);_pop();}
}
