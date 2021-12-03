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
        appBar: AppBar(),
      ),
    );
  }

  Widget _createBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Se connecter",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.03),
          Text("Pseudo"),
          TextFormField(
            controller: _username,
            validator: (value) {
              if (!isPseudoValid(value!)) {
                return "Veuillez entrer un pseudo valide.";
              }
              return null;
            },
          ),
          Text("Mot de passe"),
          TextFormField(
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
                  color: Colors.redAccent,
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
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Connexion en cours...")));
                login(_username.text, cryptPassword(_password.text), context);
              }
            },
            child: Text("Se connecter"),
          ),
          SizedBox(height: size.height * 0.03),
          AlreadyHaveAnAccountCheck(),
        ],
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
        appBar: AppBar(),
      ),
    );
  }

  Widget _createBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Se connecter",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.03),
          Text("Pseudo"),
          TextFormField(
            controller: _username,
            validator: (value) {
              if (!isPseudoValid(value!)) {
                return "Veuillez entrer un pseudo valide.";
              }
              return null;
            },
          ),
          Text("Mail"),
          TextFormField(
            controller: _mail,
            validator: (value) {
              if (!isEmailValid(value!)) {
                return "Veuillez entrer une adresse mail valide.";
              }
              return null;
            },
          ),
          Text("Mot de passe"),
          TextFormField(
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
                  color: Colors.redAccent,
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
          Text("Confirmation Mot de passe"),
          TextFormField(
            obscureText: _obscureText,
            validator: (value) {
              if (value != _password.text) {
                return "Veuillez entrer un mot de passe similaire.";
              }
              return null;
            },
            cursorColor: Colors.redAccent,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                signIn(_username.text, cryptPassword(_password.text),
                    _mail.text, context);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Inscription en cours...")));
              }
            },
            child: Text("S'inscrire"),
          ),
          SizedBox(height: size.height * 0.03),
          AlreadyHaveAnAccountCheck(login: false),
        ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            changePage(context);
          },
          child: Text(
            login ? "S'inscrire" : "Se connecter",
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}