import 'package:common/models/user_place/user_place.dart';
import 'package:json_annotation/json_annotation.dart';
part 'gathering_place.g.dart';

@JsonSerializable()
class GatheringPlace extends UserPlace {
  final String detail;
  GatheringPlace({
    required super.city,
    required super.county,
    required super.dong,
    required this.detail,
  });

  factory GatheringPlace.fromJson(Map<String, dynamic> json) =>
      _$GatheringPlaceFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$GatheringPlaceToJson(this);
}
