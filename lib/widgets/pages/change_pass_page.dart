import 'package:anecdate_app/utils/api.dart';
import 'package:anecdate_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangePassPage extends StatefulWidget {
  String passwordCrypt;

  ChangePassPage(this.passwordCrypt, {Key? key}) : super(key: key);

  @override
  ChangePassPageState createState() => ChangePassPageState(passwordCrypt);
}

class ChangePassPageState extends State<ChangePassPage> {
  late BuildContext _ctx;
  late Size _size;
  String passwordCrypt;

  bool _obscureOld = true;
  bool _obscureNew = true;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _oldPassword;
  late TextEditingController _newPassword;

  var _currentFocus;

  ChangePassPageState(this.passwordCrypt);

  void _unfocus() {
    _currentFocus = FocusScope.of(context);

    if (!_currentFocus.hasPrimaryFocus) {
      _currentFocus.unfocus();
    }
  }

  @override
  void initState() {
    super.initState();
    _oldPassword = TextEditingController();
    _newPassword = TextEditingController();
  }

  @override
  void dispose() {
    _oldPassword.dispose();
    _newPassword.dispose();
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
        body: SingleChildScrollView(
          child: _createCard(),
        ),
      ),
    );
  }

  Widget _createCard() {
    return Form(
      key: _formKey,
      child: SizedBox(
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
                      Text("Changement de mot de passe"),
                      Divider(),
                      Text("Ancien mot de passe"),
                      TextFormField(
                        obscureText: _obscureOld,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.visibility,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureOld = !_obscureOld;
                              });
                            },
                          ),
                          border: OutlineInputBorder(),
                        ),
                        controller: _oldPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "N'oubliez pas d'entrer votre précédent mot de passe.";
                          }
                          String oldPassCrypt = cryptPassword(value);
                          if (oldPassCrypt != passwordCrypt) {
                            return "Ce mot de passe ne correspond pas à votre ancien mot de passe.";
                          }
                          return null;
                        },
                      ),
                      Text("Nouveau mot de passe"),
                      TextFormField(
                        obscureText: _obscureNew,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.visibility,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureNew = !_obscureNew;
                              });
                            },
                          ),
                          border: OutlineInputBorder(),
                        ),
                        controller: _newPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "N'oubliez pas de mettre un nouveau mot de passe.";
                          } else if (!isPasswordValid(value)) {
                            return "Veuillez mettre un mot de passe valide de plus de 6 caractères.";
                          }
                          return null;
                        },
                      ),
                      Text("Confirmation mot de passe"),
                      TextFormField(
                        obscureText: _obscureNew,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value != _newPassword.text) {
                            return "Veuillez entrer un mot de passe similaire..";
                          }
                          return null;
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Changement en cours...")));
                            changePassword(
                                cryptPassword(_newPassword.text), _ctx);
                          }
                        },
                        child: Text("Changer"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
