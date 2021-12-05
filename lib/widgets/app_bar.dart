import 'package:anecdate_app/utils/globals.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends AppBar{
  CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text( Globals.nameApp ),

      // leading: IconButton(
      //   onPressed: () {
      //     print("menu");
      //   },
      //     icon: const Icon(Icons.menu),
      // ),
    );
  }
}

class CustomReturnAppBar extends AppBar {
  CustomReturnAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text( Globals.nameApp ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
          icon: const Icon(Icons.menu),
      ),
    );
  }
}