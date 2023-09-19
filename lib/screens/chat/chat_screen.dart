import 'package:common/controllers/user_controller.dart';
import 'package:common/models/personal_chat/personal_chat.dart';
import 'package:common/services/personal_chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../constants/constants_colors.dart';
import 'components/personal_chat_card.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

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
        elevation: 0,
      ),
      body: Consumer<UserController>(builder: (context, controller, child) {
        if (controller.user == null) return noChatPage();
        return FutureBuilder(
          future:
              PersonalChatService().getUserChat(userId: controller.user!.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<PersonalChat> userChatList =
                  snapshot.data as List<PersonalChat>;
              if (userChatList.isNotEmpty) {
                return Column(
                  children: userChatList.map((personalChat) {
                    String otherUserId = personalChat.userIdList
                        .where((userId) => userId != controller.user!.id)
                        .first;
                    return PersonalChatCard(
                      otherUserId: otherUserId,
                      chatId: personalChat.id,
                    );
                  }).toList(),
                );
              }
            }
            return noChatPage();
          },
        );
      }),
    );
  }

  Widget noChatPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: double.infinity, height: 254),
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
}
