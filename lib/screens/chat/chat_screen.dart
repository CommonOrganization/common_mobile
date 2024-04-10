import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/controllers/user_controller.dart';
import 'package:common/models/group_chat/group_chat.dart';
import 'package:common/models/personal_chat/personal_chat.dart';
import 'package:common/screens/chat/components/group_chat_card.dart';
import 'package:common/screens/chat_upload/chat_upload_screen.dart';
import 'package:common/services/group_chat_service.dart';
import 'package:common/services/personal_chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../constants/constants_colors.dart';
import 'chat_detail_screen.dart';
import 'components/personal_chat_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _headerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        foregroundColor: kFontGray800Color,
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 20,
        title: Text(
          '채팅',
          style: TextStyle(
            fontSize: 22,
            height: 28 / 22,
            color: kFontGray900Color,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              String? chatId = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatUploadScreen(),
                ),
              );
              if (!context.mounted) return;
              if (chatId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatDetailScreen(
                      chatId: chatId,
                      chatService: PersonalChatService(),
                    ),
                  ),
                );
              }
            },
            child: SvgPicture.asset(
              'assets/icons/svg/chat_add_28px.svg',
            ),
          ),
          const SizedBox(width: 20),
        ],
        elevation: 0,
      ),
      body: Consumer<UserController>(builder: (context, controller, child) {
        if (controller.user == null) return noChatPage();
        return Column(
          children: [
            Row(
              children: [
                kTabBarButton(title: '1:1 채팅', index: 0),
                kTabBarButton(title: '그룹채팅', index: 1),
              ],
            ),
            Expanded(
              child: _headerIndex == 0
                  ? personalChatArea(controller.user!.id)
                  : groupChatArea(controller.user!.id),
            ),
          ],
        );
      }),
    );
  }

  Widget personalChatArea(String userId) {
    return StreamBuilder(
      stream: PersonalChatService().getUserChat(userId: userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState==ConnectionState.active) {
          QuerySnapshot<Map<String, dynamic>>? chatSnapshot = snapshot.data;
          if (chatSnapshot == null) return noChatPage();
          if (chatSnapshot.docs.isNotEmpty) {
            return Column(
              children: chatSnapshot.docs.map((document) {
                if (document.exists) {
                  return PersonalChat.fromJson(document.data());
                }
                return null;
              }).map((personalChat) {
                if (personalChat == null) return Container();
                if (personalChat.userIdList
                    .where((id) => id != userId)
                    .isEmpty) {
                  //상대방이 나간 채팅방일 경우!
                  return Container();
                }
                String otherUserId =
                    personalChat.userIdList.where((id) => id != userId).first;
                return PersonalChatCard(
                  otherUserId: otherUserId,
                  chatId: personalChat.id,
                );
              }).toList(),
            );
          }
          return noChatPage();
        }
        return Container();
      },
    );
  }

  Widget groupChatArea(String userId) {
    return StreamBuilder(
      stream: GroupChatService().getUserChat(userId: userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState==ConnectionState.active) {
          QuerySnapshot<Map<String, dynamic>>? chatSnapshot = snapshot.data;
          if (chatSnapshot == null) return noChatPage();
          if (chatSnapshot.docs.isNotEmpty) {
            return Column(
              children: chatSnapshot.docs.map((document) {
                if (document.exists) {
                  return GroupChat.fromJson(document.data());
                }
                return null;
              }).map((groupChat) {
                if (groupChat == null) return Container();
                return GroupChatCard(
                  chatId: groupChat.id,
                  userId: userId,
                );
              }).toList(),
            );
          }
          return noChatPage();
        }
        return Container();
      },
    );
  }

  Widget noChatPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/icons/svg/chat_32px.svg'),
        const SizedBox(height: 10),
        Text(
          '채팅 내역이 없습니다.',
          style: TextStyle(
            fontSize: 18,
            height: 24 / 18,
            letterSpacing: -0.5,
            color: kFontGray500Color,
          ),
        ),
      ],
    );
  }

  Widget kTabBarButton({required String title, required int index}) {
    return GestureDetector(
      onTap: () => setState(() => _headerIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: kWhiteColor,
          border: _headerIndex == index
              ? Border(bottom: BorderSide(color: kMainColor, width: 2))
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color:
                _headerIndex == index ? kFontGray800Color : kFontGray200Color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
