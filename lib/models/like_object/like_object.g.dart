// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikeObject _$LikeObjectFromJson(Map<String, dynamic> json) => LikeObject(
      userId: json['userId'] as String,
      objectId: json['objectId'] as String,
      likeType: json['likeType'] as String,
      timeStamp: json['timeStamp'] as String,
    );

Map<String, dynamic> _$LikeObjectToJson(LikeObject instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'objectId': instance.objectId,
      'likeType': instance.likeType,
      'timeStamp': instance.timeStamp,
    };
