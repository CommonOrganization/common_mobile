import 'package:json_annotation/json_annotation.dart';
part 'notice.g.dart';

@JsonSerializable()
class Notice {
  final String id;
  final String title;
  final String type;
  final String timeStamp;
  final String content;

  Notice({
    required this.id,
    required this.title,
    required this.type,
    required this.timeStamp,
    required this.content,
  });

  factory Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);
  Map<String, dynamic> toJson() => _$NoticeToJson(this);
}
