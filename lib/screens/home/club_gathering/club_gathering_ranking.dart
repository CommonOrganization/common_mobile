import 'package:common/constants/constants_enum.dart';
import 'package:common/controllers/user_controller.dart';
import 'package:common/models/user_place/user_place.dart';
import 'package:common/services/firebase_club_gathering_service.dart';
import 'package:common/widgets/custom_paint_badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants_colors.dart';
import '../../../models/club_gathering/club_gathering.dart';

class ClubGatheringRanking extends StatelessWidget {
  const ClubGatheringRanking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(builder: (context, controller, child) {
      if (controller.user == null) return Container();
      List interestCategory = controller.user!.interestCategory;
      UserPlace userPlace = UserPlace.fromJson(
          controller.user!.userPlace as Map<String, dynamic>);

      return FutureBuilder(
        future: FirebaseClubGatheringService.getInterestGathering(
            category: interestCategory, city: userPlace.city),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ClubGathering> gatheringList =
                snapshot.data as List<ClubGathering>;
            if (gatheringList.isEmpty) return Container();

            int gatheringSize =
                gatheringList.length > 3 ? 3 : gatheringList.length;

            double height = (gatheringSize * 104) + 20;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '나의 취미 소모임 랭킹',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 20 / 18,
                      color: kFontGray900Color,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  height: height + 4,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: 4,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 40,
                          height: height,
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
                          child: Column(),
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
                            child: Builder(
                              builder: (context) {
                                String category = gatheringList.first.category;
                                CommonCategory commonCategory = CommonCategoryMap.getCategory(category);
                                return Text(
                                  commonCategory.title.replaceAll('ㆍ', '\n'),
                                  style: TextStyle(
                                    fontSize: 11,
                                    height: 12 / 11,
                                    letterSpacing: -0.5,
                                    color: kFontGray0Color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              }
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
              ],
            );
          }
          return Container();
        },
      );
    });
  }
}
