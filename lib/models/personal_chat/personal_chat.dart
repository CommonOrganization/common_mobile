import 'package:json_annotation/json_annotation.dart';
import '../root_chat/root_chat.dart';
part 'personal_chat.g.dart';

@JsonSerializable()
class PersonalChat extends RootChat {
  final List participantList;
  PersonalChat({
    required super.id,
    required super.userIdList,
    required this.participantList,
  });

  factory PersonalChat.fromJson(Map<String, dynamic> json) =>
      _$PersonalChatFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PersonalChatToJson(this);
}
