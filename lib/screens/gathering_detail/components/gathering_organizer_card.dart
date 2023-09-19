import 'package:flutter/material.dart';
import '../../../constants/constants_colors.dart';
import '../../../services/user_service.dart';

class GatheringOrganizerCard extends StatelessWidget {
  final String organizerId;
  const GatheringOrganizerCard({Key? key, required this.organizerId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          FutureBuilder(
            future: UserService.get(
              id: organizerId,
              field: 'profileImage',
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    image: DecorationImage(
                      image: NetworkImage(
                        snapshot.data as String,
                      ),
                      fit: BoxFit.cover,
                    ),
                    color: kDarkGray20Color,
                  ),
                );
              }
              return Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36),
                  color: kDarkGray20Color,
                ),
              );
            },
          ),
          const SizedBox(width: 10),
          Text(
            '모임장',
            style: TextStyle(
              fontSize: 15,
              color: kFontGray600Color,
              height: 20 / 15,
            ),
          ),
          const SizedBox(width: 6),
          FutureBuilder(
            future: UserService.get(
              id: organizerId,
              field: 'name',
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GestureDetector(
                  onTap: () {
                   //TODO 프로필로 이동
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: kFontGray800Color,
                        ),
                      ),
                    ),
                    child: Text(
                      snapshot.data,
                      style: TextStyle(
                        fontSize: 15,
                        color: kFontGray800Color,
                        fontWeight: FontWeight.bold,
                        height: 20/15,
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
