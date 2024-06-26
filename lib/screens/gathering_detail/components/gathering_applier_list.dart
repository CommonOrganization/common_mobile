import 'package:common/screens/gathering_detail/gathering_applicant_screen.dart';
import 'package:common/services/gathering_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../constants/constants_colors.dart';
import '../../../services/user_service.dart';

class GatheringApplierList extends StatelessWidget {
  final String category;
  final String gatheringId;
  final String organizerId;
  const GatheringApplierList({
    super.key,
    required this.category,
    required this.gatheringId,
    required this.organizerId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '승인 대기 멤버',
            style: TextStyle(
              fontSize: 13,
              color: kMainColor,
              height: 17 / 13,
            ),
          ),
          const SizedBox(height: 2),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GatheringApplicantScreen(
                  gatheringId: gatheringId,
                  category: category,
                  organizerId: organizerId,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '모임장의 승인을 기다리고 있어요',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kFontGray800Color,
                      height: 25 / 18,
                    ),
                  ),
                ),
                SvgPicture.asset('assets/icons/svg/arrow_more_22px.svg'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder(
            future: GatheringService.getGatheringApplierList(id: gatheringId),
            builder: (context,snapshot) {
              List<String> applierList = snapshot.data??[];
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: applierList
                    .map((userId) => SizedBox(
                          width: 42,
                          child: Column(
                            children: [
                              getProfileArea(userId),
                              const SizedBox(height: 8),
                              getNameArea(userId),
                            ],
                          ),
                        ))
                    .toList(),
              );
            }
          ),
        ],
      ),
    );
  }

  Widget getProfileArea(String userId) => FutureBuilder(
        future: UserService.get(id: userId, field: 'profileImage'),
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

  Widget getNameArea(String userId) => FutureBuilder(
        future: UserService.get(id: userId, field: 'name'),
        builder: (context, snapshot) {
          return Text(
            snapshot.data ?? '',
            style: TextStyle(
              fontSize: 12,
              color: kFontGray800Color,
              height: 16 / 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      );
}
