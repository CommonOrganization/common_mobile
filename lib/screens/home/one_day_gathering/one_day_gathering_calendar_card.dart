import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/screens/gathering_detail/one_day_gathering_detail/one_day_gathering_detail_screen.dart';
import 'package:common/widgets/gathering_favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../constants/constants_colors.dart';
import '../../../constants/constants_enum.dart';
import '../../../constants/constants_value.dart';

class OneDayGatheringCalendarCard extends StatelessWidget {
  final OneDayGathering gathering;
  final int count;
  final int gatheringSize;
  final String userId;
  const OneDayGatheringCalendarCard(
      {Key? key,
      required this.gathering,
      required this.count,
        required this.gatheringSize,
      required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OneDayGatheringDetailScreen(gathering: gathering),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: count < gatheringSize ? 12 : 0),
        width: double.infinity,
        height: 106,
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: kFontGray50Color, width: 0.5),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 2),
              blurRadius: 5,
              color: kBlackColor.withOpacity(0.08),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 18,
                      right: 16,
                    ),
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
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Builder(
                          builder: (context) {
                            CommonCategory category =
                                CommonCategoryMap.getCategory(
                                    gathering.category);
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
                        Text(
                          gathering.title,
                          style: TextStyle(
                              fontSize: 16,
                              height: 22 / 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                              color: kFontGray900Color),
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
                                  title:
                                      '${openingDate.month}월 ${openingDate.day}일',
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
            Positioned(
              top: 16,
              right: 16,
              child: GatheringFavoriteButton(
                category: kOneDayGatheringCategory,
                userId: userId,
                gatheringId: gathering.id,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget customIconTextArea({required String icon, required String title}) {
  return Row(
    children: [
      SvgPicture.asset(icon),
      const SizedBox(width: 3),
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
