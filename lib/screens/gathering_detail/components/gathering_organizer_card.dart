import 'package:flutter/material.dart';

import '../../../constants/constants_colors.dart';
import '../../../services/firebase_user_service.dart';

class GatheringOrganizerCard extends StatelessWidget {
  final String organizerId;
  const GatheringOrganizerCard({Key? key, required this.organizerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          FutureBuilder(
            future: FirebaseUserService.get(
              id: organizerId,
              field: 'profileImage',
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    image: DecorationImage(
                      image: NetworkImage(
                        snapshot.data as String,
                      ),
                    ),
                    color: kWhiteC6C6C6Color,
                  ),
                );
              }
              return Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36),
                  color: kWhiteC6C6C6Color,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          Text(
            '모임장',
            style: TextStyle(
              fontSize: 15,
              color: kGrey363639Color,
            ),
          ),
          const SizedBox(width: 6),
          FutureBuilder(
            future: FirebaseUserService.get(
              id: organizerId,
              field: 'name',
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GestureDetector(
                  onTap: () {
                    print('프로필로 이동하기');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                              color: kGrey48484AColor,
                            ))),
                    child: Text(
                      snapshot.data,
                      style: TextStyle(
                        fontSize: 15,
                        color: kGrey48484AColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
