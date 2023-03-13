import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String country;
  final String phone;
  final String name;
  final String password;
  final String gender;
  final String birthday;
  final Map userPlace;
  final List interestCategory;
  final String profileImage;
  final String information;
  final String notificationToken;
  final List likeOneDayGatheringList;
  final List likeClubGatheringList;
  final List likePostList;

  User({
    required this.id,
    required this.country,
    required this.phone,
    required this.name,
    required this.password,
    required this.gender,
    required this.birthday,
    required this.userPlace,
    required this.interestCategory,
    required this.profileImage,
    required this.information,
    required this.notificationToken,
    required this.likeOneDayGatheringList,
    required this.likeClubGatheringList,
    required this.likePostList,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}