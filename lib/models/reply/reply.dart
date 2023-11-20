import 'package:json_annotation/json_annotation.dart';
part 'reply.g.dart';

@JsonSerializable()
class Reply {
  final String dailyId;
  final String commentId;
  final String id;
  final String writerId;
  final String timeStamp;
  final String content;

  Reply({
    required this.dailyId,
    required this.commentId,
    required this.id,
    required this.writerId,
    required this.timeStamp,
    required this.content,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => _$ReplyFromJson(json);
  Map<String, dynamic> toJson() => _$ReplyToJson(this);
}
