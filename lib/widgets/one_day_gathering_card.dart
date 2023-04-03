import 'package:common/constants/constants_colors.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/services/firebase_user_service.dart';
import 'package:common/widgets/contents_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/constants_enum.dart';
import '../screens/gathering_detail/one_day_gathering_detail/one_day_gathering_detail_screen.dart';
import '../utils/widget_utils.dart';

class OneDayGatheringCard extends StatelessWidget {
  final OneDayGathering gathering;
  const OneDayGatheringCard({Key? key, required this.gathering})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OneDayGatheringDetailScreen(
            gathering: gathering,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        width: 310,
        height: 200,
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: kBlackColor.withOpacity(0.08),
                offset: const Offset(0, 2),
                blurRadius: 5),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 18),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: kFontGray50Color,
                    image: DecorationImage(
                      image: NetworkImage(gathering.mainImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Builder(builder: (context) {
                            CommonCategory category =
                                CommonCategoryMap.getCategory(
                                    gathering.category);
                            return Row(
                              children: [
                                Image.asset(
                                  category.miniImage,
                                  width: 22,
                                  height: 22,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  category.title,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: kFontGray600Color,
                                    fontWeight: FontWeight.bold,
                                    height: 17 / 12,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                      Text(
                        gathering.title,
                        style: TextStyle(
                          fontSize: 18,
                          height: 25 / 18,
                          letterSpacing: -0.5,
                          fontWeight: FontWeight.bold,
                          color: kFontGray800Color,
                        ),
                      ),
                      FutureBuilder(
                        future: FirebaseUserService.get(
                            id: gathering.organizerId, field: 'name'),
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.data ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: kFontGray400Color,
                              height: 18 / 14,
                              letterSpacing: -0.5,
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 7),
              width: double.infinity,
              height: 1,
              color: kFontGray50Color,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const SizedBox(width: 18),
                SvgPicture.asset('assets/icons/svg/location_18px.svg'),
                const SizedBox(width: 2),
                Text(
                  '${gathering.place['city']} ${gathering.place['county']}',
                  style: TextStyle(
                    fontSize: 13,
                    height: 17 / 13,
                    letterSpacing: -0.5,
                    color: kFontGray600Color,
                  ),
                ),
                const SizedBox(width: 12),
                SvgPicture.asset('assets/icons/svg/people_18px.svg'),
                const SizedBox(width: 2),
                Text(
                  '${gathering.capacity}명',
                  style: TextStyle(
                    fontSize: 13,
                    height: 17 / 13,
                    letterSpacing: -0.5,
                    color: kFontGray600Color,
                  ),
                ),
                const SizedBox(width: 12),
                SvgPicture.asset('assets/icons/svg/calendar_18px.svg'),
                const SizedBox(width: 2),
                Builder(builder: (context) {
                  DateTime openingDate = DateTime.parse(gathering.openingDate);
                  return Text(
                    '${openingDate.month}월 ${openingDate.day}일',
                    style: TextStyle(
                      fontSize: 13,
                      height: 17 / 13,
                      letterSpacing: -0.5,
                      color: kFontGray600Color,
                    ),
                  );
                })
              ],
            ),
            const SizedBox(height: 12),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: getGatheringCardTagList(gathering.tagList)
                      .map((tag) => Container(
                            padding: const EdgeInsets.only(right: 8),
                            child: ContentsTag(tag: tag),
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
