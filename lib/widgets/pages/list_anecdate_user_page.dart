import 'package:anecdate_app/model/anecdate.dart';
import 'package:anecdate_app/utils/api.dart';
import 'package:anecdate_app/utils/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../nav_menu.dart';
import 'add_anecdate_page.dart';
import 'details_page.dart';

class ListAnecdateFromUserPage extends StatelessWidget {
  late BuildContext _ctx;
  late Size _size;

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Anec'dates"),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<Anecdate>>(
            future: _getAnecdatesfromUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return createWaitProgress();
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _createNoAnecdatePage(
                    "Vous n'avez posté aucune Anec'Date.");
              } else if (snapshot.connectionState == ConnectionState.done) {
                return _createCards(snapshot.data!);
              } else if (snapshot.hasError) {
                return Text("Une erreur est survenue.");
              }
              return createWaitProgress();
            }),
      ),
    );
  }

  Future<List<Anecdate>> _getAnecdatesfromUser() async {
    List<Anecdate> anecdates = [];
    List listAnecdateJson = await getAnecdatesFromUser();
    for (var element in listAnecdateJson) {
      anecdates.add(Anecdate.fromJson(element));
    }
    return anecdates;
  }

  Widget _createCards(List<Anecdate> list) {
    List<Widget> children = [];
    for (var element in list) {
      children.add(_createCard(element));
    }
    return Column(
      children: children,
    );
  }

  Widget _createCard(Anecdate anecdate) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(anecdate.date);
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: InkWell(
        onTap: () {
          Navigator.push(_ctx,
              MaterialPageRoute(builder: (context) => DetailsPage(anecdate)));
        },
        child: Card(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 4, 20),
                    child: Image.network(
                      anecdate.image!,
                      errorBuilder: (context, exception, stackTrace) {
                        return Image.asset(
                          "assets/img/image-not-found.png",
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        );
                      },
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: _size.width * 0.6,
                          child: Text(
                            anecdate.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: (Globals.sizeFontSystem <= 1) ? 2 : 1,
                            textAlign: TextAlign.left,
                            style: Theme.of(_ctx).textTheme.headline4,
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: _size.width * 0.4,
                            ),
                            Text(
                              formattedDate,
                              style:
                                  TextStyle(color: Theme.of(_ctx).primaryColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: _size.width,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: _createSubtitleCard(anecdate),
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createSubtitleCard(Anecdate anecdate) {
    if (anecdate.status == "active") {
      return Row(
        children: [
          Icon(Icons.thumb_up_alt_sharp),
          Text(" ${anecdate.likes}"),
          SizedBox(width: 20),
          Icon(Icons.thumb_down_alt_sharp),
          Text(" ${anecdate.dislikes}"),
          SizedBox(width: 20),
          FutureBuilder<int>(
              future: _getNumberComments(anecdate.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return createWaitProgress();
                } else if (!snapshot.hasData || snapshot.data == 0) {
                  return Text("Aucun commentaire.");
                } else if (snapshot.connectionState == ConnectionState.done) {
                  int nb = snapshot.data!;
                  return Text("$nb commentaire" + (nb > 1 ? "s" : "") + ".");
                } else if (snapshot.hasError) {
                  return Text("Une erreur est survenue.");
                }
                return createWaitProgress();
              }),
        ],
      );
    } else {
      return SizedBox(
        width: _size.width,
        child: Padding(
          padding: EdgeInsets.only(right: 20),
          child: Text(
            'En cours de modération.',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Globals.darkTheme
                    ? Colors.grey.shade200
                    : Colors.grey.shade600),
          ),
        ),
      );
    }
  }

  Future<int> _getNumberComments(int idAnecdate) async {
    return await getNumberCommentsFromAnecdate(idAnecdate);
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
              style: Theme.of(_ctx).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
