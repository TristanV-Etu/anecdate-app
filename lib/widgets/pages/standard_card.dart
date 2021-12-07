import 'dart:async';

import 'package:anecdate_app/main.dart';
import 'package:anecdate_app/model/anecdate.dart';
import 'package:anecdate_app/utils/globals.dart';
import 'package:anecdate_app/widgets/pages/details_page.dart';
import 'package:anecdate_app/widgets/pages/report_page.dart';
import 'package:flutter/material.dart';

import '../connection.dart';

class StandardCard extends StatefulWidget {
  final Anecdate anecdate;

  StandardCard(this.anecdate);

  @override
  StandardCardState createState() => StandardCardState(anecdate);
}

class StandardCardState extends State<StandardCard> {
  final Anecdate anecdate;
  late BuildContext _ctx;
  late Size _size;
  double _hiddenLike = 0;
  double _hiddenDislike = 0;

  StandardCardState(this.anecdate);

  @override
  void initState() {
    super.initState();
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

  void reload() => setState(() { initLike(); });

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
  Widget build(BuildContext context) {
    initLike();
    _ctx = context;
    _size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DetailsPage(anecdate)));
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
                          borderRadius: BorderRadius.all(Radius.circular(14))),
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
                              style: Theme.of(context).textTheme.headline2,
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
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ],
                ),
                Center(
                  child: Padding(
                    child: Text(
                      anecdate.title,
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center,
                    ),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                  ),
                ),
                const Divider(),
                Padding(
                  child: Text(
                    anecdate.description,
                    style: Theme.of(context).textTheme.bodyText2,
                    maxLines: (Globals.sizeFontSystem <= 1) ? 8 : 6,
                    overflow: TextOverflow.ellipsis,
                  ),
                  padding: const EdgeInsets.all(16),
                ),
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
