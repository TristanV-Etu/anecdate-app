import 'package:anecdate_app/utils/api.dart';
import 'package:anecdate_app/utils/globals.dart';
import 'package:anecdate_app/widgets/pages/change_pass_page.dart';
import 'package:flutter/material.dart';

import '../connection.dart';
import '../nav_menu.dart';

class AccountInfoPage extends StatelessWidget {
  late BuildContext _ctx;
  late Size _size;

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon compte'),
      ),
      body: _createPage(),
    );
  }

  Widget _createPage() {
    return Column(
      children: [
        _createCard(),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: Column(
            children: [
              Text(
                  "Désactiver le compte effacera vos commentatires et anecdotes et rendra l'accès à votre compte impossible."),
              SizedBox(
                height: 20,
              ),
              Text(
                  "Si vous souhaitez supprimer toutes vos données, meci de contacter le support:"),
              SizedBox(
                width: _size.width,
                child: Text(
                  "support-anecdate@gmail.com",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: ElevatedButton(
            onPressed: () => showDialog<String>(
              context: _ctx,
              builder: (BuildContext context) => AlertDialog(
                title: Text('Désactivation du compte'),
                content: SizedBox(
                  height: _size.height*0.3,
                  child: Column(children: [
                    SizedBox(
                      width: _size.width,
                      child: Text(
                        'Attention !',
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: _size.width,
                      child: Text(
                          "Cette action désactivera définitivement votre compte. Vous ne pourrez plus y accéder par la suite."),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: _size.width,
                      child: Text("Souhaitez-vous poursuivre ?"),
                    ),
                  ]),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      inactivateUser(context);
                    },
                    child: const Text('Désactiver'),
                  ),
                ],
              ),
            ),
            child: Text("Désactiver mon compte".toUpperCase()),
          ),
        ),
      ],
    );
  }

  Widget _createCard() {
    return SizedBox(
      width: _size.width,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Card(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: const Icon(
                      Icons.person_outlined,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Text("Mes informations"),
                  ),
                ],
              ),
              Divider(),
              FutureBuilder<Map<String, dynamic>>(
                  future: _getUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return createWaitProgress();
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return _createDataUser(snapshot.data!);
                    } else if (snapshot.hasError) {
                      return Text("Une erreur est survenue.");
                    }
                    return createWaitProgress();
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget _createDataUser(Map<String, dynamic> userInfo) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Pseudo :     ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(userInfo["pseudo"]),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                "Mail :     ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(userInfo["mail"]),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                "Mot de passe :     ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("******"),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      _ctx,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChangePassPage(userInfo["password"])));
                },
                child: Text("Changer mon mot de passe"),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> _getUser() async {
    return await getUser(Globals.idUser);
  }
}
