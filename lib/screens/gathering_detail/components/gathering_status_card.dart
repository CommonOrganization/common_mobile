import 'package:flutter/material.dart';

import '../../../constants/constants_colors.dart';
import '../../../services/firebase_user_service.dart';

class GatheringStatusCard extends StatelessWidget {
  final List memberList;
  final int capacity;
  const GatheringStatusCard(
      {Key? key, required this.memberList, required this.capacity})
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
            color: kGrey1C1C1EColor.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 10,
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
              color: kGrey363639Color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FutureBuilder(
                future: FirebaseUserService.get(
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
                                  color: kWhiteC6C6C6Color,
                                  image: DecorationImage(
                                    image: NetworkImage(image),
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
                                        color:
                                            kGrey1C1C1EColor.withOpacity(0.1),
                                        offset: const Offset(0, 4),
                                        blurRadius: 10,
                                      )
                                    ]),
                                child: Text(
                                  '+${memberList.length - 1}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: kWhiteColor,
                                    fontWeight: FontWeight.bold,
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
                        color: kWhiteC6C6C6Color,
                        image: DecorationImage(
                          image: NetworkImage(image),
                        ),
                      ),
                    );
                  }
                  return Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(42),
                      color: kWhiteC6C6C6Color,
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
                  ),
                  children: [
                    TextSpan(
                      text: '/ ',
                      style: TextStyle(
                        color: kMainColor,
                      ),
                    ),
                    TextSpan(
                      text: '${capacity}',
                      style: TextStyle(
                        color: kGrey48484AColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: kMainBackgroundColor,
                ),
                child: Text(
                  '모임장과 채팅하기',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kMainColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}