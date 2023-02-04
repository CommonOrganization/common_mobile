import 'package:json_annotation/json_annotation.dart';
part 'user_place.g.dart';

@JsonSerializable()
class UserPlace {
  final String city;
  final String county;
  final String dong;
  UserPlace({
    required this.city,
    required this.county,
    required this.dong,
  });

  factory UserPlace.fromJson(Map<String, dynamic> json) => _$UserPlaceFromJson(json);
  Map<String, dynamic> toJson() => _$UserPlaceToJson(this);
}
