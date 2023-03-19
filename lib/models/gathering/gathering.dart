import 'package:json_annotation/json_annotation.dart';
part 'gathering.g.dart';

@JsonSerializable()
class Gathering {
  final String id;
  final String organizerId;
  final String category;
  final String detailCategory;
  final String title;
  final String content;
  final String mainImage;
  final List gatheringImage;
  final String recruitWay;
  final String recruitQuestion;
  final int capacity;
  final List tagList;
  final List memberList;
  final List favoriteList;
  final String timeStamp;

  Gathering({
    required this.id,
    required this.organizerId,
    required this.category,
    required this.detailCategory,
    required this.title,
    required this.content,
    required this.mainImage,
    required this.gatheringImage,
    required this.recruitWay,
    required this.recruitQuestion,
    required this.capacity,
    required this.tagList,
    required this.memberList,
    required this.favoriteList,
    required this.timeStamp,
  });

  factory Gathering.fromJson(Map<String, dynamic> json) =>
      _$GatheringFromJson(json);
  Map<String, dynamic> toJson() => _$GatheringToJson(this);
}
