import 'dart:math';
import 'package:common/constants/constants_enum.dart';
import 'package:common/constants/constants_value.dart';
import 'package:common/controllers/user_controller.dart';
import 'package:common/models/user_place/user_place.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants_colors.dart';
import '../../../controllers/screen_controller.dart';
import '../../../services/one_day_gathering_service.dart';
import '../components/gathering_category_container.dart';
import '../components/interesting_category_container.dart';
import 'one_day_gathering_calendar.dart';
import 'one_day_gathering_contents_area.dart';

class HomeOneDayGatheringScreen extends StatefulWidget {
  const HomeOneDayGatheringScreen({super.key});

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
                        category: kOneDayGatheringCategory),
                    const InterestingCategoryContainer(
                        gatheringCategory: kOneDayGatheringCategory),
                    const SizedBox(height: 45),
                    OneDayGatheringContentsArea(
                      future: OneDayGatheringService.getTodayGathering(
                          city: userPlace.city, userId: controller.user!.id),
                      title: '오늘 당장 만날 수 있는 하루모임',
                    ),
                    Builder(builder: (context) {
                      List userInterestCategory =
                          controller.user!.interestCategory;
                      int index = Random().nextInt(userInterestCategory.length);
                      CommonCategory category =
                          CommonCategoryExtenstion.getCategory(
                              userInterestCategory[index]);

                      return OneDayGatheringContentsArea(
                        future: OneDayGatheringService.getRecommendGathering(
                            category: category.name,
                            city: userPlace.city,
                            userId: controller.user!.id),
                        title: '추천하는 ${category.title} 하루모임',
                      );
                    }),
                    const OneDayGatheringCalendar(),
                    OneDayGatheringContentsArea(
                      future: OneDayGatheringService.getNearGathering(
                          city: userPlace.city, userId: controller.user!.id),
                      title: '나와 가까운 하루모임',
                    ),
                    OneDayGatheringContentsArea(
                      future: OneDayGatheringService.getNewGathering(
                          city: userPlace.city, userId: controller.user!.id),
                      title: '새로 열린 하루모임',
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
