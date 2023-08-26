// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruit_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecruitAnswer _$RecruitAnswerFromJson(Map<String, dynamic> json) =>
    RecruitAnswer(
      gatheringId: json['gatheringId'] as String,
      userId: json['userId'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      timeStamp: json['timeStamp'] as String,
    );

Map<String, dynamic> _$RecruitAnswerToJson(RecruitAnswer instance) =>
    <String, dynamic>{
      'gatheringId': instance.gatheringId,
      'userId': instance.userId,
      'question': instance.question,
      'answer': instance.answer,
      'timeStamp': instance.timeStamp,
    };
