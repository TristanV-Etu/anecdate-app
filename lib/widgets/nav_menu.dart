// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:anecdate_app/utils/globals.dart';
import 'package:anecdate_app/widgets/connection.dart';
import 'package:anecdate_app/widgets/pages/about_page.dart';
import 'package:anecdate_app/widgets/pages/account_info_page.dart';
import 'package:anecdate_app/widgets/pages/categories_page.dart';
import 'package:anecdate_app/widgets/pages/list_anecdate_user_page.dart';
import 'package:anecdate_app/widgets/pages/list_comments_user_page.dart';
import 'package:anecdate_app/widgets/pages/main_page.dart';
import 'package:anecdate_app/widgets/pages/settings_page.dart';
import 'package:anecdate_app/widgets/pages/tuto_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';
import 'pages/add_anecdate_page.dart';

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
    const Icon(
      Icons.manage_accounts_outlined,
    ),
    const Icon(
      Icons.chat_outlined,
    ),
    const Icon(
      Icons.star_outlined,
    ),
    const Icon(
      Icons.power_settings_new_outlined,
    ),
    const Icon(
      Icons.grid_view_outlined,
    ),
    const Icon(
      Icons.add_circle_outline_outlined,
    ),
    const Icon(
      Icons.settings_outlined,
    ),
    const Icon(
      Icons.help_outlined,
    ),
    const Icon(
      Icons.lightbulb_outlined,
    ),
  ];

  late BuildContext _ctx;
  late Size _size;
  late List<Function> _functions;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _functions = [
      _goToAccountPage,
      _goToCommentsPage,
      _goToAnecdatesPage,
      deconnection,
      _goToCategoriesPage,
      _goToAddAnecdatePage,
      _goToSettingsPage,
      _goToTutoPage,
      _goToAboutPage
    ];
    _ctx = context;
    _size = MediaQuery.of(context).size;
    return Container(
      width: _size.width * ((Globals.sizeFontSystem <= 1) ? 0.65 : 0.7),
      height: _size.height,
      child: Drawer(
        child: ListView(children: _createList()),
      ),
    );
  }

  List<Widget> _createList() {
    List<Widget> list = [];
    int i = 0;

    if (!Globals.isConnect) {
      _addConnectPart(list);
      i = 4;
    } else {
      list.add(_createTile(
          Globals.userName,
          Icon(
            Icons.person_outlined,
          ),
          () {}));
      list.add(const Divider());
    }

    for (; i < _strings.length; i++) {
      if (i == 4 || i == 6) {
        list.add(const Divider());
      }
      list.add(_createTile(_strings[i], _icons[i], _functions[i]));
    }

    list.add(Opacity(opacity: 0, child: ListTile()));
    list.add(_createQuizButton());

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
    list.add(_createTile(
        _strings[0],
        Icon(
          Icons.person_outlined,
        ),
        () {}));
    list.add(_createConnectButton("CONNEXION", () {
      _pop();
      Navigator.push(
          _ctx, MaterialPageRoute(builder: (context) => LoginPage()));
    }));
    list.add(_createConnectButton("S'INSCRIRE", () {
      _pop();
      Navigator.push(
          _ctx, MaterialPageRoute(builder: (context) => SignUpPage()));
    }));
    return list;
  }

  ListTile _createConnectButton(String text, Function f) {
    return ListTile(
      title: ElevatedButton(
        onPressed: () { f.call(); },
        child: Text(text),
      ),
    );
  }

  ListTile _createQuizButton() {
    return ListTile(
      title: Row(
        children: [
          Text("Mode quiz"),
          Switch(
            value: Globals.quizzMode,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (value) {
              setState(() {
                Globals.quizzMode = value;
                Globals.pushPreferences();
              });
              streamController.add("reloadQuizz");
            },
          ),
        ],
      ),
      leading: Icon(
        Icons.quiz_outlined,
      ),
    );
  }

  void _pop() {
    Navigator.pop(_ctx);
  }

  void _goToAccountPage() {
    _pop();
    Navigator.push(
        _ctx, MaterialPageRoute(builder: (context) => AccountInfoPage()));
  }

  void _goToCommentsPage() {
    _pop();
    Navigator.push(_ctx,
        MaterialPageRoute(builder: (context) => ListCommentsFromUserPage()));
  }

  void _goToAnecdatesPage() {
    _pop();
    Navigator.push(_ctx,
        MaterialPageRoute(builder: (context) => ListAnecdateFromUserPage()));
  }

  void _goToCategoriesPage() {
    _pop();
    Navigator.push(
        _ctx, MaterialPageRoute(builder: (context) => CategoriesPage()));
  }

  void _goToAddAnecdatePage() {
    if (Globals.isConnect) {
      _pop();
      Navigator.push(
          _ctx, MaterialPageRoute(builder: (context) => AddAnecdatePage()));
    } else {
      _pop();
      Navigator.push(
          _ctx, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  void _goToSettingsPage() {
    _pop();
    Navigator.push(
        _ctx, MaterialPageRoute(builder: (context) => SettingsPage()));
  }

  void _goToTutoPage() {
    _pop();
    Navigator.push(_ctx, TransparentRoute(builder: (context) => TutoPage()));
  }

  void _goToAboutPage() {
    _pop();
    Navigator.push(_ctx, MaterialPageRoute(builder: (context) => AboutPage()));
  }

  void deconnection() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Vous avez été déconnecté.")));
    Globals.saveUserLikes[Globals.userName] = Globals.idAnecdateLike;
    Globals.saveUserDislikes[Globals.userName] = Globals.idAnecdateDislike;
    Globals.userName = "";
    Globals.isConnect = false;
    Globals.idUser = -1;
    Globals.tokenAuth = "";
    Globals.idAnecdateLike = [];
    Globals.idAnecdateDislike = [];
    Globals.pushPreferences();

    streamController.add("reloadQuizz");
  }
}

Widget createWaitProgress(){
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
    ),
  );
}
