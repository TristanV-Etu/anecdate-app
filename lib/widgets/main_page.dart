import 'dart:convert';

import 'package:anecdate_app/model/anecdate.dart';
import 'package:anecdate_app/utils/globals.dart';
import 'package:anecdate_app/widgets/app_bar.dart';
import 'package:anecdate_app/widgets/standard_card.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {

  late List<Anecdate> anecdates;
  late BehaviorSubject<List<StandardCard>> cards;

  @override
  void initState() {
    Map<String, dynamic> map = jsonDecode(Globals.testJSON);
    anecdates = [];
    map["data"].forEach((element) => anecdates.add(Anecdate.fromJson(element)));
    cards = BehaviorSubject.seeded(createCards());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(),
      body: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.7,
        // Important to keep as a stack to have overlay of cards.
        child: StreamBuilder<List<Card>>(
          stream: cards,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return SizedBox();
            final data = snapshot.data;
            return Stack(
              children: data!,
            );
          },
        ),
      ),
    );
  }

  List<StandardCard> createCards() {
    List<StandardCard> list = [];
    anecdates.forEach((element) => list.add(StandardCard(element)));
    return list;
  }

}