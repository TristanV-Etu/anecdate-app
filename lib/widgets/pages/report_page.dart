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
        appBar: AppBar(
          title: Text("Signalement"),
        ),
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
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Vous souhaitez signaler cette Anec'Date ?",
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
          ),
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
        padding: EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Card(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Icon(
                      Icons.warning_outlined,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Text("Pour quelles raisons ?"),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade400,
                thickness: 1.5,
                indent: 40,
                endIndent: 0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 40, right: 6, bottom: 16),
                child: Column(
                  children: _createAllRadioButton(),
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
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
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
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Card(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Icon(
                      Icons.help_outlined,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Text("Quelque chose à ajouter ?"),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade400,
                thickness: 1.5,
                indent: 40,
                endIndent: 0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 40, right: 6, bottom: 16),
                child: TextFormField(
                    maxLength: 200,
                    controller: _comments,
                    validator: (value) {
                      if (value != null && value.length > 200) {
                        return "Veuillez mettre un commentaire de moins de 200 caractères.";
                      }
                      return null;
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createValidateButton() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Votre report en cours d'envoi...")));
            postReport(_comments.text, idAnecdate, _cause, _ctx);
          }
        },
        child: Text("ENVOYER"),
      ),
    );
  }
}
