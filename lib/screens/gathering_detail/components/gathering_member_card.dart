import 'package:common/constants/constants_colors.dart';
import 'package:common/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import '../../../services/user_service.dart';

class GatheringMemberCard extends StatelessWidget {
  final String memberId;
  final bool isOrganizer;
  const GatheringMemberCard(
      {Key? key, required this.memberId, required this.isOrganizer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(userId: memberId),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              width: 50,
              height: 42,
              child: Stack(
                children: [
                  getProfileArea(),
                  if (isOrganizer)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 22,
                        height: 22,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: kWhiteColor,
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 2),
                              blurRadius: 5,
                              color: kBlurColor,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/leader_16px.png',
                          width: 16,
                          height: 16,
                        ),
                      ),
                    )
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  getNameArea(),
                  getInformationArea(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getProfileArea() => FutureBuilder(
        future: UserService.get(id: memberId, field: 'profileImage'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(42),
                color: kDarkGray20Color,
                image: DecorationImage(
                  image: NetworkImage(snapshot.data as String),
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
      );

  Widget getNameArea() => FutureBuilder(
        future: UserService.get(id: memberId, field: 'name'),
        builder: (context, snapshot) {
          return Text(
            snapshot.data ?? '',
            style: TextStyle(
              fontSize: 14,
              color: kFontGray800Color,
              height: 18 / 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      );

  Widget getInformationArea() => FutureBuilder(
        future: UserService.get(id: memberId, field: 'information'),
        builder: (context, snapshot) {
          return Text(
            snapshot.data ?? '',
            style: TextStyle(
              fontSize: 12,
              color: kFontGray400Color,
              height: 16 / 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      );
}
