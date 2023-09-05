import 'package:json_annotation/json_annotation.dart';
part 'like_object.g.dart';

@JsonSerializable()
class LikeObject {
  final String userId;
  final String objectId;
  final String likeType;
  final String timeStamp;

  LikeObject({
    required this.userId,
    required this.objectId,
    required this.likeType,
    required this.timeStamp,
  });

  factory LikeObject.fromJson(Map<String, dynamic> json) =>
      _$LikeObjectFromJson(json);
  Map<String, dynamic> toJson() => _$LikeObjectToJson(this);
}
