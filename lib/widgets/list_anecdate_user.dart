import 'package:anecdate_app/model/anecdate.dart';
import 'package:anecdate_app/model/comment.dart';
import 'package:anecdate_app/utils/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListAnecdateFromUser extends StatelessWidget {

  bool comments;
  late BuildContext _ctx;
  late Size _size;

  ListAnecdateFromUser({this.comments = false});

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: FutureBuilder<List<dynamic>>(
            future: comments ? _getComments() : _getAnecdates(),
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
      ),
    );
  }

  Future<List<Anecdate>> _getAnecdates() async{
    List<Anecdate> anecdates = [];
    List listAnecdateJson = await getAnecdatesFromUser();
    for (var element in listAnecdateJson) {
      anecdates.add(Anecdate.fromJson(element));
    }
    return anecdates;
  }

  Future<List<Comment>> _getComments() async{
    List<Comment> comments = [];
    List listCommentJson = await getAnecdatesWithCommentsFromUser();
    for (var element in listCommentJson) {
      comments.add(Comment.fromJson(element));
    }
    return comments;
  }

  Widget _createCards(List<dynamic> list) {
    List<Widget> children = [];
    for (var element in list) {
      children.add(_createCard(element));
    }
    return Column(
      children: children,
    );
  }

  Widget _createCard(dynamic element) {
    // String formattedDate = DateFormat('dd/MM/yyyy').format(anecdate.date);
    return Padding(
        padding: EdgeInsets.all(20),
      child: Container(
        child: Column(
          children: [
            // Row(
            //   children: [
            //     Image.network(
            //       anecdate.image!,
            //       height: _size.height * 0.1,
            //       width: _size.width*0.1,
            //       fit: BoxFit.cover,
            //     ),
            //     Column(
            //       children: [
            //         Text(anecdate.title),
            //         Text(formattedDate)
            //       ],
            //     )
            //   ],
            // ),
            // Row(
            //   children: comments ? _createCommentsSpecificField() : _createAnecdatesSpecificDate(),
            // ),
            // Divider(),
          ],
        )
      ),
    );
  }

  Widget _createNoAnecdatePage() {
    return comments ? Text("Vous n'avez aucune anecdate commentée.") : Text("Vous n'avez aucune anecdate postée.");
  }

  List<Widget> _createAnecdatesSpecificDate() {
    return [

    ];
  }

  List<Widget> _createCommentsSpecificField() {
    return [

    ];
  }

}