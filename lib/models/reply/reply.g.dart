// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reply _$ReplyFromJson(Map<String, dynamic> json) => Reply(
      dailyId: json['dailyId'] as String,
      commentId: json['commentId'] as String,
      id: json['id'] as String,
      writerId: json['writerId'] as String,
      timeStamp: json['timeStamp'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$ReplyToJson(Reply instance) => <String, dynamic>{
      'dailyId': instance.dailyId,
      'commentId': instance.commentId,
      'id': instance.id,
      'writerId': instance.writerId,
      'timeStamp': instance.timeStamp,
      'content': instance.content,
    };
