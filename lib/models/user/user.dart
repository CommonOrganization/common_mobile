import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String email;
  final String name;
  final String password;
  final String gender;
  final String birthday;
  final Map userPlace;
  final List interestCategory;
  final String profileImage;
  final String information;
  final String notificationToken;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.gender,
    required this.birthday,
    required this.userPlace,
    required this.interestCategory,
    required this.profileImage,
    required this.information,
    required this.notificationToken,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
