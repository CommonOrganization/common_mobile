import 'package:common/models/user/user.dart';
import 'package:common/services/personal_chat_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants_colors.dart';
import '../../../controllers/user_controller.dart';
import '../../../utils/local_utils.dart';
import '../../chat/chat_detail_screen.dart';
import '../profile_edit_screen.dart';

class ProfileUserInformationContainer extends StatelessWidget {
  final User user;
  final bool isMyProfile;
  const ProfileUserInformationContainer({
    super.key,
    required this.user,
    this.isMyProfile = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              const SizedBox(width: 20),
              SizedBox(
                width: 90,
                height: 84,
                child: Stack(
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(84),
                        color: kDarkGray20Color,
                        image: DecorationImage(
                          image: NetworkImage(user.profileImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (isMyProfile)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileEditScreen(),
                            ),
                          ),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: kWhiteColor,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 2),
                                  blurRadius: 5,
                                  color: kBlurColor,
                                )
                              ],
                            ),
                            child: Icon(
                              Icons.edit,
                              color: kFontGray400Color,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 16,
                  height: 20 / 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Builder(builder: (context) {
                String? userId = context.read<UserController>().user?.id;
                if (userId == user.id) {
                  return Container(height: 42);
                }
                return GestureDetector(
                  onTap: () async {
                    if (context.read<UserController>().user == null) {
                      showMessage(context, message: '잠시 후에 다시 시도해 주세요 :)');
                      return;
                    }
                    String? chatId = await PersonalChatService().startChat(
                      userIdList: [userId, user.id],
                    );
                    if (chatId == null) return;
                    if (context.mounted) {
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
                  child: Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 11),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: kSubColor1,
                    ),
                    child: Text(
                      '채팅하기',
                      style: TextStyle(
                        fontSize: 14,
                        height: 20 / 14,
                        color: kMainColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            user.information,
            style: TextStyle(
              fontSize: 12,
              height: 16 / 12,
              color: kFontGray400Color,
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
