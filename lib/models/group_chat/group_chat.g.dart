// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupChat _$GroupChatFromJson(Map<String, dynamic> json) => GroupChat(
      id: json['id'] as String,
      title: json['title'] as String,
      userIdList: json['userIdList'] as List<dynamic>,
      timeStamp: json['timeStamp'] as String,
    );

Map<String, dynamic> _$GroupChatToJson(GroupChat instance) => <String, dynamic>{
      'id': instance.id,
      'userIdList': instance.userIdList,
      'title': instance.title,
      'timeStamp': instance.timeStamp,
    };
