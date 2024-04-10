import 'package:cached_network_image/cached_network_image.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/screens/gathering_detail/one_day_gathering_detail/one_day_gathering_detail_screen.dart';
import 'package:common/widgets/favorite_button.dart';
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
      {super.key,
      required this.gathering,
      required this.count,
      required this.gatheringSize,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
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
              color: kBlurColor,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(
                left: 18,
                right: 16,
              ),
              child: CachedNetworkImage(
                imageUrl: gathering.mainImage,
                imageBuilder: (context, imageProvider) => Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: kDarkGray20Color,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                placeholder: (context, url) => Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: kDarkGray20Color,
                  ),
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
                              color: kFontGray600Color,
                              height: 17 / 12,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const Spacer(),
                          FavoriteButton(
                            category: kOneDayGatheringCategory,
                            userId: userId,
                            objectId: gathering.id,
                          ),
                          const SizedBox(width: 16),
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
                  Row(
                    children: [
                      customIconTextArea(
                        icon: 'assets/icons/svg/location_18px.svg',
                        title:
                            '${gathering.place['city']} ${gathering.place['county']}',
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
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget customIconTextArea({required String icon, required String title}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      SvgPicture.asset(icon),
      const SizedBox(width: 3),
      Container(
        constraints: const BoxConstraints(
          maxWidth: 70,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            height: 17 / 13,
            letterSpacing: -0.5,
            color: kFontGray500Color,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      )
    ],
  );
}
