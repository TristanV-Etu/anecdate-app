import 'package:anecdate_app/model/anecdate.dart';
import 'package:anecdate_app/model/comment.dart';
import 'package:anecdate_app/utils/api.dart';
import 'package:anecdate_app/utils/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'details_page.dart';

class ListCommentsFromUserPage extends StatelessWidget {
  late BuildContext _ctx;
  late Size _size;

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: FutureBuilder<List<Comment>>(
            future: _getCommentsfromUser(),
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

  Future<List<Comment>> _getCommentsfromUser() async {
    List<Comment> comments = [];
    List listCommentJson = await getCommentsFromUser(Globals.idUser);
    for (var element in listCommentJson) {
      comments.add(Comment.fromJson(element));
    }
    return comments;
  }

  Future<Anecdate> _getAnecdateFromComment(Comment comment) async {
    return Anecdate.fromJson(await getSpecificAnecdate(comment.idAnecdate));
  }

  Widget _createCards(List<Comment> list) {
    List<Widget> children = [];
    for (var element in list) {
      children.add(FutureBuilder<Anecdate>(
          future: _getAnecdateFromComment(element),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }else if (snapshot.connectionState == ConnectionState.done) {
              return _createCard(snapshot.data!, element);
            } else if (snapshot.hasError) {
              return Text("Une erreur est survenue.");
            }
            return const CircularProgressIndicator();
          }));
    }
    return Column(
      children: children,
    );
  }

  Widget _createCard(Anecdate anecdate, Comment comment) {
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
              Text("${comment.message}"),
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
    return Text("Vous n'avez commenté aucune anec'date.");
  }
}
