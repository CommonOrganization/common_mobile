import 'dart:developer';
import 'package:common/controllers/user_controller.dart';
import 'package:common/services/personal_chat_service.dart';
import 'package:common/utils/local_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants_colors.dart';
import '../../../services/user_service.dart';

class GatheringStatusCard extends StatelessWidget {
  final List memberList;
  final int capacity;
  final String organizerId;
  const GatheringStatusCard(
      {Key? key,
      required this.memberList,
      required this.capacity,
      required this.organizerId})
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
            color: kBlackColor.withOpacity(0.08),
            offset: const Offset(0, 2),
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
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
                                        color: kBlackColor.withOpacity(0.08),
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
                    onTap: () {
                      if (context.read<UserController>().user == null) {
                        showMessage(context, message: '잠시 후에 다시 시도해 주세요 :)');
                        return;
                      }
                      PersonalChatService().startChat(userIdList: [
                        context.read<UserController>().user!.id,
                        organizerId
                      ]).then((value) {
                        log('$value 채팅방');
                      });
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
      ),
    );
  }
}
