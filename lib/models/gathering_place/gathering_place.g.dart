// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gathering_place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GatheringPlace _$GatheringPlaceFromJson(Map<String, dynamic> json) =>
    GatheringPlace(
      city: json['city'] as String,
      county: json['county'] as String,
      dong: json['dong'] as String,
      detail: json['detail'] as String,
    );

Map<String, dynamic> _$GatheringPlaceToJson(GatheringPlace instance) =>
    <String, dynamic>{
      'city': instance.city,
      'county': instance.county,
      'dong': instance.dong,
      'detail': instance.detail,
    };
