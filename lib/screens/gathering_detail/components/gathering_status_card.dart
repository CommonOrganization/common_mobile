import 'package:common/controllers/user_controller.dart';
import 'package:common/screens/chat/chat_detail_screen.dart';
import 'package:common/services/gathering_service.dart';
import 'package:common/services/personal_chat_service.dart';
import 'package:common/utils/local_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants_colors.dart';
import '../../../services/user_service.dart';

class GatheringStatusCard extends StatelessWidget {
  final int capacity;
  final String organizerId;
  final String gatheringId;
  const GatheringStatusCard(
      {Key? key,

      required this.capacity,
      required this.organizerId,
        required this.gatheringId,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      padding: const EdgeInsets.only(left: 24, right: 24, top: 18, bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: kWhiteColor,
        boxShadow: [
          BoxShadow(
            color: kBlurColor,
            offset: const Offset(0, 2),
            blurRadius: 5,
          )
        ],
      ),
      child: FutureBuilder(
        future: GatheringService.getGatheringMemberList(id: gatheringId),
        builder: (context,snapshot) {
          List<String> memberList = snapshot.data??[];

          if(memberList.isNotEmpty){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '현재 ${memberList.length}명이 참여중에 있습니다.',
                  style: TextStyle(
                    fontSize: 15,
                    color: kFontGray800Color,
                    fontWeight: FontWeight.bold,
                    height: 20 / 15,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FutureBuilder(
                      future: UserService.get(
                        id: memberList.last,
                        field: 'profileImage',
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          String image = snapshot.data as String;
                          if (memberList.length > 1) {
                            return SizedBox(
                              width: 64,
                              height: 42,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    child: Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(42),
                                        color: kDarkGray20Color,
                                        image: DecorationImage(
                                          image: NetworkImage(image),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(42),
                                          color: kMainColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color: kBlurColor,
                                              offset: const Offset(0, 2),
                                              blurRadius: 5,
                                            )
                                          ]),
                                      child: Text(
                                        '+${memberList.length - 1}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: kWhiteColor,
                                          fontWeight: FontWeight.bold,
                                          height: 20 / 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Container(
                            width: 42,
                            height: 42,
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
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(42),
                            color: kDarkGray20Color,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 6),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 26 / 18,
                        ),
                        children: [
                          TextSpan(
                            text: '/ ',
                            style: TextStyle(
                              color: kFontGray100Color,
                            ),
                          ),
                          TextSpan(
                            text: '$capacity',
                            style: TextStyle(
                              color: kFontGray600Color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Builder(builder: (context) {
                      if (organizerId != context.read<UserController>().user?.id) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () async {
                            if (context.read<UserController>().user == null) {
                              showMessage(context, message: '잠시 후에 다시 시도해 주세요 :)');
                              return;
                            }
                            String? chatId = await PersonalChatService().startChat(
                                userIdList: [
                                  context.read<UserController>().user!.id,
                                  organizerId
                                ]);
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
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: kSubColor1,
                            ),
                            child: Text(
                              '모임장과 채팅하기',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: kMainColor,
                                height: 20 / 14,
                              ),
                            ),
                          ),
                        );
                      }
                      return Container();
                    }),
                  ],
                ),
              ],
            );

          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '현재 0명이 참여중에 있습니다.',
                style: TextStyle(
                  fontSize: 15,
                  color: kFontGray800Color,
                  fontWeight: FontWeight.bold,
                  height: 20 / 15,
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        }
      ),
    );
  }
}
