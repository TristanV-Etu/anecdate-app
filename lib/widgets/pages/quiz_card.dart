import 'package:anecdate_app/model/anecdate.dart';
import 'package:anecdate_app/utils/globals.dart';
import 'package:anecdate_app/widgets/pages/report_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  late BuildContext _ctx;
  late Size _size;
  bool _alreadyAnswer = false;
  Color _defaulGoodColor = Colors.white;
  Color _defaulBad1Color = Colors.white;
  Color _defaulBad2Color = Colors.white;
  Color _defaulBad3Color = Colors.white;
  Map<String, Widget> _choice = {};

  QuizCardState(this.anecdate, this.quiz, this.order);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    _size = MediaQuery.of(context).size;
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
                Text(
                  anecdate.date.day.toString() +
                      " / " +
                      anecdate.date.month.toString(),
                ),
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Center(
                      child: Image.network(
                        anecdate.image!,
                        height: _size.height * 0.2,
                        width: _size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(anecdate.date.year.toString()),
                  ],
                ),
                Padding(
                  child: Text(quiz["question"].toString()),
                  padding: const EdgeInsets.all(20),
                ),
                const Divider(),
                _createFourAnswersWidgets(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createFourAnswersWidgets() {
    return Column(children: [
      Row(
        children: [_choice[order[0]]!, _choice[order[1]]!],
      ),
      Row(
        children: [_choice[order[2]]!, _choice[order[3]]!],
      ),
    ]);
  }

  void _getFourWidgets() {
    _choice["true_answer"] = _createGoodAnswer(quiz["true_answer"]!);
    _choice["wrong_answer1"] = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: _defaulBad1Color),
      onPressed: () {
        if (!_alreadyAnswer) {
          setState(() {
            _alreadyAnswer = true;
            _defaulGoodColor = Colors.green;
            _defaulBad1Color = Colors.red;
          });
        }
      },
      child: Text(
        quiz["wrong_answer1"]!,
        style: TextStyle(color: Colors.black),
      ),
    );
    _choice["wrong_answer2"] = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: _defaulBad2Color),
      onPressed: () {
        if (!_alreadyAnswer) {
          setState(() {
            _alreadyAnswer = true;
            _defaulGoodColor = Colors.green;
            _defaulBad2Color = Colors.red;
          });
        }
      },
      child: Text(
        quiz["wrong_answer2"]!,
        style: TextStyle(color: Colors.black),
      ),
    );
    _choice["wrong_answer3"] = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: _defaulBad3Color),
      onPressed: () {
        if (!_alreadyAnswer) {
          setState(() {
            _alreadyAnswer = true;
            _defaulGoodColor = Colors.green;
            _defaulBad3Color = Colors.red;
          });
        }
      },
      child: Text(
        quiz["wrong_answer3"]!,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _createGoodAnswer(String answer) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: _defaulGoodColor),
      onPressed: () {
        if (!_alreadyAnswer) {
          setState(() {
            _alreadyAnswer = true;
            _defaulGoodColor = Colors.green;
          });
        }
      },
      child: Text(answer, style: TextStyle(color: Colors.black)),
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
