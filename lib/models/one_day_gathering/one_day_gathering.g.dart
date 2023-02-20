// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'one_day_gathering.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OneDayGathering _$OneDayGatheringFromJson(Map<String, dynamic> json) =>
    OneDayGathering(
      id: json['id'] as String,
      organizerId: json['organizerId'] as String,
      type: json['type'] as String,
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
      openingDate: json['openingDate'] as String,
      place: json['place'] as Map<String, dynamic>,
      isHaveEntryFee: json['isHaveEntryFee'] as bool,
      entryFee: json['entryFee'] as int,
      tagList:
          (json['tagList'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$OneDayGatheringToJson(OneDayGathering instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizerId': instance.organizerId,
      'type': instance.type,
      'category': instance.category,
      'detailCategory': instance.detailCategory,
      'title': instance.title,
      'content': instance.content,
      'mainImage': instance.mainImage,
      'gatheringImage': instance.gatheringImage,
      'recruitWay': instance.recruitWay,
      'recruitQuestion': instance.recruitQuestion,
      'capacity': instance.capacity,
      'openingDate': instance.openingDate,
      'place': instance.place,
      'isHaveEntryFee': instance.isHaveEntryFee,
      'entryFee': instance.entryFee,
      'tagList': instance.tagList,
    };
