import 'package:anecdate_app/model/anecdate.dart';
import 'package:anecdate_app/utils/shared_parameters.dart';

class Globals {
  static const String apiIP = "15.188.56.39";
  static const String apiPort = "8080";

  static bool firstUse = false;

  static String getApiAdresse() => apiIP + ":" + apiPort;

  static const String nameApp = "Anec'Date";
  static const String appMessage = "C'est l'heure de votre culture journalière !";

  // USER
  static bool isConnect = false;
  static String userName = "";
  static int idUser = -1;
  static String tokenAuth = "";

  static List<Anecdate> currentsAnecdatesList = [];
  static int currentAnecdateIndex = 0;

  static List<dynamic> idQuizAlreadyAnswered = [];

  static Map<String, dynamic> saveUserLikes = {};
  static Map<String, dynamic> saveUserDislikes = {};

  static List<dynamic> idAnecdateLike = [];
  static List<dynamic> idAnecdateDislike = [];

  static bool quizzMode = false;

  //CATEGORIES
  static Map<String, dynamic> choiceCategories = {};
  static Map<String, dynamic> idsCategories = {};

  //SETTINGS
  static bool darkTheme = false;
  static bool swipeMode = true;
  static late double sizeFontSystem;

  //NOTIFICATIONS
  static bool activeNotif = true;
  static int hourNotif = 12;
  static int minuteNotif = 0;
  static Map<String, dynamic> choiceDays = {
    "Lundi": true,
    "Mardi": true,
    "Mercredi": true,
    "Jeudi": true,
    "Vendredi": true,
    "Samedi": true,
    "Dimanche": true
  };
  static Map<String, int> datetimeDays = {
    "Lundi": DateTime.monday,
    "Mardi": DateTime.tuesday,
    "Mercredi": DateTime.wednesday,
    "Jeudi": DateTime.thursday,
    "Vendredi": DateTime.friday,
    "Samedi": DateTime.saturday,
    "Dimanche": DateTime.sunday
  };

  static List<int> getDaysNotifications() {
    List<int> result = [];
    choiceDays.forEach((key, value) {
      if (value) {
        result.add(datetimeDays[key]!);
      }
    });
    return result;
  }

  static Future<void> pushPreferences() async {
    await SharedParameters.pref!.setBool("isConnect", isConnect);
    await SharedParameters.changeUserName(userName);
    await SharedParameters.changeidUser(idUser);
    await SharedParameters.changeTokenAuth(tokenAuth);

    await SharedParameters.changeIdQuizAlreadyAnswered(idQuizAlreadyAnswered);

    await SharedParameters.changeSaveUserLikes(saveUserLikes);
    await SharedParameters.changeSaveUserDislikes(saveUserDislikes);

    await SharedParameters.changeIdAnecdateLike(idAnecdateLike);
    await SharedParameters.changeIdAnecdateDislike(idAnecdateDislike);

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
