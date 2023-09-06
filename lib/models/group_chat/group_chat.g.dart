// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupChat _$GroupChatFromJson(Map<String, dynamic> json) => GroupChat(
      id: json['id'] as String,
      title: json['title'] as String,
      authorId: json['authorId'] as String,
      connectedGatheringId: json['connectedGatheringId'] as String,
      userIdList: json['userIdList'] as String,
      timeStamp: json['timeStamp'] as String,
    );

Map<String, dynamic> _$GroupChatToJson(GroupChat instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'authorId': instance.authorId,
      'connectedGatheringId': instance.connectedGatheringId,
      'userIdList': instance.userIdList,
      'timeStamp': instance.timeStamp,
    };
