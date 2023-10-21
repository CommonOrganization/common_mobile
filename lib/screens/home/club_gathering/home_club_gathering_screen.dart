import 'dart:math';
import 'package:common/constants/constants_value.dart';
import 'package:common/controllers/screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants_colors.dart';
import '../../../constants/constants_enum.dart';
import '../../../controllers/user_controller.dart';
import '../../../models/user_place/user_place.dart';
import '../../../services/club_gathering_service.dart';
import '../components/gathering_category_container.dart';
import '../components/interesting_category_container.dart';
import 'club_gathering_contents_area.dart';
import 'club_gathering_ranking.dart';

class HomeClubGatheringScreen extends StatefulWidget {
  const HomeClubGatheringScreen({Key? key}) : super(key: key);

  @override
  State<HomeClubGatheringScreen> createState() =>
      _HomeClubGatheringScreenState();
}

class _HomeClubGatheringScreenState extends State<HomeClubGatheringScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, controller, child) {
        if (controller.user == null) return Container();

        List interestCategory = controller.user!.interestCategory;
        UserPlace userPlace = UserPlace.fromJson(
            controller.user!.userPlace as Map<String, dynamic>);

        return Consumer<ScreenController>(
            builder: (context, screenController, child) {
          return RefreshIndicator(
            color: kMainColor,
            onRefresh: () async => await Future.delayed(
              const Duration(milliseconds: 500),
              () => setState(() {}),
            ),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const GatheringCategoryContainer(
                      category: kClubGatheringCategory),
                  const InterestingCategoryContainer(
                      gatheringCategory: kClubGatheringCategory),
                  const SizedBox(height: 45),
                  ClubGatheringContentsArea(
                    future: ClubGatheringService.getTrendingOnGathering(
                        city: userPlace.city),
                    title: '인기 급상승 소모임',
                  ),
                  Builder(builder: (context) {
                    List userInterestCategory =
                        controller.user!.interestCategory;
                    int index = Random().nextInt(userInterestCategory.length);
                    CommonCategory category =
                        CommonCategoryExtenstion.getCategory(
                            userInterestCategory[index]);

                    return ClubGatheringContentsArea(
                      future: ClubGatheringService.getRecommendGathering(
                          category: category.name, city: userPlace.city),
                      title: '추천하는 ${category.title} 하루모임',
                    );
                  }),
                  kRankingArea(
                    interestCategory: interestCategory,
                    userId: controller.user!.id,
                    city: userPlace.city,
                  ),
                  ClubGatheringContentsArea(
                    future: ClubGatheringService
                        .getImmediatelyAbleToParticipateGathering(
                            city: userPlace.city),
                    title: '바로 가입 가능한 소모임',
                  ),
                  ClubGatheringContentsArea(
                    future: ClubGatheringService.getNearGathering(
                        city: userPlace.city),
                    title: '나와 가까운 소모임',
                  ),
                  ClubGatheringContentsArea(
                    future: ClubGatheringService.getNewGathering(
                        city: userPlace.city),
                    title: '새로 열린 소모임',
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget kRankingArea(
      {required List interestCategory,
      required String userId,
      required String city}) {
    return FutureBuilder(
      future: ClubGatheringService.canShowGatheringRanking(
        interestCategory: interestCategory,
        city: city,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool value = snapshot.data as bool;
          if (value) {
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: interestCategory
                          .map((category) => ClubGatheringRanking(
                                category: category,
                                userId: userId,
                                city: city,
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            );
          }
        }
        return Container();
      },
    );
  }
}
