import 'package:common/constants/constants_enum.dart';
import 'package:common/models/chat/chat.dart';
import 'package:common/screens/chat/personal_chat_screen.dart';
import 'package:common/services/personal_chat_service.dart';
import 'package:common/utils/date_utils.dart';
import 'package:flutter/material.dart';
import '../../../constants/constants_colors.dart';
import '../../../services/user_service.dart';

class PersonalChatCard extends StatelessWidget {
  final String otherUserId;
  final String chatId;
  const PersonalChatCard({
    Key? key,
    required this.otherUserId,
    required this.chatId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PersonalChatScreen(chatId: chatId),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 80,
        child: Row(
          children: [
            FutureBuilder(
              future: UserService.get(
                id: otherUserId,
                field: 'profileImage',
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  String image = snapshot.data as String;
                  return Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(42),
                      color: kDarkGray20Color,
                      image: DecorationImage(
                        image: NetworkImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
                return Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(42),
                    color: kDarkGray20Color,
                  ),
                );
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FutureBuilder(
                    future: UserService.get(id: otherUserId, field: 'name'),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          color: kFontGray800Color,
                          height: 20 / 16,
                          letterSpacing: -0.5,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                  const SizedBox(height: 6),
                  FutureBuilder(
                    future: PersonalChatService().getLastChat(chatId: chatId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Chat? chat = snapshot.data;
                        if (chat != null) {
                          MessageType messageType =
                              MessageTypeExtenstion.getType(chat.messageType);
                          String text;
                          if (messageType == MessageType.image) {
                            text = '사진이 전송되었습니다.';
                          } else {
                            text = chat.message;
                          }
                          return Text(
                            text,
                            style: TextStyle(
                              fontSize: 15,
                              color: kFontGray500Color,
                              height: 20 / 15,
                              letterSpacing: -0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        }
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: PersonalChatService().getLastChat(chatId: chatId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Chat? chat = snapshot.data;
                  if (chat != null) {
                    return Text(
                      getTimeDifference(DateTime.parse(chat.timeStamp)),
                      style: TextStyle(
                        fontSize: 13,
                        height: 20 / 13,
                        letterSpacing: -0.5,
                        color: kFontGray400Color,
                      ),
                    );
                  }
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
