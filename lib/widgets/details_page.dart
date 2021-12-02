import 'package:anecdate_app/model/anecdate.dart';
import 'package:anecdate_app/model/comment.dart';
import 'package:anecdate_app/utils/api.dart';
import 'package:anecdate_app/utils/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsPage extends StatefulWidget {
  Anecdate anecdate;

  DetailsPage(this.anecdate, {Key? key}) : super(key: key);

  @override
  DetailsPageState createState() => DetailsPageState(this.anecdate);
}

class DetailsPageState extends State<DetailsPage> {
  Anecdate anecdate;
  late Size _size;
  List<Widget> _comments = [];

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _commentEdit;

  var _currentFocus;

  void _unfocus() {
    _currentFocus = FocusScope.of(context);

    if (!_currentFocus.hasPrimaryFocus) {
      _currentFocus.unfocus();
    }
  }

  DetailsPageState(this.anecdate);

  @override
  void initState() {
    super.initState();
    _commentEdit = TextEditingController();
    _callApiComments();
  }

  @override
  void dispose() {
    _commentEdit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: _unfocus,
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: _createCard(),
        ),
      ),
    );
  }

  Widget _createCard() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(26),
        child: SizedBox(
          width: _size.width,
          child: Card(
            elevation: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: _createChildren(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _createChildren() {
    List<Widget> list = [];
    _addDetails(list);
    _addSources(list);
    _addComments(list);
    _addReport(list);
    return list;
  }

  void _addDetails(List<Widget> list) {
    list.addAll([
      Row(children: [
        Text(anecdate.date.day.toString() +
            " / " +
            anecdate.date.month.toString()),
        Spacer(),
        Text("Lik:" + anecdate.likes.toString()),
        Text("Dis:" + anecdate.dislikes.toString()),
      ]),
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
        child: Text(anecdate.title),
        padding: const EdgeInsets.all(20),
      ),
      const Divider(),
      Padding(
        child: Text(
          anecdate.description,
        ),
        padding: const EdgeInsets.all(16),
      ),
    ]);
  }

  void _addSources(List<Widget> list) {
    list.addAll([
      Divider(),
      Text("Source(s) :"),
    ]);
    anecdate.getSources().forEach((element) {
      list.add(InkWell(child: Text(element), onTap: () => launch(element)));
    });
  }

  void _addComments(List<Widget> list) {
    list.addAll([
      Divider(),
      Text("Commentaire(s) :"),
    ]);
    if (Globals.isConnect) {
      list.add(_postCommentBloc());
    }
    list.add(Column(
      children: _comments,
    ));
    _callApiComments();
  }

  void _callApiComments() {
    _comments = [];
    _comments.add(
      FutureBuilder<List<Comment>>(
          future: _getComments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text("Aucun commentaires");
            } else if (snapshot.connectionState == ConnectionState.done) {
              return _createAllcommentsBlocs(snapshot.data!);
            } else if (snapshot.hasError) {
              return Text("Une erreur est survenue.");
            }
            return const CircularProgressIndicator();
          }),
    );
  }

  Future<List<Comment>> _getComments() async {
    List<Comment> comments = [];
    List listCommentJson = await getCommentsFromAnecdate(anecdate.id);

    for (var element in listCommentJson) {
      comments.add(Comment.fromJson(element));
    }
    return comments;
  }

  Widget _createCommentBloc(Comment comment) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(comment.date);
    return Container(
        color: Colors.cyan,
        child: Padding(
            padding: EdgeInsets.all(26),
            child: Column(
              children: [
                Row(
                  children: [
                    FutureBuilder<String>(
                        future: comment.getAuthorName(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.data!.isNotEmpty) {
                            return Text("${snapshot.data}");
                          }
                          return Text("Anonyme");
                        }),
                    Spacer(),
                    Text(formattedDate),
                  ],
                ),
                Text(comment.message),
              ],
            )));
  }

  Widget _createAllcommentsBlocs(List<Comment> comments) {
    List<Widget> commentsWidget = [];
    for (var element in comments) {
      commentsWidget.add(_createCommentBloc(element));
    }
    return Column(
      children: commentsWidget,
    );
  }

  Widget _postCommentBloc() {
    int textLength = 0;
    return Column(
      children: [
        TextFormField(
          maxLines: null,
          controller: _commentEdit,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Veuillez entrer un commentaire valide.";
            } else if (value.length > 255) {
              textLength = value.length - 255;
              return "255 caractères maximum. (Il y a $textLength en trop)";
            }
            return null;
          },
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              postComment(_commentEdit.text, anecdate.id, context);
              _commentEdit.text = "";
              setState(() {
                _callApiComments();
              });
            }
          },
          child: Text("Envoyer"),
        ),
      ],
    );
  }

  void _addReport(List<Widget> list) {
    list.add(Row(
      children: [
        const Spacer(),
        IconButton(
          onPressed: () {
            print("report ${anecdate.title}");
          },
          icon: const Icon(Icons.warning),
        )
      ],
    ));
  }
}
