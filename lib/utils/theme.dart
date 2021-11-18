import 'package:flutter/material.dart';

class CustomTheme{

  static ThemeData lightTheme(){
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blueAccent,
      scaffoldBackgroundColor: Colors.grey,
      highlightColor: Colors.red,
      );
  }

  static ThemeData darkTheme(){
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blueAccent,
      scaffoldBackgroundColor: Colors.grey,
      highlightColor: Colors.red,
    );
  }

}