import 'package:json_annotation/json_annotation.dart';
part 'comment.g.dart';

@JsonSerializable()
class Comment {
  final String dailyId;
  final String id;
  final String writerId;
  final String timeStamp;
  final String content;

  Comment({
    required this.dailyId,
    required this.id,
    required this.writerId,
    required this.timeStamp,
    required this.content,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
