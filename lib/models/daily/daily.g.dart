// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Daily _$DailyFromJson(Map<String, dynamic> json) => Daily(
      id: json['id'] as String,
      organizerId: json['organizerId'] as String,
      category: json['category'] as String,
      detailCategory: json['detailCategory'] as String,
      dailyType: json['dailyType'] as String,
      connectedClubGatheringId: json['connectedClubGatheringId'] as String?,
      mainImage: json['mainImage'] as String,
      imageList: json['imageList'] as List<dynamic>,
      content: json['content'] as String,
      tagList: json['tagList'] as List<dynamic>,
      timeStamp: json['timeStamp'] as String,
    );

Map<String, dynamic> _$DailyToJson(Daily instance) => <String, dynamic>{
      'id': instance.id,
      'organizerId': instance.organizerId,
      'category': instance.category,
      'detailCategory': instance.detailCategory,
      'dailyType': instance.dailyType,
      'connectedClubGatheringId': instance.connectedClubGatheringId,
      'mainImage': instance.mainImage,
      'imageList': instance.imageList,
      'content': instance.content,
      'tagList': instance.tagList,
      'timeStamp': instance.timeStamp,
    };
