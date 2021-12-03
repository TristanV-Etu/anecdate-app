import 'package:anecdate_app/utils/api.dart';
import 'package:anecdate_app/utils/globals.dart';
import 'package:anecdate_app/widgets/pages/change_pass_page.dart';
import 'package:flutter/material.dart';

import '../connection.dart';

class AccountInfoPage extends StatelessWidget {
  late BuildContext _ctx;
  late Size _size;

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: _createPage(),
    );
  }

  Widget _createPage() {
    return Column(
      children: [
        _createCard(),
        Spacer(),
        Text("blablablabla"),
        ElevatedButton(
          onPressed: () => showDialog<String>(
            context: _ctx,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Désactivation du compte'),
              content: Column(children: [
                Text('Attention !'),
                Text("Cette action désactivera définitivement votre compte. Vous ne pourrez plus y accéder par la suite"),
                Text("Souhaitez-vous poursuivre ?"),
              ]),
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
          child: Text("Désactiver mon compte"),
        )
      ],
    );
  }

  Widget _createCard() {
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
                    Text("Mon compte"),
                    Divider(),
                    FutureBuilder<Map<String, dynamic>>(
                        future: _getUser(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return _createDataUser(snapshot.data!);
                          } else if (snapshot.hasError) {
                            return Text("Une erreur est survenue.");
                          }
                          return const CircularProgressIndicator();
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createDataUser(Map<String, dynamic> userInfo) {
    return Column(
      children: [
        Row(
          children: [
            Text("Pseudo :"),
            Text(userInfo["pseudo"]),
          ],
        ),
        Row(
          children: [
            Text("Mail :"),
            Text(userInfo["mail"]),
          ],
        ),
        Row(
          children: [
            Text("Mot de passe :"),
            Text("******"),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                _ctx,
                MaterialPageRoute(
                    builder: (context) =>
                        ChangePassPage(userInfo["password"])));
          },
          child: Text("Changer mon mot de passe"),
        )
      ],
    );
  }

  Future<Map<String, dynamic>> _getUser() async {
    return await getUser(Globals.idUser);
  }
}
