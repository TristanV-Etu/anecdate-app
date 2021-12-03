import 'package:anecdate_app/model/anecdate.dart';
import 'package:anecdate_app/utils/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'details_page.dart';

class ListAnecdateFromUserPage extends StatelessWidget {
  late BuildContext _ctx;
  late Size _size;

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: FutureBuilder<List<Anecdate>>(
            future: _getAnecdatesfromUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _createNoAnecdatePage();
              } else if (snapshot.connectionState == ConnectionState.done) {
                return _createCards(snapshot.data!);
              } else if (snapshot.hasError) {
                return Text("Une erreur est survenue.");
              }
              return const CircularProgressIndicator();
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
      padding: EdgeInsets.all(20),
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
                  Image.network(
                    anecdate.image!,
                    height: _size.height * 0.1,
                    width: _size.width * 0.1,
                    fit: BoxFit.cover,
                  ),
                  Column(
                    children: [Text(anecdate.title), Text(formattedDate)],
                  )
                ],
              ),
              Row(
                children: [
                  Text("lik: ${anecdate.likes}"),
                  Text("dis: ${anecdate.dislikes}"),
                  FutureBuilder<int>(
                      future: _getNumberComments(anecdate.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (!snapshot.hasData || snapshot.data == 0) {
                          return Text("Aucun commentaire");
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          int nb = snapshot.data!;
                          return Text(
                              "$nb commentaire" + (nb > 1 ? "s" : "") + ".");
                        } else if (snapshot.hasError) {
                          return Text("Une erreur est survenue.");
                        }
                        return const CircularProgressIndicator();
                      }),
                ],
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> _getNumberComments(int idAnecdate) async {
    return await getNumberCommentsFromAnecdate(idAnecdate);
  }

  Widget _createNoAnecdatePage() {
    return Text("Vous n'avez aucune anecdate postée.");
  }
}
