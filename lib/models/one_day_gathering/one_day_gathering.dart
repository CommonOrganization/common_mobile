import 'package:json_annotation/json_annotation.dart';
part 'one_day_gathering.g.dart';

@JsonSerializable()
class OneDayGathering {
  final String id;
  final String organizerId;
  final String type;
  final String category;
  final String detailCategory;
  final String title;
  final String content;
  final String mainImage;
  final List<String> gatheringImage;
  final String recruitWay;
  final String recruitQuestion;
  final int capacity;
  final String openingDate;
  final Map place;
  final bool isHaveEntryFee;
  final int entryFee;
  final List<String> tagList;
  final String timeStamp;

  OneDayGathering({
    required this.id,
    required this.organizerId,
    required this.type,
    required this.category,
    required this.detailCategory,
    required this.title,
    required this.content,
    required this.mainImage,
    required this.gatheringImage,
    required this.recruitWay,
    required this.recruitQuestion,
    required this.capacity,
    required this.openingDate,
    required this.place,
    required this.isHaveEntryFee,
    required this.entryFee,
    required this.tagList,
    required this.timeStamp,
  });

  factory OneDayGathering.fromJson(Map<String, dynamic> json) =>
      _$OneDayGatheringFromJson(json);
  Map<String, dynamic> toJson() => _$OneDayGatheringToJson(this);
}
