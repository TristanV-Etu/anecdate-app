import 'package:json_annotation/json_annotation.dart';

part 'anecdate.g.dart';

@JsonSerializable()
class Anecdate {

  final int id;
  final String status;
  final String title;
  final DateTime date;
  final int idCategory;
  final String description;
  final String sources;
  final int? idQuiz;
  final DateTime creationDate;
  int likes;
  int dislikes;
  final int idAuthor;
  final String? image;

  Anecdate({
      required this.id,
      required this.status,
      required this.title,
      required this.date,
      required this.idCategory,
      required this.description,
      required this.sources,
      this.idQuiz,
      required this.creationDate,
      required this.likes,
      required this.dislikes,
      required this.idAuthor,
      this.image
      });


  factory Anecdate.fromJson(Map<String, dynamic> json) => _$AnecdateFromJson(json);

  Map<String, dynamic> toJson() => _$AnecdateToJson(this);

  static DateTime _fromJson(int int) => DateTime.fromMillisecondsSinceEpoch(int);
  static int _toJson(DateTime time) => time.millisecondsSinceEpoch;

  List<String> getSources() {
    return sources.split(" ");
  }

  void sendLike(){
    likes += 1;
  }
  void sendDislike(){
    dislikes += 1;
  }

}