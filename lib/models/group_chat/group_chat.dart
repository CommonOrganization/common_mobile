import 'package:json_annotation/json_annotation.dart';

import '../root_chat/root_chat.dart';
part 'group_chat.g.dart';

@JsonSerializable()
class GroupChat extends RootChat{
  final String title;
  final String timeStamp;

  GroupChat({
    required super.id,
    required this.title,
    required super.userIdList,
    required this.timeStamp,
  });

  factory GroupChat.fromJson(Map<String, dynamic> json) => _$GroupChatFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$GroupChatToJson(this);
}
