import 'package:json_annotation/json_annotation.dart';
part 'recruit_answer.g.dart';

@JsonSerializable()
class RecruitAnswer {
  final String gatheringId;
  final String userId;
  final String question;
  final String answer;
  final String timeStamp;

  RecruitAnswer({
    required this.gatheringId,
    required this.userId,
    required this.question,
    required this.answer,
    required this.timeStamp,
  });

  factory RecruitAnswer.fromJson(Map<String, dynamic> json) =>
      _$RecruitAnswerFromJson(json);
  Map<String, dynamic> toJson() => _$RecruitAnswerToJson(this);
}
