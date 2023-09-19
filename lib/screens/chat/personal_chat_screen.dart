import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../constants/constants_colors.dart';
import '../../constants/constants_enum.dart';
import '../../controllers/user_controller.dart';
import '../../models/chat/chat.dart';
import '../../models/personal_chat/personal_chat.dart';
import '../../services/personal_chat_service.dart';
import '../../services/user_service.dart';
import 'components/custom_input_container.dart';
import 'components/other_user_chat_bubble.dart';
import 'components/other_user_image_bubble.dart';
import 'components/user_chat_bubble.dart';
import 'components/user_image_bubble.dart';

class PersonalChatScreen extends StatefulWidget {
  final String chatId;
  const PersonalChatScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  State<PersonalChatScreen> createState() => _PersonalChatScreenState();
}

class _PersonalChatScreenState extends State<PersonalChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: FutureBuilder(
          future: PersonalChatService().getChatRoom(chatId: widget.chatId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              PersonalChat personalChat = snapshot.data as PersonalChat;
              return Consumer<UserController>(
                builder: (context, controller, child) {
                  if (controller.user == null) return Container();
                  String userId = controller.user!.id;
                  String otherUserId = personalChat.userIdList
                      .where((element) => element != userId)
                      .first;
                  return Scaffold(
                    backgroundColor: kWhiteColor,
                    appBar: AppBar(
                      backgroundColor: kWhiteColor,
                      foregroundColor: kFontGray800Color,
                      elevation: 0,
                      centerTitle: true,
                      leadingWidth: 48,
                      leading: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          margin: const EdgeInsets.only(left: 20),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                              'assets/icons/svg/arrow_left_28px.svg'),
                        ),
                      ),
                      title: FutureBuilder(
                        future: UserService.get(
                          id: otherUserId,
                          field: 'name',
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            String partnerName = snapshot.data as String;
                            return Text(
                              partnerName,
                              style: TextStyle(
                                fontSize: 18,
                                letterSpacing: -0.5,
                                height: 28 / 18,
                                fontWeight: FontWeight.bold,
                                color: kFontGray800Color,
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                    body: Column(
                      children: [
                        Expanded(
                          child: StreamBuilder(
                            stream: PersonalChatService()
                                .getChat(chatId: widget.chatId),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                QuerySnapshot<Map<String, dynamic>>
                                    chatSnapshot = snapshot.data
                                        as QuerySnapshot<Map<String, dynamic>>;
                                String? lastChatDate;
                                String? lastSenderId;

                                WidgetsBinding.instance
                                    .addPostFrameCallback((timeStamp) {
                                  _scrollController.jumpTo(_scrollController
                                      .position.maxScrollExtent);
                                });

                                return ListView(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.only(bottom: 20),
                                  children: chatSnapshot.docs
                                      .map((queryDocumentSnapshot) {
                                    Chat chat = Chat.fromJson(
                                        queryDocumentSnapshot.data());

                                    String? tempLastSenderId = lastSenderId;
                                    String? tempLastChatDate = lastChatDate;

                                    lastChatDate = chat.timeStamp;
                                    lastSenderId = chat.senderId;
                                    MessageType messageType =
                                        MessageTypeExtenstion.getType(
                                            chat.messageType);

                                    if (chat.senderId == userId &&
                                        messageType == MessageType.text) {
                                      return UserChatBubble(
                                        chat: chat,
                                        lastSenderId: tempLastSenderId,
                                        lastChatDate: tempLastChatDate,
                                      );
                                    }
                                    if (chat.senderId != userId &&
                                        messageType == MessageType.text) {
                                      return OtherUserChatBubble(
                                        chat: chat,
                                        lastSenderId: tempLastSenderId,
                                        lastChatDate: tempLastChatDate,
                                      );
                                    }
                                    if (chat.senderId == userId &&
                                        messageType == MessageType.image) {
                                      return UserImageBubble(
                                        chat: chat,
                                        lastSenderId: tempLastSenderId,
                                        lastChatDate: tempLastChatDate,
                                      );
                                    }
                                    return OtherUserImageBubble(
                                      chat: chat,
                                      lastSenderId: tempLastSenderId,
                                      lastChatDate: tempLastChatDate,
                                    );
                                  }).toList(),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                        CustomInputContainer(
                          chatId: widget.chatId,
                          userId: userId,
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return Scaffold(
              backgroundColor: kWhiteColor,
              appBar: AppBar(
                backgroundColor: kWhiteColor,
                foregroundColor: kFontGray800Color,
                elevation: 0,
              ),
            );
          }),
    );
  }
}
