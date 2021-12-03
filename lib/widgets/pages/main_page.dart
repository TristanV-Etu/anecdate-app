import 'package:anecdate_app/model/anecdate.dart';
import 'package:anecdate_app/utils/api.dart';
import 'package:anecdate_app/utils/globals.dart';
import 'package:anecdate_app/utils/shared_parameters.dart';
import 'package:anecdate_app/widgets/app_bar.dart';
import 'package:anecdate_app/widgets/dependancies/build_transformer.dart';
import 'package:anecdate_app/widgets/nav_menu.dart';
import 'package:anecdate_app/widgets/pages/standard_card.dart';
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

  late BuildContext _ctx;

  @override
  void initState() {
    super.initState();
    cardsController = TransformerPageController();
    SharedParameters.initializePreference().whenComplete(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    cardsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return _createScaffold();
  }

  Scaffold _createScaffold() {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: NavDrawer(),
      body: FutureBuilder<List<Anecdate>>(
          future: _getAnecdates(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (!snapshot.hasData) {
              return _createNoAnecdatePage();
            } else if (snapshot.connectionState == ConnectionState.done) {
              return _createCards(snapshot.data!);
            } else if (snapshot.hasError) {
              return Text("Une erreur est survenue.");
            }
            return const CircularProgressIndicator();
          }),
    );
  }

  Widget _createCards(List<Anecdate> anecdates) {
    return Swipe(
      onSwipeLeft: () {
        swipeLeftRight(like: false);
      },
      onSwipeRight: () {
        swipeLeftRight(like: true);
      },
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(_ctx).size.width,
            height: MediaQuery.of(_ctx).size.height * 0.8,
            child: _createSwiper(anecdates),
          ),
          TextButton(
              onPressed: () {
                //cardsController.nextPage(duration: Duration(milliseconds: 800), curve: Curves.ease);
              },
              child: Text("Test")),
        ],
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

  Future<List<Anecdate>> _getAnecdates() async {
    List<Anecdate> anecdates = [];
    Anecdate temp;
    List listAnecdateJson = await getAnecdatesOfTheDay();
    for (var element in listAnecdateJson) {
      temp = Anecdate.fromJson(element);
      Globals.currentsAnecdatesList.add(temp);
      anecdates.add(temp);
    }
    return anecdates;
  }

  Widget _createNoAnecdatePage() {
    return Text("Il n'y a aucune Anecdate aujourd'hui.");
  }

  void swipeLeftRight({like = true}) {
    print(Globals.idAnecdateLike);
    Anecdate anecdate =
        Globals.currentsAnecdatesList[Globals.currentAnecdateIndex];
    if (Globals.isConnect && !Globals.idAnecdateLike.contains(anecdate.id)) {
      likeAnecdate(anecdate, _ctx, like: like);
      Globals.idAnecdateLike.add(anecdate.id);
      Globals.pushPreferences();
    } else {
      ScaffoldMessenger.of(_ctx)
          .showSnackBar(SnackBar(content: Text("Vous avez déjà évalué cette Anec'date.")));
    }
  }
}
