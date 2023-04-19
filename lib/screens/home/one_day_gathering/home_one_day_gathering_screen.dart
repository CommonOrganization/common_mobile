import 'dart:math';

import 'package:common/constants/constants_enum.dart';
import 'package:common/constants/constants_value.dart';
import 'package:common/controllers/user_controller.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/models/user_place/user_place.dart';
import 'package:common/services/firebase_one_day_gathering_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants_colors.dart';
import '../../../widgets/one_day_gathering_card.dart';
import '../components/gathering_category_container.dart';
import '../components/interesting_category_container.dart';
import 'one_day_gathering_calendar.dart';
import 'one_day_gathering_contents_area.dart';

class HomeOneDayGatheringScreen extends StatefulWidget {
  const HomeOneDayGatheringScreen({Key? key}) : super(key: key);

  @override
  State<HomeOneDayGatheringScreen> createState() =>
      _HomeOneDayGatheringScreenState();
}

class _HomeOneDayGatheringScreenState extends State<HomeOneDayGatheringScreen> {
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
                  category: kOneDayGatheringCategory),
              const InterestingCategoryContainer(),
              const SizedBox(height: 45),
              OneDayGatheringContentsArea(
                future: FirebaseOneDayGatheringService.getTodayGathering(
                    city: userPlace.city),
                title: '오늘 당장 만날 수 있는 하루모임',
              ),
              Builder(builder: (context) {
                List userInterestCategory = controller.user!.interestCategory;
                int index = Random().nextInt(userInterestCategory.length);
                CommonCategory category =
                    CommonCategoryMap.getCategory(userInterestCategory[index]);

                return OneDayGatheringContentsArea(
                  future: FirebaseOneDayGatheringService.getRecommendGathering(
                      category: category.name, city: userPlace.city),
                  title: '추천하는 ${category.title} 하루모임',
                );
              }),
              const OneDayGatheringCalendar(),
              OneDayGatheringContentsArea(
                future: FirebaseOneDayGatheringService.getNearGathering(
                  city: userPlace.city,
                  county: userPlace.county,
                ),
                title: '나와 가까운 하루모임',
              ),
              OneDayGatheringContentsArea(
                future: FirebaseOneDayGatheringService.getNewGathering(
                    city: userPlace.city),
                title: '새로 열린 하루모임',
              ),
            ],
          ),
        );
      },
    );
  }
}
