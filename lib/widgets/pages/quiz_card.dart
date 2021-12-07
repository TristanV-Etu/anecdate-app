import 'package:anecdate_app/model/anecdate.dart';
import 'package:anecdate_app/utils/globals.dart';
import 'package:anecdate_app/widgets/pages/report_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../connection.dart';
import 'details_page.dart';

class QuizCard extends StatefulWidget {
  Anecdate anecdate;
  Map<String, String> quiz;
  List<String> order;

  QuizCard(this.anecdate, this.quiz, this.order);

  @override
  QuizCardState createState() => QuizCardState(anecdate, quiz, order);
}

class QuizCardState extends State<QuizCard> {
  Anecdate anecdate;
  Map<String, String> quiz;
  List<String> order;
  double _hiddenLike = 0;
  double _hiddenDislike = 0;

  late BuildContext _ctx;
  late Size _size;
  bool _alreadyAnswer = false;
  Color _defaultGoodColor = Colors.grey.shade200;
  Color _defaultBad1Color = Colors.grey.shade200;
  Color _defaultBad2Color = Colors.grey.shade200;
  Color _defaultBad3Color = Colors.grey.shade200;
  Map<String, Widget> _choice = {};

  QuizCardState(this.anecdate, this.quiz, this.order);


  void initLike() {
    if (Globals.isConnect) {
      if (Globals.idAnecdateLike.contains(anecdate.id)) {
        _hiddenLike = 1;
        _hiddenDislike = 0;
      } else if (Globals.idAnecdateDislike.contains(anecdate.id)) {
        _hiddenLike = 0;
        _hiddenDislike = 1;
      } else {
        _hiddenLike = 0;
        _hiddenDislike = 0;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initLike();
    if (Globals.idQuizAlreadyAnswered.contains(anecdate.id)) {
      _alreadyAnswer = true;
      _defaultGoodColor = Colors.green;
    }
      streamController.stream.listen((event) {
        if (((event as String).contains("like") ||
            (event as String).contains("dislike") ||
            (event as String).contains("removeLik") ||
            (event as String).contains("removeDis")) &&
            mounted) {
          reload();
        }
      });
    }

    void reload() =>
        setState(() {
          initLike();
        });


    @override
    Widget build(BuildContext context) {
      _ctx = context;
      _size = MediaQuery
          .of(context)
          .size;
      _getFourWidgets();
      return InkWell(
        onTap: () {
          if (_alreadyAnswer) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DetailsPage(anecdate)));
          }
        },
        child: Padding(
          padding: EdgeInsets.all(26),
          child: SizedBox(
            height: _size.height * 0.7,
            width: _size.width,
            child: Card(
              elevation: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RotationTransition(
                        turns: new AlwaysStoppedAnimation(340 / 360),
                        child: Opacity(
                          opacity: _hiddenDislike,
                          child: Container(
                            width: 50,
                            height: 50,
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: Colors.red,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                            child: Center(
                              child: Icon(
                                Icons.thumb_down_alt_sharp,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: _size.width * 0.45,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            border: Border.all(width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(
                                14))),
                        child: Center(
                          child: Container(
                            width: _size.width * 0.45,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(width: 2),
                                borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                            child: Center(
                              child: Text(
                                anecdate.date.day.toString() +
                                    " / " +
                                    anecdate.date.month.toString(),
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .headline2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      RotationTransition(
                        turns: new AlwaysStoppedAnimation(20 / 360),
                        child: Opacity(
                          opacity: _hiddenLike,
                          child: Container(
                            width: 50,
                            height: 50,
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: Colors.green,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                            child: Center(
                              child: Icon(
                                Icons.thumb_up_alt_sharp,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Center(
                        child: Image.network(
                          anecdate.image!,
                          errorBuilder: (context, exception, stackTrace) {
                            return Image.asset(
                              "assets/img/image-not-found.png",
                              height: _size.height * 0.25,
                              width: _size.width,
                              fit: BoxFit.cover,
                            );
                          },
                          height: _size.height * 0.25,
                          width: _size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        anecdate.date.year.toString(),
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline3,
                      ),
                    ],
                  ),
                  Center(
                    child: Padding(
                      child: Text(
                        quiz["question"].toString(),
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline4,
                        textAlign: TextAlign.center,
                      ),
                      padding: const EdgeInsets.only(left: 20, right: 20),
                    ),
                  ),
                  const Divider(),
                  _createFourAnswersWidgets(),
                  Row(
                    children: [
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          _goToReportPage();
                        },
                        icon: const Icon(Icons.warning),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget _createFourAnswersWidgets() {
      return Column(children: [
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [_choice[order[0]]!, _choice[order[1]]!],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [_choice[order[2]]!, _choice[order[3]]!],
          ),
        ),
      ]);
    }

    void _getFourWidgets() {
      _choice["true_answer"] = _createGoodAnswer(quiz["true_answer"]!);
      _choice["wrong_answer1"] = ElevatedButton(
        style: ElevatedButton.styleFrom(primary: _defaultBad1Color),
        onPressed: () {
          if (!_alreadyAnswer) {
            Globals.idQuizAlreadyAnswered.add(anecdate.id);
            setState(() {
              _alreadyAnswer = true;
              _defaultGoodColor = Colors.green;
              _defaultBad1Color = Colors.red;
            });
          }
        },
        child: Container(
          height: 60,
          width: 100,
          child: Center(
            child: Text(
              quiz["wrong_answer1"]!,
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
      _choice["wrong_answer2"] = ElevatedButton(
        style: ElevatedButton.styleFrom(primary: _defaultBad2Color),
        onPressed: () {
          Globals.idQuizAlreadyAnswered.add(anecdate.id);
          if (!_alreadyAnswer) {
            setState(() {
              _alreadyAnswer = true;
              _defaultGoodColor = Colors.green;
              _defaultBad2Color = Colors.red;
            });
          }
        },
        child: Container(
          height: 60,
          width: 100,
          child: Center(
            child: Text(
              quiz["wrong_answer2"]!,
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
      _choice["wrong_answer3"] = ElevatedButton(
        style: ElevatedButton.styleFrom(primary: _defaultBad3Color),
        onPressed: () {
          if (!_alreadyAnswer) {
            Globals.idQuizAlreadyAnswered.add(anecdate.id);
            setState(() {
              _alreadyAnswer = true;
              _defaultGoodColor = Colors.green;
              _defaultBad3Color = Colors.red;
            });
          }
        },
        child: Container(
          height: 60,
          width: 100,
          child: Center(
            child: Text(
              quiz["wrong_answer3"]!,
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    Widget _createGoodAnswer(String answer) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(primary: _defaultGoodColor),
        onPressed: () {
          Globals.idQuizAlreadyAnswered.add(anecdate.id);
          if (!_alreadyAnswer) {
            setState(() {
              _alreadyAnswer = true;
              _defaultGoodColor = Colors.green;
            });
          }
        },
        child: Container(
          height: 60,
          width: 100,
          child: Center(
            child: Text(answer, style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,),
          ),
        ),
      );
    }

    void _goToReportPage() {
      if (Globals.isConnect) {
        Navigator.push(_ctx,
            MaterialPageRoute(builder: (context) => ReportPage(anecdate.id)));
      } else {
        Navigator.push(
            _ctx, MaterialPageRoute(builder: (context) => SignUpPage()));
      }
    }
  }
