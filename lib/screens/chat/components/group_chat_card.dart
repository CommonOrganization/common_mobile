import 'package:common/constants/constants_enum.dart';
import 'package:common/models/chat/chat.dart';
import 'package:common/services/group_chat_service.dart';
import 'package:common/services/user_service.dart';
import 'package:common/utils/date_utils.dart';
import 'package:flutter/material.dart';
import '../../../constants/constants_colors.dart';
import '../../../constants/constants_url.dart';
import '../../../models/group_chat/group_chat.dart';
import '../chat_detail_screen.dart';

class GroupChatCard extends StatelessWidget {
  final String chatId;
  final String userId;
  const GroupChatCard({
    Key? key,
    required this.userId,
    required this.chatId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GroupChatService().getChatRoom(chatId: chatId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            GroupChat? groupChat = snapshot.data;
            if (groupChat == null) return Container();
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(
                    chatId: chatId,
                    chatService: GroupChatService(),
                  ),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: 80,
                child: Row(
                  children: [
                    kLeadingImageArea(userId, groupChat.userIdList),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            groupChat.title,
                            style: TextStyle(
                              fontSize: 16,
                              color: kFontGray800Color,
                              height: 20 / 16,
                              letterSpacing: -0.5,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          FutureBuilder(
                            future:
                                GroupChatService().getLastChat(chatId: chatId),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                Chat? chat = snapshot.data;
                                if (chat != null) {
                                  MessageType messageType =
                                      MessageTypeExtenstion.getType(
                                          chat.messageType);
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
                              return const Text('');
                            },
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder(
                      future: GroupChatService().getLastChat(chatId: chatId),
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
          return Container();
        });
  }

  Widget kLeadingImageArea(String userId, List userIdList) {
    if (userIdList.isEmpty) return Container();
    List otherUserIdList = userIdList.where((id) => id != userId).toList();
    if (otherUserIdList.isEmpty) {
      String assetImage = DateTime.now().second % 2 == 0
          ? kProfileRedImageUrl
          : kProfileYellowImageUrl;
      return Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(42),
          color: kDarkGray20Color,
          image: DecorationImage(
            image: AssetImage(assetImage),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    if (otherUserIdList.length == 1) {
      return kUserContainer(
        userId: otherUserIdList[0],
        size: 54,
      );
    }
    if (otherUserIdList.length == 2) {
      return SizedBox(
        width: 54,
        height: 54,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: kUserContainer(
                userId: otherUserIdList[0],
                size: 36,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: kUserContainer(
                userId: otherUserIdList[1],
                size: 36,
              ),
            ),
          ],
        ),
      );
    }
    if (otherUserIdList.length == 3) {
      return SizedBox(
        width: 54,
        height: 54,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Positioned(
              left: 0,
              bottom: 0,
              child: kUserContainer(
                userId: otherUserIdList[0],
                size: 32,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: kUserContainer(
                userId: otherUserIdList[1],
                size: 32,
              ),
            ),
            Positioned(
              top: 0,
              child: kUserContainer(
                userId: otherUserIdList[2],
                size: 32,
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox(
      width: 54,
      height: 54,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: kUserContainer(
              userId: otherUserIdList[0],
              size: 28,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: kUserContainer(
              userId: otherUserIdList[1],
              size: 28,
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: kUserContainer(
              userId: otherUserIdList[2],
              size: 28,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: kUserContainer(
              userId: otherUserIdList[3],
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget kUserContainer({required String userId, required double size}) {
    return FutureBuilder(
        future: UserService.get(id: userId, field: 'profileImage'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String? userImage = snapshot.data;
            if (userImage != null) {
              return Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kDarkGray20Color,
                  border: Border.all(
                    color: kWhiteColor,
                    width: 2,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(userImage),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }
          }
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: kDarkGray20Color,
            ),
          );
        });
  }
}
