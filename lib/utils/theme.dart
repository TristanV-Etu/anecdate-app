import 'package:flutter/material.dart';

class CustomTheme {
  static final Color mainColor = Color(0xFF880E0E);
  static final Color backgroundColor = Color(0xFFDCC8C8);

  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: mainColor,
      scaffoldBackgroundColor: backgroundColor,
      highlightColor: Colors.red,
      iconTheme: IconThemeData(
        color: Colors.black
      ),
      appBarTheme: AppBarTheme(
        color: mainColor,
      ),
      dividerTheme: const DividerThemeData(
        color: Colors.red,
        thickness: 2,
        indent: 20,
        endIndent: 20,
      ),
      textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        headline2: TextStyle(
            fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.black),
        headline3: TextStyle(
            fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white),
        headline4: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        bodyText1: TextStyle(fontSize: 20.0, fontFamily: 'Hind'),
        bodyText2: TextStyle(fontSize: 15.0, fontFamily: 'Hind'),
        subtitle1: TextStyle(fontSize: 14.0, decoration: TextDecoration.underline,fontStyle: FontStyle.italic, color: Colors.blue)
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.grey,
      scaffoldBackgroundColor: Colors.red,
      highlightColor: Colors.green,
      appBarTheme: AppBarTheme(
        color: Colors.grey,
      ),
      dividerTheme: const DividerThemeData(
        color: Colors.black,
        thickness: 2,
        indent: 20,
        endIndent: 20,
      ),
      textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        headline2: TextStyle(
            fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.white),
        headline3: TextStyle(
            fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white),
        headline4: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        bodyText1: TextStyle(fontSize: 20.0, fontFamily: 'Hind'),
        bodyText2: TextStyle(fontSize: 15.0, fontFamily: 'Hind'),
      ),
    );
  }
}
