// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anecdate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Anecdate _$AnecdateFromJson(Map<String, dynamic> json) => Anecdate(
      id: json['id'] as int,
      status: json['status'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      idCategory: json['idCategory'] as int,
      description: json['description'] as String,
      sources: json['sources'] as String,
      idQuiz: json['idQuiz'] as int?,
      creationDate: DateTime.parse(json['creation_date'] as String),
      likes: json['likes'] as int,
      dislikes: json['dislikes'] as int,
      idAuthor: json['idAuthor'] as int,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$AnecdateToJson(Anecdate instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'title': instance.title,
      'date': instance.date.toIso8601String(),
      'idCategory': instance.idCategory,
      'description': instance.description,
      'sources': instance.sources,
      'idQuiz': instance.idQuiz,
      'creationDate': instance.creationDate.toIso8601String(),
      'likes': instance.likes,
      'dislikes': instance.dislikes,
      'idAuthor': instance.idAuthor,
      'image': instance.image,
    };
