import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/models/group_chat/group_chat.dart';
import 'package:common/models/personal_chat/personal_chat.dart';
import 'package:common/models/root_chat/root_chat.dart';
import 'package:common/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../constants/constants_colors.dart';
import '../../constants/constants_enum.dart';
import '../../controllers/user_controller.dart';
import '../../models/chat/chat.dart';
import '../../services/user_service.dart';
import 'components/custom_input_container.dart';
import 'drawer/group_chat_drawer.dart';
import 'components/other_user_chat_bubble.dart';
import 'components/other_user_image_bubble.dart';
import 'components/user_chat_bubble.dart';
import 'components/user_image_bubble.dart';
import 'drawer/personal_chat_drawer.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  final ChatService chatService;
  const ChatDetailScreen({
    super.key,
    required this.chatId,
    required this.chatService,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: FutureBuilder(
          future: widget.chatService.getChatRoom(chatId: widget.chatId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == null) return Container();
              RootChat rootChat = snapshot.data;
              return Consumer<UserController>(
                builder: (context, controller, child) {
                  if (controller.user == null) return Container();
                  String userId = controller.user!.id;
                  late String otherUserId;
                  if (rootChat.runtimeType == PersonalChat) {
                    otherUserId = rootChat.userIdList
                        .where((element) => element != userId)
                        .first;
                  }
                  return Scaffold(
                    backgroundColor: kWhiteColor,
                    appBar: AppBar(
                      backgroundColor: kWhiteColor,
                      foregroundColor: kFontGray800Color,
                      surfaceTintColor: kWhiteColor,
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
                      title: rootChat.runtimeType == GroupChat
                          ? Text(
                              (rootChat as GroupChat).title,
                              style: TextStyle(
                                fontSize: 18,
                                letterSpacing: -0.5,
                                height: 28 / 18,
                                fontWeight: FontWeight.bold,
                                color: kFontGray800Color,
                              ),
                            )
                          : FutureBuilder(
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
                    endDrawer: rootChat.runtimeType == GroupChat
                        ? GroupChatDrawer(
                            groupChat: rootChat as GroupChat,
                            userId: userId,
                          )
                        : PersonalChatDrawer(
                            personalChat: rootChat as PersonalChat,
                            userId: userId,
                          ),
                    body: Column(
                      children: [
                        Expanded(
                          child: StreamBuilder(
                            stream: widget.chatService
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
