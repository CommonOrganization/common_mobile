import 'package:json_annotation/json_annotation.dart';
part 'group_chat.g.dart';

@JsonSerializable()
class GroupChat {
  final String id;
  final String title;
  final String authorId;
  final String userIdList;
  final String timeStamp;

  GroupChat({
    required this.id,
    required this.title,
    required this.authorId,
    required this.userIdList,
    required this.timeStamp,
  });

  factory GroupChat.fromJson(Map<String, dynamic> json) => _$GroupChatFromJson(json);
  Map<String, dynamic> toJson() => _$GroupChatToJson(this);
}
