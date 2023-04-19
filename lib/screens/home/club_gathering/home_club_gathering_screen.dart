import 'dart:math';

import 'package:common/constants/constants_value.dart';
import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/services/firebase_club_gathering_service.dart';
import 'package:common/widgets/club_gathering_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants_colors.dart';
import '../../../constants/constants_enum.dart';
import '../../../controllers/user_controller.dart';
import '../../../models/user_place/user_place.dart';
import '../components/gathering_category_container.dart';
import 'club_gathering_contents_area.dart';

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
        UserPlace userPlace = UserPlace.fromJson(
            controller.user!.userPlace as Map<String, dynamic>);

        return RefreshIndicator(
          color: kMainColor,
          onRefresh: () async => await Future.delayed(
            const Duration(milliseconds: 500),
            () => setState(() {}),
          ),
          child: ListView(
            children: [
              const GatheringCategoryContainer(
                  category: kClubGatheringCategory),
              ClubGatheringContentsArea(
                future: FirebaseClubGatheringService.getTrendingOnGathering(
                    city: userPlace.city),
                title: '인기 급상승 소모임',
              ),
              Builder(builder: (context) {
                List userInterestCategory = controller.user!.interestCategory;
                int index = Random().nextInt(userInterestCategory.length);
                CommonCategory category =
                    CommonCategoryMap.getCategory(userInterestCategory[index]);

                return ClubGatheringContentsArea(
                  future: FirebaseClubGatheringService.getRecommendGathering(
                      category: category.name, city: userPlace.city),
                  title: '추천하는 ${category.title} 하루모임',
                );
              }),
              ClubGatheringContentsArea(
                future: FirebaseClubGatheringService
                    .getImmediatelyAbleToParticipateGathering(
                        city: userPlace.city),
                title: '바로 참여 가능한 소모임',
              ),
              ClubGatheringContentsArea(
                future: FirebaseClubGatheringService.getNearGathering(
                    city: userPlace.city),
                title: '나와 가까운 소모임',
              ),
              ClubGatheringContentsArea(
                future: FirebaseClubGatheringService.getNewGathering(
                    city: userPlace.city),
                title: '새로 열린 소모임',
              ),
            ],
          ),
        );
      },
    );
  }
}
