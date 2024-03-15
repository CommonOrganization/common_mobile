// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gathering_apply_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GatheringApplyStatus _$GatheringApplyStatusFromJson(
        Map<String, dynamic> json) =>
    GatheringApplyStatus(
      status: json['status'] as String,
      gatheringId: json['gatheringId'] as String,
      applierId: json['applierId'] as String,
    );

Map<String, dynamic> _$GatheringApplyStatusToJson(
        GatheringApplyStatus instance) =>
    <String, dynamic>{
      'status': instance.status,
      'gatheringId': instance.gatheringId,
      'applierId': instance.applierId,
    };
