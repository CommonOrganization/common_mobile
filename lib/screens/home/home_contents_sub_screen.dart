import 'package:common/constants/constants_value.dart';
import 'package:common/controllers/user_controller.dart';
import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/models/gathering/gathering.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/screens/gathering_detail/club_gathering_detail/club_gathering_detail_screen.dart';
import 'package:common/utils/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../constants/constants_colors.dart';
import '../../constants/constants_enum.dart';
import '../gathering_detail/one_day_gathering_detail/one_day_gathering_detail_screen.dart';
import '../../widgets/gathering_favorite_button.dart';

class HomeContentsSubScreen extends StatelessWidget {
  final String category;
  final Future future;
  final String title;
  const HomeContentsSubScreen(
      {Key? key,
      required this.category,
      required this.future,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        foregroundColor: kFontGray800Color,
        backgroundColor: kWhiteColor,
        leadingWidth: 48,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/icons/svg/arrow_left_28px.svg'),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: kFontGray800Color,
            height: 28 / 18,
            letterSpacing: -0.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Consumer<UserController>(builder: (context, controller, child) {
        if (controller.user == null) return Container();
        String userId = controller.user!.id;
        return FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              late List<Gathering> gatheringList;
              switch (category) {
                case kOneDayGatheringCategory:
                  gatheringList = snapshot.data as List<OneDayGathering>;
                  break;
                case kClubGatheringCategory:
                  gatheringList = snapshot.data as List<ClubGathering>;
                  break;
              }

              if (gatheringList.isNotEmpty) {
                return ListView(
                  padding: const EdgeInsets.only(bottom: 10),
                  physics: const ClampingScrollPhysics(),
                  children: gatheringList
                      .map((gathering) => (category == kOneDayGatheringCategory
                          ? kOneDayGatheringCard(
                              context,
                              gathering: gathering as OneDayGathering,
                              userId: userId,
                            )
                          : kClubGatheringCard(
                              context,
                              gathering: gathering as ClubGathering,
                              userId: userId,
                            )))
                      .toList(),
                );
              }
            }
            return Container();
          },
        );
      }),
    );
  }

  Widget kClubGatheringCard(
    BuildContext context, {
    required ClubGathering gathering,
    required String userId,
  }) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClubGatheringDetailScreen(gathering: gathering),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 106,
        decoration: BoxDecoration(
          color: kWhiteColor,
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: kDarkGray20Color,
                image: DecorationImage(
                  image: NetworkImage(gathering.mainImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(
                    builder: (context) {
                      CommonCategory category =
                          CommonCategoryMap.getCategory(gathering.category);
                      return Row(
                        children: [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: Image.asset(category.miniImage),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            category.title,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: kFontGray600Color,
                              height: 17 / 12,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          gathering.title,
                          style: TextStyle(
                              fontSize: 16,
                              height: 22 / 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                              color: kFontGray900Color),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GatheringFavoriteButton(
                        category: category,
                        userId: userId,
                        gatheringId: gathering.id,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        customIconTextArea(
                          icon: 'assets/icons/svg/location_18px.svg',
                          title: getCityNamesString(gathering.cityList),
                        ),
                        const SizedBox(width: 12),
                        customIconTextArea(
                          icon: 'assets/icons/svg/people_18px.svg',
                          title: '${gathering.capacity}명',
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget kOneDayGatheringCard(
    BuildContext context, {
    required OneDayGathering gathering,
    required String userId,
  }) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OneDayGatheringDetailScreen(gathering: gathering),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 106,
        decoration: BoxDecoration(
          color: kWhiteColor,
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: kDarkGray20Color,
                image: DecorationImage(
                  image: NetworkImage(gathering.mainImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(
                    builder: (context) {
                      CommonCategory category =
                          CommonCategoryMap.getCategory(gathering.category);
                      return Row(
                        children: [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: Image.asset(category.miniImage),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            category.title,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: kFontGray600Color,
                              height: 17 / 12,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          gathering.title,
                          style: TextStyle(
                              fontSize: 16,
                              height: 22 / 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                              color: kFontGray900Color),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GatheringFavoriteButton(
                        category: category,
                        userId: userId,
                        gatheringId: gathering.id,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        customIconTextArea(
                          icon: 'assets/icons/svg/location_18px.svg',
                          title:
                              '${gathering.place['county']} ${gathering.place['dong']}',
                        ),
                        const SizedBox(width: 12),
                        customIconTextArea(
                          icon: 'assets/icons/svg/people_18px.svg',
                          title: '${gathering.capacity}명',
                        ),
                        const SizedBox(width: 12),
                        Builder(builder: (context) {
                          DateTime openingDate =
                              DateTime.parse(gathering.openingDate);
                          return customIconTextArea(
                            icon: 'assets/icons/svg/calendar_18px.svg',
                            title: '${openingDate.month}월 ${openingDate.day}일',
                          );
                        }),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget customIconTextArea({required String icon, required String title}) {
    return Row(
      children: [
        SvgPicture.asset(icon),
        const SizedBox(width: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            height: 17 / 13,
            letterSpacing: -0.5,
            color: kFontGray500Color,
          ),
        )
      ],
    );
  }
}
