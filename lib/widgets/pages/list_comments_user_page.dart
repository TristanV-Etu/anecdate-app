import 'package:anecdate_app/model/anecdate.dart';
import 'package:anecdate_app/model/comment.dart';
import 'package:anecdate_app/utils/api.dart';
import 'package:anecdate_app/utils/globals.dart';
import 'package:anecdate_app/widgets/nav_menu.dart';
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
      appBar: AppBar(
        title: Text("Commentaires"),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<Comment>>(
            future: _getCommentsfromUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return createWaitProgress();
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _createNoAnecdatePage(
                    "Vous n'avez commenté aucune Anec'Date.");
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
              return createWaitProgress();
            } else if (snapshot.connectionState == ConnectionState.done) {
              if ((snapshot.data! as Anecdate).status == "active") {
                return _createCard(snapshot.data!, element);
              } else {
                return SizedBox();
              }
            } else if (snapshot.hasError) {
              return Text("Une erreur est survenue.");
            }
            return createWaitProgress();
          }));
    }
    return Column(
      children: children,
    );
  }

  Widget _createCard(Anecdate anecdate, Comment comment) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(anecdate.date);
    return Padding(
      padding: EdgeInsets.fromLTRB(20,20,20,0),
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
                            SizedBox(width: _size.width*0.4,),
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
                  child: Text('" ${comment.message} "', textAlign: TextAlign.left, style: TextStyle(color: Globals.darkTheme ? Colors.grey.shade200 : Colors.grey.shade600),),
                ),
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
