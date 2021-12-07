import 'package:anecdate_app/utils/globals.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class CategoriesPage extends StatefulWidget {
  @override
  CategoriesPageState createState() => CategoriesPageState();
}

class CategoriesPageState extends State<CategoriesPage> {
  late Size _size;

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Catégories"),
      ),
      body: SingleChildScrollView(
        child: _createCard(),
      ),
    );
  }

  Widget _createCard() {
    return SizedBox(
      width: _size.width,
      child: Padding(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Card(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Icon(
                      Icons.grid_view_outlined,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Text("Catégories :"),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade400,
                thickness: 1.5,
                indent: 40,
                endIndent: 0,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: _createCategories(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createCategories() {
    List<Widget> list = [];

    Globals.choiceCategories.forEach((key, value) {
      list.add(
        Padding(
          padding: EdgeInsets.only(left: 16),
          child: ListTile(
            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
            leading: Checkbox(
                value: value,
                onChanged: (newBool) {
                  setState(() {
                    Globals.choiceCategories[key] = newBool ?? false;
                    Globals.pushPreferences();

                    streamController.add("reloadQuizz");
                  });
                }),
            title: Text(key),
          ),
        ),
      );
    });

    return Column(
      children: list,
    );
  }
}
