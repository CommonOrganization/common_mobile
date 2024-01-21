import 'package:common/constants/constants_colors.dart';
import 'package:common/models/personal_chat/personal_chat.dart';
import 'package:common/screens/chat/chat_album_screen.dart';
import 'package:common/services/personal_chat_service.dart';
import 'package:common/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../models/user/user.dart';
import 'drawer_container.dart';
import 'drawer_member_card.dart';
import 'leave_dialog.dart';

class PersonalChatDrawer extends StatelessWidget {
  final PersonalChat personalChat;
  final String userId;
  const PersonalChatDrawer({
    Key? key,
    required this.personalChat,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      surfaceTintColor: kWhiteColor,
      backgroundColor: kWhiteColor,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const ClampingScrollPhysics(),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                      bottom: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder(
                            future: UserService.get(
                              id: personalChat.userIdList
                                  .where((id) => id != userId)
                                  .first,
                              field: 'name',
                            ),
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.data ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 24 / 16,
                                  letterSpacing: -0.5,
                                  color: kFontGray800Color,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }),
                        const SizedBox(height: 2),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: kFontGray50Color,
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: DrawerContainer(
                      icon: 'assets/icons/svg/image_18px.svg',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatAlbumScreen(
                            chatId: personalChat.id,
                            service: PersonalChatService(),
                          ),
                        ),
                      ),
                      title: '앨범',
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: kFontGray50Color,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '함께하는 멤버',
                      style: TextStyle(
                        fontSize: 14,
                        height: 20 / 14,
                        letterSpacing: -0.5,
                        color: kFontGray600Color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: personalChat.userIdList.map((id) {
                      return FutureBuilder(
                          future: UserService.getUser(id: id),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              User? user = snapshot.data;
                              if (user == null) return Container();
                              return DrawerMemberCard(
                                  user: user, isMe: user.id == userId);
                            }
                            return Container();
                          });
                    }).toList(),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      bool? isLeave = await showDialog(
                        context: context,
                        builder: (context) =>
                            const LeaveDialog(isGroupChat: false),
                      );
                      if (isLeave ?? false) {
                        await PersonalChatService().leaveChatRoom(
                            userId: userId, chatId: personalChat.id);
                        if (context.mounted) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: SvgPicture.asset(
                      'assets/icons/svg/chat_leave_24px.svg',
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
