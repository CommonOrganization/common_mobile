// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      reporterId: json['reporterId'] as String,
      reportedId: json['reportedId'] as String,
      timeStamp: json['timeStamp'] as String,
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'reporterId': instance.reporterId,
      'reportedId': instance.reportedId,
      'timeStamp': instance.timeStamp,
    };
