import 'package:json_annotation/json_annotation.dart';
part 'root_chat.g.dart';

@JsonSerializable()
class RootChat {
  final String id;
  final List userIdList;

  RootChat({
    required this.id,
    required this.userIdList,
  });

  factory RootChat.fromJson(Map<String, dynamic> json) => _$RootChatFromJson(json);
  Map<String, dynamic> toJson() => _$RootChatToJson(this);
}
