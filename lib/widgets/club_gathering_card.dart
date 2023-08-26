import 'package:common/constants/constants_colors.dart';
import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/widgets/contents_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../constants/constants_enum.dart';
import '../constants/constants_value.dart';
import '../controllers/user_controller.dart';
import '../screens/gathering_detail/club_gathering_detail/club_gathering_detail_screen.dart';
import '../services/user_service.dart';
import '../utils/widget_utils.dart';
import 'gathering_favorite_button.dart';

class ClubGatheringCard extends StatelessWidget {
  final ClubGathering gathering;
  const ClubGatheringCard({Key? key, required this.gathering})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClubGatheringDetailScreen(gathering: gathering),
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
              blurRadius: 5,
            ),
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
                      Builder(builder: (context) {
                        CommonCategory category =
                            CommonCategoryExtenstion.getCategory(gathering.category);
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
                            GatheringFavoriteButton(
                              category: kClubGatheringCategory,
                              gatheringId: gathering.id,
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
                SvgPicture.asset(gathering.recruitWay == 'firstCome'
                    ? 'assets/icons/svg/clock_20px.svg'
                    : 'assets/icons/svg/inbox_20px.svg'),
                const SizedBox(width: 2),
                Text(
                  gathering.recruitWay == 'firstCome' ? '선착순' : '승인제',
                  style: TextStyle(
                    fontSize: 13,
                    height: 17 / 13,
                    letterSpacing: -0.5,
                    color: kFontGray600Color,
                  ),
                ),
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
