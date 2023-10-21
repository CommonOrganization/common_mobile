import 'package:cached_network_image/cached_network_image.dart';
import 'package:common/constants/constants_colors.dart';
import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/screens/gathering_detail/club_gathering_detail/club_gathering_detail_screen.dart';
import 'package:common/utils/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/constants_enum.dart';
import '../constants/constants_value.dart';
import 'favorite_button.dart';

class ClubGatheringRowCard extends StatelessWidget {
  final ClubGathering gathering;
  final String userId;
  const ClubGatheringRowCard({
    Key? key,
    required this.gathering,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
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
        child: Row(
          children: [
            CachedNetworkImage(
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
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(
                    builder: (context) {
                      CommonCategory category =
                          CommonCategoryExtenstion.getCategory(gathering.category);
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
                            color: kFontGray900Color,
                          ),
                        ),
                      ),
                      FavoriteButton(
                        category: kClubGatheringCategory,
                        userId: userId,
                        objectId: gathering.id,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
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
        const SizedBox(width: 3),
        Container(
          constraints: const BoxConstraints(
            maxWidth: 150,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              height: 17 / 13,
              letterSpacing: -0.5,
              color: kFontGray500Color,
            ),overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
