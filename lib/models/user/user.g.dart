// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      password: json['password'] as String,
      gender: json['gender'] as String,
      birthday: json['birthday'] as String,
      userPlace: json['userPlace'] as Map<String, dynamic>,
      interestCategory: json['interestCategory'] as List<dynamic>,
      profileImage: json['profileImage'] as String,
      information: json['information'] as String,
      notificationToken: json['notificationToken'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'password': instance.password,
      'gender': instance.gender,
      'birthday': instance.birthday,
      'userPlace': instance.userPlace,
      'interestCategory': instance.interestCategory,
      'profileImage': instance.profileImage,
      'information': instance.information,
      'notificationToken': instance.notificationToken,
    };
