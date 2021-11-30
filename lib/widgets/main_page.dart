import 'dart:convert';

import 'package:anecdate_app/model/anecdate.dart';
import 'package:anecdate_app/utils/api.dart';
import 'package:anecdate_app/utils/globals.dart';
import 'package:anecdate_app/utils/shared_paramaters.dart';
import 'package:anecdate_app/widgets/app_bar.dart';
import 'package:anecdate_app/widgets/nav_menu.dart';
import 'package:anecdate_app/widgets/standard_card.dart';
import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:flutter/material.dart';
import 'package:anecdate_app/widgets/dependancies/build_transformer.dart';
import 'package:swipe/swipe.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {

  late BuildContext _ctx;

  @override
  void initState() {
    super.initState();
    SharedParameters.initializePreference().whenComplete((){
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return _createScaffold();
  }

  Scaffold _createScaffold(){
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: NavDrawer(),
      body: FutureBuilder<List<Anecdate>>(
        future: _getAnecdates(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          else if (!snapshot.hasData){
            return _createNoAnecdatePage();
          }
          else if (snapshot.connectionState == ConnectionState.done){
            return _createCards(snapshot.data!);
          }
          else if (snapshot.hasError) {
            return Text("Une erreur est survenue.");
          }
          return const CircularProgressIndicator();
        }

    ),
    );
  }

  Widget _createCards(List<Anecdate> anecdates) {
    return Swipe(
      onSwipeLeft: () {
        print("dislike");
      },
      onSwipeRight: () {
        print("like");
      },
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(_ctx).size.width,
        height: MediaQuery.of(_ctx).size.height,
        child: _createSwiper(anecdates),
      ),
    );
  }

  TransformerPageView _createSwiper(List<Anecdate> anecdates) {
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

  Future<List<Anecdate>> _getAnecdates() async{
    List<Anecdate> anecdates = [];
    List listAnecdateJson = await getAllAnecdates();
    for (var element in listAnecdateJson) {
      anecdates.add(Anecdate.fromJson(element));
    }
    return anecdates;
  }

  Widget _createNoAnecdatePage() {
    return Text("Il n'y a aucune Anecdate aujourd'hui.");
  }
}
