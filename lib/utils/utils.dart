import 'package:crypt/crypt.dart';

bool isPseudoValid(String? pseudo) {
  if (pseudo == null || pseudo.isEmpty) return false;
  String pattern = r'^[a-zA-Z0-9_.-]+$';
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(pseudo) && pseudo.length < 20;
}

bool isPasswordValid(String password) => password.length > 5;

bool isEmailValid(String? email) {
  if (email == null || email.isEmpty) return false;
  String pattern = r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(email);
}

String cryptPassword(String password) {
  return Crypt.sha256(password, salt: "anecdate").toString();
}

bool isAdressWebValid(String? web) {
  if (web == null || web.isEmpty) return false;
  String pattern = r'(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)$';
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(web);
}

bool isQuestionValid(String? question) {
  if (question == null || question.isEmpty) return true;
  String pattern = r'\?(.*)$';
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(question);
}