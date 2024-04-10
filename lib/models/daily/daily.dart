import 'package:json_annotation/json_annotation.dart';
part 'daily.g.dart';

@JsonSerializable()
class Daily {
  final String id;
  // writerId로 변경하는게 좋을듯
  final String organizerId;
  final String category;
  final String detailCategory;
  final String dailyType;
  final String? connectedClubGatheringId;
  final String mainImage;
  final List imageList;
  final String content;
  final List tagList;
  final String timeStamp;

  Daily({
    required this.id,
    required this.organizerId,
    required this.category,
    required this.detailCategory,
    required this.dailyType,
    required this.connectedClubGatheringId,
    required this.mainImage,
    required this.imageList,
    required this.content,
    required this.tagList,
    required this.timeStamp,
  });

  factory Daily.fromJson(Map<String, dynamic> json) => _$DailyFromJson(json);
  Map<String, dynamic> toJson() => _$DailyToJson(this);
}
