// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      country: json['country'] as String,
      phone: json['phone'] as String,
      name: json['name'] as String,
      password: json['password'] as String,
      gender: json['gender'] as String,
      birthday: json['birthday'] as String,
      userPlace: json['userPlace'] as Map<String, dynamic>,
      interestCategory: json['interestCategory'] as List<dynamic>,
      profileImage: json['profileImage'] as String,
      information: json['information'] as String,
      notificationToken: json['notificationToken'] as String,
      likeOneDayGatheringList: json['likeOneDayGatheringList'] as List<dynamic>,
      likeClubGatheringList: json['likeClubGatheringList'] as List<dynamic>,
      likePostList: json['likePostList'] as List<dynamic>,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'country': instance.country,
      'phone': instance.phone,
      'name': instance.name,
      'password': instance.password,
      'gender': instance.gender,
      'birthday': instance.birthday,
      'userPlace': instance.userPlace,
      'interestCategory': instance.interestCategory,
      'profileImage': instance.profileImage,
      'information': instance.information,
      'notificationToken': instance.notificationToken,
      'likeOneDayGatheringList': instance.likeOneDayGatheringList,
      'likeClubGatheringList': instance.likeClubGatheringList,
      'likePostList': instance.likePostList,
    };
