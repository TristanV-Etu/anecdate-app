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
  final List<String> sources;
  final int? idQuizz;
  final DateTime creationDate;
  final int likes;
  final int dislikes;
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
      this.idQuizz,
      required this.creationDate,
      required this.likes,
      required this.dislikes,
      required this.idAuthor,
      this.image
      });


  factory Anecdate.fromJson(Map<String, dynamic> json) => _$AnecdateFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AnecdateToJson(this);

  static DateTime _fromJson(int int) => DateTime.fromMillisecondsSinceEpoch(int);
  static int _toJson(DateTime time) => time.millisecondsSinceEpoch;

}