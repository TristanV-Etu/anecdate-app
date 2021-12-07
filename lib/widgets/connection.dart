import 'package:anecdate_app/utils/api.dart';
import 'package:anecdate_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:anecdate_app/utils/utils.dart';

class LoginPage extends StatefulWidget {
  String username;

  LoginPage({this.username = ""});

  @override
  LoginPageState createState() => LoginPageState(username);
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _username;
  late TextEditingController _password;
  String username;
  bool _obscureText = true;
  var _currentFocus;

  void _unfocus() {
    _currentFocus = FocusScope.of(context);

    if (!_currentFocus.hasPrimaryFocus) {
      _currentFocus.unfocus();
    }
  }

  LoginPageState(this.username);

  @override
  void initState() {
    super.initState();
    _username = TextEditingController();
    _username.text = username;
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocus,
      child: Scaffold(
        body: _createBody(context),
        appBar: AppBar(
          title: Text("Connexion"),
        ),
      ),
    );
  }

  Widget _createBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: SizedBox(
          height: size.height * 0.8,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(
                Globals.darkTheme
                    ? "assets/img/Anecdate-logo-dark.png"
                    : "assets/img/Anecdate-logo-light.png",
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: size.width * 0.9,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20, left: 20),
                        child: SizedBox(
                          width: size.width,
                          child: Text(
                            "Nom d'utilisateur",
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20, left: 20),
                        child: TextFormField(
                          controller: _username,
                          validator: (value) {
                            if (!isPseudoValid(value!)) {
                              return "Veuillez entrer un pseudo valide.";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 20),
                        child: SizedBox(
                          width: size.width,
                          child: Text(
                            "Mot de passe",
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20, left: 20),
                        child: TextFormField(
                          controller: _password,
                          obscureText: _obscureText,
                          validator: (value) {
                            if (!isPasswordValid(value!)) {
                              return "Veuillez entrer un mot de passe valide.";
                            }
                            return null;
                          },
                          cursorColor: Colors.redAccent,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        child: Row(
                          children: [
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("Connexion en cours...")));
                                    login(_username.text,
                                        cryptPassword(_password.text), context);
                                  }
                                },
                                child: Text("CONNEXION"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AlreadyHaveAnAccountCheck(),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _username;
  late TextEditingController _mail;
  late TextEditingController _password;
  bool _obscureText = true;
  var _currentFocus;

  void _unfocus() {
    _currentFocus = FocusScope.of(context);

    if (!_currentFocus.hasPrimaryFocus) {
      _currentFocus.unfocus();
    }
  }

  @override
  void initState() {
    super.initState();
    _username = TextEditingController();
    _mail = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _username.dispose();
    _mail.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocus,
      child: Scaffold(
        body: _createBody(context),
        appBar: AppBar(
          title: Text("Inscription"),
        ),
      ),
    );
  }

  Widget _createBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: SizedBox(
          width: size.width,
          height: size.height * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: size.width * 0.9,
                child: Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20, left: 20),
                          child: SizedBox(
                            width: size.width,
                            child: Text(
                              "Nom d'utilisateur",
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20, left: 20),
                          child: TextFormField(
                            controller: _username,
                            validator: (value) {
                              if (!isPseudoValid(value!)) {
                                return "Veuillez entrer un pseudo valide.";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20, left: 20),
                          child: SizedBox(
                            width: size.width,
                            child: Text(
                              "Adresse mail",
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20, left: 20),
                          child: TextFormField(
                            controller: _mail,
                            validator: (value) {
                              if (!isEmailValid(value!)) {
                                return "Veuillez entrer une adresse mail valide.";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20, left: 20),
                          child: SizedBox(
                            width: size.width,
                            child: Text(
                              "Mot de passe",
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20, left: 20),
                          child: TextFormField(
                            controller: _password,
                            obscureText: _obscureText,
                            validator: (value) {
                              if (!isPasswordValid(value!)) {
                                return "Minimum 6 caractères.";
                              }
                              return null;
                            },
                            cursorColor: Colors.redAccent,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20, left: 20),
                          child: SizedBox(
                            width: size.width,
                            child: Text(
                              "Confirmation du mot de passe",
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20, left: 20),
                          child: TextFormField(
                            obscureText: _obscureText,
                            validator: (value) {
                              if (value != _password.text) {
                                return "Veuillez entrer un mot de passe similaire.";
                              }
                              return null;
                            },
                            cursorColor: Colors.redAccent,
                          ),
                        ),
                        SizedBox(
                          width: size.width,
                          child: Row(
                            children: [
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      signIn(
                                          _username.text,
                                          cryptPassword(_password.text),
                                          _mail.text,
                                          context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Inscription en cours...")));
                                    }
                                  },
                                  child: Text("S'INSCRIRE"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AlreadyHaveAnAccountCheck(login: false),
            ],
          ),
        ),
      ),
    );
  }
}

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;

  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
  }) : super(key: key);

  void changePage(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return login ? SignUpPage() : LoginPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.grey.shade200),
                onPressed: () {
                  changePage(context);
                },
                child: Text(
                  login ? "Créer un compte".toUpperCase() : "Je suis déjà inscrit".toUpperCase(),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
