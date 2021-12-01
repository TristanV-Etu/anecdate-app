// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as int,
      status: json['status'] as String,
      idAuthor: json['idAuthor'] as int,
      message: json['message'] as String,
      idAnecdate: json['idAnecdate'] as int,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'idAuthor': instance.idAuthor,
      'message': instance.message,
      'idAnecdate': instance.idAnecdate,
    };
