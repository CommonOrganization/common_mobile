// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notice _$NoticeFromJson(Map<String, dynamic> json) => Notice(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      timeStamp: json['timeStamp'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$NoticeToJson(Notice instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'timeStamp': instance.timeStamp,
      'content': instance.content,
    };
