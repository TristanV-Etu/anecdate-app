import 'dart:async';
import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:anecdate_app/main.dart';
import 'package:anecdate_app/model/anecdate.dart';
import 'package:anecdate_app/utils/api.dart';
import 'package:anecdate_app/utils/globals.dart';
import 'package:anecdate_app/utils/notification_system.dart';
import 'package:anecdate_app/utils/shared_parameters.dart';
import 'package:anecdate_app/widgets/app_bar.dart';
import 'package:anecdate_app/widgets/dependancies/build_transformer.dart';
import 'package:anecdate_app/widgets/nav_menu.dart';
import 'package:anecdate_app/widgets/pages/quiz_card.dart';
import 'package:anecdate_app/widgets/pages/standard_card.dart';
import 'package:anecdate_app/widgets/pages/tuto_page.dart';
import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:flutter/material.dart';
import 'package:swipe/swipe.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  late TransformerPageController cardsController;
  bool firstUse = false;

  late BuildContext _ctx;

  void reload() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    cardsController = TransformerPageController();
    SharedParameters.initializePreference().whenComplete(() {
      setState(() {});
      if (Globals.firstUse) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => TutoPageFirstUse()));
      }
    });
    NotificationSystem.init();
    listenNotifications();
    streamController.stream.listen((event) {
      if (event == "reloadQuizz" && mounted) {
        reload();
      }
    });
  }

  void listenNotifications() =>
      NotificationSystem.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => MainPage()));

  @override
  void dispose() {
    super.dispose();
    cardsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Globals.sizeFontSystem = MediaQuery.of(context).textScaleFactor;
    _ctx = context;
    getQuizzOfTheDay();
    return _createScaffold();
  }

  Scaffold _createScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Globals.nameApp,
          textAlign: TextAlign.end,
        ),
      ),
      drawer: NavDrawer(),
      body: _createFutureBuilder(),
    );
  }

  FutureBuilder _createFutureBuilder() {
    if (!Globals.quizzMode) {
      return FutureBuilder<List<Anecdate>>(
          future: _getAnecdates(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return createWaitProgress();
            } else if (snapshot.data!.isEmpty) {
              return _createNoAnecdatePage(
                "Nous n'avons trouvé aucune Anec'Date pour vous aujourd'hui.",
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return _createCards(snapshot.data!);
            } else if (snapshot.hasError) {
              return Text("Une erreur est survenue.");
            }
            return createWaitProgress();
          });
    } else {
      return FutureBuilder<Map<Anecdate, dynamic>>(
          future: _getQuizAnecdates(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return createWaitProgress();
            } else if (snapshot.data!.isEmpty) {
              return _createNoAnecdatePage(
                "Nous n'avons trouvé aucune Anec'Date pour vous aujourd'hui.",
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return _createQuizzCards(snapshot.data!);
            } else if (snapshot.hasError) {
              return Text("Une erreur est survenue.");
            }
            return createWaitProgress();
          });
    }
  }

  Widget _createCards(List<Anecdate> anecdates) {
    return Swipe(
      onSwipeLeft: () {
        swipeLeftRight(like: false);
      },
      onSwipeRight: () {
        swipeLeftRight(like: true);
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
      //pageController: cardsController,
      onPageChanged: (index) {
        Globals.currentAnecdateIndex = index!;
      },
      loop: true,
      scrollDirection: Axis.vertical,
      transformer: DeepthPageTransformer(),
      itemBuilder: (BuildContext context, int index) {
        return StandardCard(anecdates[index]);
      },
      itemCount: anecdates.length,
    );
  }

  Widget _createQuizzCards(Map<Anecdate, dynamic> anecdates) {
    return Swipe(
      onSwipeLeft: () {
        swipeLeftRight(like: false);
      },
      onSwipeRight: () {
        swipeLeftRight(like: true);
      },
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(_ctx).size.width,
        height: MediaQuery.of(_ctx).size.height,
        child: _createQuizzSwiper(anecdates),
      ),
    );
  }

  TransformerPageView _createQuizzSwiper(Map<Anecdate, dynamic> anecdates) {
    return TransformerPageView(
      //pageController: cardsController,
      onPageChanged: (index) {
        Globals.currentAnecdateIndex = index!;
      },
      loop: true,
      scrollDirection: Axis.vertical,
      transformer: DeepthPageTransformer(),
      itemBuilder: (BuildContext context, int index) {
        Anecdate anecdate = anecdates.keys.toList()[index];
        Map<String, String> cleanMap = _createCleanMap(anecdates[anecdate][0]);
        return QuizCard(anecdate, cleanMap, _shuffleChoices(cleanMap));
      },
      itemCount: anecdates.length,
    );
  }

  Map<String, String> _createCleanMap(Map<String, dynamic> map) {
    Map<String, String> result = {};
    result["question"] = map["question"];
    result["true_answer"] = map["true_answer"];
    result["wrong_answer1"] = map["wrong_answer1"];
    result["wrong_answer2"] = map["wrong_answer2"];
    result["wrong_answer3"] = map["wrong_answer3"];
    return result;
  }

  List<String> _shuffleChoices(Map<String, String> map) {
    List<String> result = map.keys.toList();
    result.remove("question");
    result.shuffle();
    return result;
  }

  Future<List<Anecdate>> _getAnecdates() async {
    List<Anecdate> anecdates = [];
    Anecdate temp;
    try {
      List listAnecdateJson = await getAnecdatesOfTheDay();
      for (var element in listAnecdateJson) {
        temp = Anecdate.fromJson(element);
        Globals.currentsAnecdatesList.add(temp);
        anecdates.add(temp);
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(_ctx)
          .showSnackBar(SnackBar(content: Text("Aucune connexion détecté.")));
    }
    return anecdates;
  }

  Future<Map<Anecdate, dynamic>> _getQuizAnecdates() async {
    try {
      Map<Anecdate, dynamic> anecdates = await getQuizzOfTheDay();
      for (var element in anecdates.keys) {
        Globals.currentsAnecdatesList.add(element);
      }
      return anecdates;
    } on SocketException catch (_) {
      ScaffoldMessenger.of(_ctx)
          .showSnackBar(SnackBar(content: Text("Aucune connexion détecté.")));
      return {};
    }
  }

  Widget _createNoAnecdatePage(String msg) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              msg,
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void swipeLeftRight({like = true}) {
    Anecdate anecdate =
        Globals.currentsAnecdatesList[Globals.currentAnecdateIndex];

    String sendingMessage = "";
    if (Globals.isConnect) {
      if (!Globals.idAnecdateLike.contains(anecdate.id) &&
          !Globals.idAnecdateDislike.contains(anecdate.id)) {
        likeAnecdate(anecdate, _ctx, like: like);

        if (like) {
          Globals.idAnecdateLike.add(anecdate.id);
          sendingMessage += "like";
        } else {
          Globals.idAnecdateDislike.add(anecdate.id);
          sendingMessage += "dislike";
        }
      } else if (!Globals.idAnecdateLike.contains(anecdate.id) &&
          Globals.idAnecdateDislike.contains(anecdate.id) &&
          like) {
        unlikeAnecdate(anecdate, _ctx, like: !like);
        likeAnecdate(anecdate, _ctx, like: like);
        Globals.idAnecdateDislike.remove(anecdate.id);
        Globals.idAnecdateLike.add(anecdate.id);
        sendingMessage += "like removeDis";
      } else if (!Globals.idAnecdateLike.contains(anecdate.id) &&
          Globals.idAnecdateDislike.contains(anecdate.id) &&
          !like) {
        unlikeAnecdate(anecdate, _ctx, like: like);
        Globals.idAnecdateDislike.remove(anecdate.id);
        sendingMessage += "removeDis";
      } else if (Globals.idAnecdateLike.contains(anecdate.id) &&
          !Globals.idAnecdateDislike.contains(anecdate.id) &&
          like) {
        unlikeAnecdate(anecdate, _ctx, like: like);
        Globals.idAnecdateLike.remove(anecdate.id);
        sendingMessage += "removeLik";
      } else if (Globals.idAnecdateLike.contains(anecdate.id) &&
          !Globals.idAnecdateDislike.contains(anecdate.id) &&
          !like) {
        unlikeAnecdate(anecdate, _ctx, like: !like);
        likeAnecdate(anecdate, _ctx, like: like);
        Globals.idAnecdateLike.remove(anecdate.id);
        Globals.idAnecdateDislike.add(anecdate.id);
        sendingMessage += "dislike removeLik";
      }

      Globals.pushPreferences();

      streamController.add(sendingMessage);
    } else {
      ScaffoldMessenger.of(_ctx).showSnackBar(SnackBar(
          content: Text("Connectez-vous pour évaluer les Anec'dates.")));
    }
    // else {
    //   ScaffoldMessenger.of(_ctx).showSnackBar(
    //       SnackBar(content: Text("Vous avez déjà évalué cette Anec'date.")));
    // }
  }
}
