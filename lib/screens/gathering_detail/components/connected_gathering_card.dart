import 'dart:ui';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/screens/gathering_detail/one_day_gathering_detail/one_day_gathering_detail_screen.dart';
import 'package:common/services/gathering_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../constants/constants_colors.dart';
import '../../../constants/constants_enum.dart';
import '../../../services/user_service.dart';
import '../../../utils/date_utils.dart';
import '../../../widgets/contents_tag.dart';

class ConnectedGatheringCard extends StatelessWidget {
  final OneDayGathering gathering;
  const ConnectedGatheringCard({Key? key, required this.gathering})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                OneDayGatheringDetailScreen(gathering: gathering)),
      ),
      child: Container(
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 16,
        ),
        decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: kFontGray50Color,
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: kBlurColor,
                offset: const Offset(0, 2),
                blurRadius: 5,
              ),
            ]),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kDarkGray20Color,
                      image: DecorationImage(
                        image: NetworkImage(gathering.mainImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Builder(
                          builder: (context) {
                            CommonCategory category =
                                CommonCategoryExtenstion.getCategory(
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
                                    height: 17 / 12,
                                    color: kFontGray600Color,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 2),
                        Text(
                          gathering.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kFontGray800Color,
                            height: 25 / 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            SvgPicture.asset(
                                'assets/icons/svg/location_18px.svg'),
                            Text(
                              '${gathering.place['city']} ${gathering.place['county']}',
                              style: TextStyle(
                                fontSize: 13,
                                color: kFontGray500Color,
                                height: 17 / 13,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(width: 12),
                            SvgPicture.asset(
                                'assets/icons/svg/calendar_18px.svg'),
                            Text(
                              getSimplyDateDetail(gathering.openingDate),
                              style: TextStyle(
                                fontSize: 12,
                                color: kFontGray500Color,
                                height: 16 / 12,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 12),
              width: double.infinity,
              height: 1,
              color: kFontGray50Color,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: gathering.tagList
                            .map((tag) => Container(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ContentsTag(tag: tag),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FutureBuilder(
                    future: GatheringService.getGatheringMemberList(id: gathering.id),
                    builder: (context,snapshot) {
                      List<String> memberList = snapshot.data??[];
                      return Row(children: [
                        memberListArea(memberList),
                        const SizedBox(width: 8),
                        SvgPicture.asset('assets/icons/svg/people_18px.svg'),
                        Text(
                          '${memberList.length}/${gathering.capacity}',
                          style: TextStyle(
                            fontSize: 13,
                            height: 17 / 13,
                            color: kFontGray400Color,
                          ),
                        ),
                      ],);
                    }
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget memberListArea(List memberList) {
    if (memberList.length > 5) {
      int index = 0;
      double sizeWidth = 104;
      return SizedBox(
        width: sizeWidth,
        height: 24,
        child: Stack(
          children: memberList.sublist(0, 5).map((memberId) {
            double rightMargin = (20 * index++).toDouble();
            return Positioned(
              right: rightMargin,
              child: FutureBuilder(
                  future: UserService.get(id: memberId, field: 'profileImage'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      String image = snapshot.data;
                      return Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: kDarkGray20Color,
                            image: DecorationImage(
                              image: NetworkImage(image),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(color: kWhiteColor)),
                        child: rightMargin == 0
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                    child: Container(
                                      color: kBlackColor.withOpacity(0.2),
                                      child: Text(
                                        '...',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: kFontGray0Color,
                                          letterSpacing: -0.5,
                                          height: 15 / 11,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : null,
                      );
                    }
                    return Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: kDarkGray20Color,
                      ),
                    );
                  }),
            );
          }).toList(),
        ),
      );
    }
    int index = 0;
    double sizeWidth = 24 + 20 * (memberList.length - 1);
    return SizedBox(
      width: sizeWidth,
      height: 24,
      child: Stack(
        children: memberList.map((memberId) {
          double rightMargin = (20 * index++).toDouble();
          return Positioned(
            right: rightMargin,
            child: FutureBuilder(
                future: UserService.get(id: memberId, field: 'profileImage'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    String image = snapshot.data;
                    return Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: kDarkGray20Color,
                          image: DecorationImage(
                            image: NetworkImage(image),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(color: kWhiteColor)),
                    );
                  }
                  return Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: kDarkGray20Color,
                    ),
                  );
                }),
          );
        }).toList(),
      ),
    );
  }
}
