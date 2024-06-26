import 'package:cached_network_image/cached_network_image.dart';
import 'package:common/constants/constants_colors.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/widgets/contents_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../constants/constants_enum.dart';
import '../constants/constants_value.dart';
import '../controllers/user_controller.dart';
import '../screens/gathering_detail/one_day_gathering_detail/one_day_gathering_detail_screen.dart';
import '../services/user_service.dart';
import '../utils/widget_utils.dart';
import 'favorite_button.dart';

class OneDayGatheringCard extends StatelessWidget {
  final OneDayGathering gathering;
  const OneDayGatheringCard({super.key, required this.gathering});

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
              color: kBlurColor,
              offset: const Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 18),
                CachedNetworkImage(
                  imageUrl: gathering.mainImage,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 80,
                    height: 80,
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
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: kDarkGray20Color,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Builder(builder: (context) {
                        CommonCategory category =
                            CommonCategoryExtenstion.getCategory(
                                gathering.category);
                        return Row(
                          children: [
                            Image.asset(
                              category.miniImage,
                              width: 22,
                              height: 22,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                category.title,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: kFontGray600Color,
                                  fontWeight: FontWeight.bold,
                                  height: 17 / 12,
                                ),
                              ),
                            ),
                            FavoriteButton(
                              category: kOneDayGatheringCategory,
                              objectId: gathering.id,
                              userId: context.read<UserController>().user!.id,
                            ),
                            const SizedBox(width: 16),
                          ],
                        );
                      }),
                      Text(
                        gathering.title,
                        style: TextStyle(
                          fontSize: 18,
                          height: 25 / 18,
                          letterSpacing: -0.5,
                          fontWeight: FontWeight.bold,
                          color: kFontGray800Color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      FutureBuilder(
                        future: UserService.get(
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
