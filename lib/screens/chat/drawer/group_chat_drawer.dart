import 'package:common/constants/constants_colors.dart';
import 'package:common/screens/chat/user_invite_screen.dart';
import 'package:common/services/group_chat_service.dart';
import 'package:common/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../models/group_chat/group_chat.dart';
import '../../../models/user/user.dart';
import '../chat_album_screen.dart';
import 'drawer_container.dart';
import 'drawer_member_card.dart';
import 'leave_dialog.dart';

class GroupChatDrawer extends StatelessWidget {
  final GroupChat groupChat;
  final String userId;
  const GroupChatDrawer({
    Key? key,
    required this.groupChat,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                        Text(
                          groupChat.title,
                          style: TextStyle(
                            fontSize: 16,
                            height: 24 / 16,
                            letterSpacing: -0.5,
                            color: kFontGray800Color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${groupChat.userIdList.length}명 참여중',
                          style: TextStyle(
                            fontSize: 13,
                            height: 18 / 13,
                            letterSpacing: -0.5,
                            color: kFontGray600Color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Builder(builder: (context) {
                          DateTime openDate =
                              DateTime.parse(groupChat.timeStamp);
                          return Text(
                            '개설일 ${openDate.year}.${openDate.month.toString().padLeft(2, '0')}.${openDate.day.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 12,
                              height: 16 / 12,
                              letterSpacing: -0.5,
                              color: kFontGray400Color,
                            ),
                          );
                        }),
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
                            chatId: groupChat.id,
                            service: GroupChatService(),
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
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserInviteScreen(
                          chatId: groupChat.id,
                          userIdList: groupChat.userIdList,
                        ),
                      ),
                    ),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 20,
                      ),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(42),
                              border: Border.all(color: kFontGray100Color),
                            ),
                            child: Icon(
                              Icons.add,
                              color: kFontGray200Color,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '대화상대 초대',
                            style: TextStyle(
                              fontSize: 14,
                              height: 20 / 14,
                              color: kFontGray800Color,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: groupChat.userIdList.map((id) {
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
                            const LeaveDialog(isGroupChat: true),
                      );
                      if (isLeave ?? false) {
                        await GroupChatService().leaveChatRoom(
                            userId: userId, chatId: groupChat.id);
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
