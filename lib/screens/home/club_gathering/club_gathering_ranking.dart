import 'package:common/constants/constants_enum.dart';
import 'package:common/screens/home/club_gathering/club_gathering_ranking_card.dart';
import 'package:common/services/firebase_club_gathering_service.dart';
import 'package:common/widgets/custom_paint_badge.dart';
import 'package:flutter/material.dart';
import '../../../constants/constants_colors.dart';
import '../../../models/club_gathering/club_gathering.dart';

class ClubGatheringRanking extends StatelessWidget {
  final String category;
  final String userId;
  const ClubGatheringRanking(
      {Key? key, required this.category, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          FirebaseClubGatheringService.getInterestGathering(category: category),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ClubGathering> gatheringList =
              snapshot.data as List<ClubGathering>;
          if (gatheringList.isEmpty) return Container();
          if (gatheringList.length < 3) return Container();
          int gatheringSize =
              gatheringList.length > 3 ? 3 : gatheringList.length;

          int rank = 1;

          return Container(
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 60),
            padding: const EdgeInsets.symmetric(vertical: 10),
            width: 334,
            height: 336,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 4,
                  child: Container(
                    width: 334,
                    height: 332,
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      border: Border.all(
                        color: kFontGray50Color,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 2),
                          blurRadius: 5,
                          color: kBlackColor.withOpacity(0.08),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: gatheringList
                          .sublist(0, gatheringSize)
                          .map(
                            (gathering) => ClubGatheringRankingCard(
                              gathering: gathering,
                              rank: rank++,
                              gatheringSize: gatheringSize,
                              userId: userId,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 22,
                  child: CustomPaint(
                    size: const Size(36, 43),
                    painter: CustomPaintBadge(),
                    child: Container(
                      width: 36,
                      height: 35,
                      alignment: Alignment.center,
                      child: Builder(builder: (context) {
                        String category = gatheringList.first.category;
                        CommonCategory commonCategory =
                            CommonCategoryMap.getCategory(category);

                        String title =
                            commonCategory.title.replaceAll('ㆍ', '\n');
                        if (title == '반려동물') title = '반려\n동물';
                        return Text(
                          title,
                          style: TextStyle(
                            fontSize: 11,
                            height: 12 / 11,
                            letterSpacing: -0.5,
                            color: kFontGray0Color,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
