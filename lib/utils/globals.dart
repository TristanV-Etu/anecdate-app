import 'package:anecdate_app/model/anecdate.dart';
import 'package:anecdate_app/utils/shared_parameters.dart';

class Globals {
  static const String apiIP = "15.188.56.39";
  static const String apiPort = "8080";

  static String getApiAdresse() => apiIP + ":" + apiPort;

  static const String nameApp = "Anec'Date";

  // USER

  static bool isConnect = false;
  static String userName = "";
  static int idUser = -1;
  static String tokenAuth = "";

  static List<Anecdate> currentsAnecdatesList = [];
  static int currentAnecdateIndex = 0;

  static List<dynamic> idAnecdateLike = [];

  static bool quizzMode = false;

  //CATEGORIES
  static Map<String, dynamic> choiceCategories = {};
  static Map<String, dynamic> idsCategories = {};

  //SETTINGS
  static bool darkTheme = false;
  static bool swipeMode = true;
  static bool activeNotif = true;
  static int hourNotif = 7;
  static int minuteNotif = 30;
  static Map<String, dynamic> choiceDays = {
    "Lundi": false,
    "Mardi": false,
    "Mercredi": false,
    "Jeudi": false,
    "Vendredi": false,
    "Samedi": false,
    "Dimanche": false
  };

  static Future<void> pushPreferences() async {
    await SharedParameters.pref!.setBool("isConnect", isConnect);
    await SharedParameters.changeUserName(userName);
    await SharedParameters.changeidUser(idUser);
    await SharedParameters.changeTokenAuth(tokenAuth);

    await SharedParameters.changeIdAnecdateLike(idAnecdateLike);

    await SharedParameters.pref!.setBool("quizzMode", quizzMode);

    await SharedParameters.pref!.setBool("darkTheme", darkTheme);
    await SharedParameters.pref!.setBool("swipeMode", swipeMode);
    await SharedParameters.pref!.setBool("activeNotif", activeNotif);
    await SharedParameters.changeHourNotif(hourNotif, minuteNotif);
    await SharedParameters.changeDaysNotif(choiceDays);

    await SharedParameters.changeChoiceCategories(choiceCategories);
    await SharedParameters.changeIdsCategories(idsCategories);
  }
}
