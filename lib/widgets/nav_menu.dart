// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:anecdate_app/utils/globals.dart';
import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  NavDrawer({Key? key}) : super(key: key);

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
      _print4,
      _print5,
      _print6,
      _print7,
      _print8,
      _print9
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
        _createConnectButton("Connexion", (){ print("Connexion"); _pop();})
    );
    list.add(
        _createConnectButton("Se connecter", (){ print("Se connecter"); _pop();})
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

  void _print1(){print(1);_pop();}
  void _print2(){print(2);_pop();}
  void _print3(){print(3);_pop();}
  void _print4(){print(4);_pop();}
  void _print5(){print(5);_pop();}
  void _print6(){print(6);_pop();}
  void _print7(){print(7);_pop();}
  void _print8(){print(8);_pop();}
  void _print9(){print(9);_pop();}
  void _print10(){print(10);_pop();}
}
