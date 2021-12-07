import 'dart:async';

import 'package:anecdate_app/utils/globals.dart';
import 'package:anecdate_app/utils/theme.dart';
import 'package:anecdate_app/utils/utils.dart';
import 'package:anecdate_app/widgets/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/services.dart';


StreamController<String> streamController = StreamController.broadcast();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: CustomTheme.lightTheme(),
        dark: CustomTheme.darkTheme(),
        initial: Globals.darkTheme ? AdaptiveThemeMode.dark : AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
          title: Globals.nameApp,
          theme: theme,
          darkTheme: darkTheme,
          home: MainPage(),
        )
    );
  }
}


