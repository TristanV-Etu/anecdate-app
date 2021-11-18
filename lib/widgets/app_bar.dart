import 'package:anecdate_app/utils/globals.dart';
import 'package:flutter/material.dart';

AppBar createAppBar(){
  return AppBar(
    title: const Text( Globals.nameApp ),

    leading: IconButton(
      onPressed: () {
        print("menu");
      },
        icon: const Icon(Icons.menu),
    ),
  );
}