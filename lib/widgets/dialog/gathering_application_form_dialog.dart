import 'package:common/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/constants_colors.dart';
import '../../constants/constants_value.dart';

class GatheringApplicationFormDialog extends StatelessWidget {
  final String category;
  final String gatheringId;
  final String applicantId;
  const GatheringApplicationFormDialog({
    Key? key,
    required this.gatheringId,
    required this.applicantId,
    required this.category,
  }) : super(key: key);

  String get getTitle =>
      category == kOneDayGatheringCategory ? '하루모임 참여' : '소모임 가입';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: kWhiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            constraints: const BoxConstraints(
              minHeight: 150,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: double.infinity),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: ()=>Navigator.pop(context),
                      behavior: HitTestBehavior.opaque,
                      child: SvgPicture.asset(
                        'assets/icons/svg/close_20px.svg',
                      ),
                    ),
                    Text(
                      getTitle,
                      style: TextStyle(
                        fontSize: 16,
                        color: kFontGray800Color,
                        fontWeight: FontWeight.bold,
                        height: 24 / 16,
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getProfileArea(applicantId),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getNameArea(applicantId),
                          getInformationArea(applicantId),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget getProfileArea(String userId) => FutureBuilder(
        future: UserService.get(id: userId, field: 'profileImage'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              width: 36,
              height: 36,
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
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(42),
              color: kDarkGray20Color,
            ),
          );
        },
      );

  Widget getNameArea(String userId) => FutureBuilder(
        future: UserService.get(id: userId, field: 'name'),
        builder: (context, snapshot) {
          return Text(
            snapshot.data ?? '',
            style: TextStyle(
              fontSize: 14,
              color: kFontGray800Color,
              height: 20 / 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      );

  Widget getInformationArea(String userId) => FutureBuilder(
        future: UserService.get(id: userId, field: 'information'),
        builder: (context, snapshot) {
          return Text(
            snapshot.data ?? '',
            style: TextStyle(
              fontSize: 13,
              color: kFontGray500Color,
              height: 16 / 13,
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          );
        },
      );
}
