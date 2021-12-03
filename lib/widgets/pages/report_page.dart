import 'package:anecdate_app/utils/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  int idAnecdate;

  ReportPage(this.idAnecdate, {Key? key}) : super(key: key);

  @override
  ReportPageState createState() => ReportPageState(idAnecdate);
}

class ReportPageState extends State<ReportPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _comments;
  late BuildContext _ctx;
  late Size _size;
  int idAnecdate;

  var _currentFocus;

  final List<String> _causes = [
    "Fausse Anec'date",
    "Fausse date",
    "Faux résumé",
    "Fausse(s) source(s)",
    "Image inapropriée"
  ];
  late String _cause;

  ReportPageState(this.idAnecdate);

  void _unfocus() {
    _currentFocus = FocusScope.of(_ctx);

    if (!_currentFocus.hasPrimaryFocus) {
      _currentFocus.unfocus();
    }
  }

  @override
  void initState() {
    super.initState();
    _comments = TextEditingController();
    _cause = _causes[0];
  }

  @override
  void dispose() {
    _comments.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    _size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: _unfocus,
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: _formKey,
          child: _createReportPage(),
        ),
      ),
    );
  }

  Widget _createReportPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text("Vous souhaitez signaler cette Anec'Date ?"),
          _createCausePart(),
          _createCommentPart(),
          _createValidateButton(),
        ],
      ),
    );
  }

  Widget _createCausePart() {
    return SizedBox(
      width: _size.width,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Card(
          child: Row(
            children: [
              const Icon(Icons.menu),
              Expanded(
                child: Column(
                  children: [
                    Text("Pour quelle raison ?"),
                    Divider(),
                    Column(
                      children: _createAllRadioButton(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _createAllRadioButton() {
    List<Widget> list = [];
    for (var cause in _causes) {
      list.add(_createRadio(cause));
    }
    return list;
  }

  Widget _createRadio(String cause) {
    return ListTile(
      title: Text(cause),
      leading: Radio<String>(
        value: cause,
        groupValue: _cause,
        onChanged: (String? value) {
          setState(() {
            _cause = value!;
            print(_cause);
          });
        },
      ),
    );
  }

  Widget _createCommentPart() {
    return SizedBox(
      width: _size.width,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Card(
          child: Row(
            children: [
              const Icon(Icons.menu),
              Expanded(
                child: Column(
                  children: [
                    Text("Quelque chose à ajouter ?"),
                    Divider(),
                    TextFormField(
                        controller: _comments,
                        validator: (value) {
                          if (value != null && value.length > 200) {
                            return "Veuillez mettre un commentaire de moins de 200 caractères.";
                          }
                          return null;
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createValidateButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Votre report en cours d'envoi...")));
            postReport(_comments.text, idAnecdate, _cause, _ctx);
        }
      },
      child: Text("Envoyer"),
    );
  }
}
