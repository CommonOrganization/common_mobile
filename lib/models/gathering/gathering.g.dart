// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gathering.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gathering _$GatheringFromJson(Map<String, dynamic> json) => Gathering(
      id: json['id'] as String,
      organizerId: json['organizerId'] as String,
      category: json['category'] as String,
      detailCategory: json['detailCategory'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      mainImage: json['mainImage'] as String,
      gatheringImage: (json['gatheringImage'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      recruitWay: json['recruitWay'] as String,
      recruitQuestion: json['recruitQuestion'] as String,
      capacity: json['capacity'] as int,
      tagList:
          (json['tagList'] as List<dynamic>).map((e) => e as String).toList(),
      memberList: (json['memberList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      timeStamp: json['timeStamp'] as String,
    );

Map<String, dynamic> _$GatheringToJson(Gathering instance) => <String, dynamic>{
      'id': instance.id,
      'organizerId': instance.organizerId,
      'category': instance.category,
      'detailCategory': instance.detailCategory,
      'title': instance.title,
      'content': instance.content,
      'mainImage': instance.mainImage,
      'gatheringImage': instance.gatheringImage,
      'recruitWay': instance.recruitWay,
      'recruitQuestion': instance.recruitQuestion,
      'capacity': instance.capacity,
      'tagList': instance.tagList,
      'memberList': instance.memberList,
      'timeStamp': instance.timeStamp,
    };
