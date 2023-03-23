// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_gathering.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClubGathering _$ClubGatheringFromJson(Map<String, dynamic> json) =>
    ClubGathering(
      id: json['id'] as String,
      organizerId: json['organizerId'] as String,
      category: json['category'] as String,
      detailCategory: json['detailCategory'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      mainImage: json['mainImage'] as String,
      gatheringImage: json['gatheringImage'] as List<dynamic>,
      recruitWay: json['recruitWay'] as String,
      recruitQuestion: json['recruitQuestion'] as String,
      capacity: json['capacity'] as int,
      tagList: json['tagList'] as List<dynamic>,
      memberList: json['memberList'] as List<dynamic>,
      favoriteList: json['favoriteList'] as List<dynamic>,
      timeStamp: json['timeStamp'] as String,
      applicantList: json['applicantList'] as List<dynamic>,
      cityList: json['cityList'] as List<dynamic>,
    );

Map<String, dynamic> _$ClubGatheringToJson(ClubGathering instance) =>
    <String, dynamic>{
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
      'favoriteList': instance.favoriteList,
      'timeStamp': instance.timeStamp,
      'applicantList': instance.applicantList,
      'cityList': instance.cityList,
    };
