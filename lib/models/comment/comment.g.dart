// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      dailyId: json['dailyId'] as String,
      id: json['id'] as String,
      writerId: json['writerId'] as String,
      timeStamp: json['timeStamp'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'dailyId': instance.dailyId,
      'id': instance.id,
      'writerId': instance.writerId,
      'timeStamp': instance.timeStamp,
      'content': instance.content,
    };
