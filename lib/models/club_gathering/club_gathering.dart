import 'package:common/models/gathering/gathering.dart';
import 'package:json_annotation/json_annotation.dart';
part 'club_gathering.g.dart';

@JsonSerializable()
class ClubGathering extends Gathering {
  final List cityList;
  final List applicantList;

  ClubGathering({
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
    required super.memberList,
    required super.timeStamp,
    required this.cityList,
    required this.applicantList,
  });

  factory ClubGathering.fromJson(Map<String, dynamic> json) =>
      _$ClubGatheringFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ClubGatheringToJson(this);
}
