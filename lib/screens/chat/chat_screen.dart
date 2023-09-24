import 'package:common/controllers/user_controller.dart';
import 'package:common/models/personal_chat/personal_chat.dart';
import 'package:common/screens/chat/personal_chat_screen.dart';
import 'package:common/screens/chat_upload/chat_upload_screen.dart';
import 'package:common/services/personal_chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../constants/constants_colors.dart';
import 'components/personal_chat_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

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
              if (!mounted) return;
              if (chatId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonalChatScreen(
                      chatId: chatId,
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
    return FutureBuilder(
      future: PersonalChatService().getUserChat(userId: userId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<PersonalChat> userChatList = snapshot.data as List<PersonalChat>;
          if (userChatList.isNotEmpty) {
            return Column(
              children: userChatList.map((personalChat) {
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
    return FutureBuilder(
      future: null,
      builder: (context, snapshot) {
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
