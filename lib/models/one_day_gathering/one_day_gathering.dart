import 'package:common/models/gathering/gathering.dart';
import 'package:json_annotation/json_annotation.dart';
part 'one_day_gathering.g.dart';

@JsonSerializable()
class OneDayGathering extends Gathering {
  final String type;
  final String openingDate;
  final Map place;
  final bool isHaveEntryFee;
  final int entryFee;
  final String? connectedClubGatheringId;
  final bool showAllThePeople;

  OneDayGathering({
    required super.id,
    required super.organizerId,
    required super.category,
    required super.detailCategory,
    required super.title,
    required super.content,
    required super.mainImage,
    required super.gatheringImage,
    required super.recruitWay,
    required super.recruitQuestion,
    required super.capacity,
    required super.tagList,
    required super.timeStamp,
    required this.type,
    required this.openingDate,
    required this.place,
    required this.isHaveEntryFee,
    required this.entryFee,
    required this.connectedClubGatheringId,
    required this.showAllThePeople,
  });

  factory OneDayGathering.fromJson(Map<String, dynamic> json) =>
      _$OneDayGatheringFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$OneDayGatheringToJson(this);
}
