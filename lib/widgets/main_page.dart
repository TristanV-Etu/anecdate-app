import 'dart:convert';

import 'package:anecdate_app/model/anecdate.dart';
import 'package:anecdate_app/utils/api.dart';
import 'package:anecdate_app/utils/globals.dart';
import 'package:anecdate_app/widgets/app_bar.dart';
import 'package:anecdate_app/widgets/nav_menu.dart';
import 'package:anecdate_app/widgets/standard_card.dart';
import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:flutter/material.dart';
import 'package:anecdate_app/widgets/dependancies/build_transformer.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {

  late List<Anecdate> anecdates;

  @override
  void initState() {
    access([]);
    Map<String, dynamic> map = jsonDecode(Globals.testJSON);
    anecdates = [];
    map["data"].forEach((element) => anecdates.add(Anecdate.fromJson(element)));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: NavDrawer(),
      body: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: createSwiper(),
      ),
    );
  }

  TransformerPageView createSwiper(){
    return TransformerPageView(
        loop: true,
        scrollDirection: Axis.vertical,
        transformer: DeepthPageTransformer(),
        itemBuilder: (BuildContext context, int index) {
          return StandardCard(anecdates[index]);
        },
        itemCount: anecdates.length,
    );
  }

}
