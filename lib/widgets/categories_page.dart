import 'package:anecdate_app/utils/globals.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  @override
  CategoriesPageState createState() => CategoriesPageState();
}

class CategoriesPageState extends State<CategoriesPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _createCategories(),
    );
  }

  Widget _createCategories() {
    List<Widget> list = [
      Text("Catégories :"),
    ];

    Globals.choiceCategories.forEach((key, value) {
      list.addAll([
        Checkbox(
            value: value,
            onChanged: (newBool) {
              setState(() {
                Globals.choiceCategories[key] = newBool ?? false;
                Globals.pushPreferences();
              });
            }),
        Text(key),
      ]);
    });

    return Column(
      children: list,
    );
  }

}