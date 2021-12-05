import 'package:anecdate_app/model/anecdate.dart';
import 'package:anecdate_app/model/comment.dart';
import 'package:anecdate_app/utils/api.dart';
import 'package:anecdate_app/utils/globals.dart';
import 'package:anecdate_app/widgets/pages/report_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../connection.dart';

class DetailsPage extends StatefulWidget {
  Anecdate anecdate;

  DetailsPage(this.anecdate, {Key? key}) : super(key: key);

  @override
  DetailsPageState createState() => DetailsPageState(this.anecdate);
}

class DetailsPageState extends State<DetailsPage> {
  Anecdate anecdate;
  late BuildContext _ctx;
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
    print(anecdate.likes);
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
    _ctx = context;
    _size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: _unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Détails"),
        ),
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
      Row(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
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
                      borderRadius: BorderRadius.all(Radius.circular(12))),
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
          ),
          //Spacer(),
          Column(
            children: [
              Container(
                width: 100,
                height: 30,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  verticalDirection: VerticalDirection.down,
                  children: [
                    const Icon(Icons.thumb_up_alt_sharp),
                    Text("   " + anecdate.likes.toString()),
                  ],
                ),
              ),
              Container(
                width: 100,
                height: 30,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  verticalDirection: VerticalDirection.down,
                  children: [
                    const Icon(Icons.thumb_down_alt_sharp),
                    Text("   " + anecdate.dislikes.toString()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      Stack(
        alignment: Alignment.topLeft,
        children: [
          Center(
            child: Image.network(
              anecdate.image!,
              height: _size.height * 0.25,
              width: _size.width,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: _size.height * 0.202),
            child: Text(
              anecdate.date.year.toString(),
              style: Theme.of(context).textTheme.headline3,
            ),
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
          padding:
              const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
        ),
      ),
      const Divider(),
      Padding(
        child: Text(
          anecdate.description,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        padding: const EdgeInsets.all(16),
      ),
    ]);
  }

  void _addSources(List<Widget> list) {
    list.addAll([
      Divider(),
      Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          "Source(s) :",
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    ]);
    anecdate.getSources().forEach((element) {
      list.add(
        Padding(
          padding: EdgeInsets.only(top: 4, bottom: 4, left: 10, right: 10),
          child: Center(
            child: InkWell(
              child: Text(
                element,
                style: Theme.of(context).textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => launch(element),
            ),
          ),
        ),
      );
    });
  }

  void _addComments(List<Widget> list) {
    list.addAll([
      Divider(),
      Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          "Commentaire(s) :",
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
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
            _goToReportPage();
          },
          icon: const Icon(Icons.warning),
        )
      ],
    ));
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
