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
      iconTheme: IconThemeData(color: Colors.black),
      appBarTheme: AppBarTheme(
        color: mainColor,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF880E0E),
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
          headline4: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          headline5: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          bodyText1: TextStyle(fontSize: 20.0, fontFamily: 'Hind'),
          bodyText2: TextStyle(fontSize: 15.0, fontFamily: 'Hind'),
          subtitle2: TextStyle(
              fontSize: 14.0,
              decoration: TextDecoration.underline,
              fontStyle: FontStyle.italic,
              color: Colors.blue)),
      inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFE4E4E4),
          hintStyle:
              TextStyle(fontSize: 15.0, fontFamily: 'Hind', color: Colors.grey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          border: UnderlineInputBorder()),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: mainColor,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all<Color>(mainColor),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all<Color>(mainColor),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all<Color>(mainColor),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.grey.shade900,
      scaffoldBackgroundColor: mainColor,
      highlightColor: Colors.green,
      iconTheme: IconThemeData(color: Colors.white),
      appBarTheme: AppBarTheme(
        color: Colors.grey.shade900,
      ),
      dividerTheme: const DividerThemeData(
        color: Colors.grey,
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
          headline5: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        bodyText1: TextStyle(fontSize: 20.0, fontFamily: 'Hind'),
        bodyText2: TextStyle(fontSize: 15.0, fontFamily: 'Hind'),
          subtitle2: TextStyle(
              fontSize: 14.0,
              decoration: TextDecoration.underline,
              fontStyle: FontStyle.italic,
              color: Colors.blue)),
      inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.black,
          hintStyle:
          TextStyle(fontSize: 15.0, fontFamily: 'Hind', color: Colors.black),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          border: UnderlineInputBorder(),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: Colors.grey.shade900,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all<Color>(mainColor),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all<Color>(mainColor),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all<Color>(mainColor),
      ),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

}
