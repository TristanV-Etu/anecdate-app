import 'package:anecdate_app/utils/api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {

  final int id;
  final String status;
  final int idAuthor;
  final String message;
  final DateTime date;
  final int idAnecdate;


  Comment({required this.id, required this.status, required this.idAuthor, required this.message,required this.date, required this.idAnecdate});

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);

  static DateTime _fromJson(int int) => DateTime.fromMillisecondsSinceEpoch(int);
  static int _toJson(DateTime time) => time.millisecondsSinceEpoch;

  Future<String> getAuthorName() async {
    return (await getSpecificUserById(idAuthor))["pseudo"];
  }

}