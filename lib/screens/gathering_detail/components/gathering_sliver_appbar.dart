import 'package:common/models/gathering/gathering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../constants/constants_colors.dart';
import '../../../constants/constants_enum.dart';
import '../../../utils/date_utils.dart';

class GatheringSliverAppbar extends StatelessWidget {
  final bool showAppbarBlack;
  final double size;
  final Gathering gathering;
  final bool isClubGathering;
  const GatheringSliverAppbar({
    Key? key,
    required this.showAppbarBlack,
    required this.size,
    required this.gathering,
    required this.isClubGathering,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        backgroundColor: showAppbarBlack ? kWhiteColor : Colors.transparent,
        elevation: 0,
        pinned: true,
        expandedHeight: MediaQuery.of(context).size.width,
        leadingWidth: 48,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              showAppbarBlack
                  ? 'assets/icons/svg/arrow_left_28px.svg'
                  : 'assets/icons/svg/arrow_left_white_28px.svg',
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(
              showAppbarBlack
                  ? 'assets/icons/svg/share_28px.svg'
                  : 'assets/icons/svg/share_white_28px.svg',
            ),
          ),
          const SizedBox(width: 18),
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(
              showAppbarBlack
                  ? 'assets/icons/svg/favorite_28px.svg'
                  : 'assets/icons/svg/favorite_white_28px.svg',
            ),
          ),
          const SizedBox(width: 20),
        ],
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          background: SizedBox(
            width: size,
            height: size,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(gathering.mainImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            kBlackColor.withOpacity(0.4),
                            kBlackColor.withOpacity(0.08),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Wrap(
                          runSpacing: 8,
                          spacing: 8,
                          children: gathering.tagList
                              .map(
                                (tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 13, vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13.5),
                                    border: Border.all(
                                      color: kWhiteColor,
                                      width: 1.25,
                                    ),
                                  ),
                                  child: Text(
                                    tag,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: kWhiteColor,
                                      height: 17 / 13,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 24, bottom: 16),
                        width: MediaQuery.of(context).size.width,
                        constraints: const BoxConstraints(
                          minHeight: 100,
                        ),
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Container(
                                      width: 1,
                                      height: 10,
                                      color: kFontGray500Color,
                                    ),
                                  ),
                                  Text(
                                    gathering.detailCategory,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: kFontGray600Color,
                                      height: 17 / 12,
                                    ),
                                  ),
                                ],
                              );
                            }),
                            const SizedBox(height: 4),
                            Text(
                              gathering.title,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: kFontGray900Color,
                                height: 37 / 26,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                //TODO 소모임 단톡방 기능 개발시 여기에서 대화로
                                Builder(
                                  builder: (context) {
                                    if (isClubGathering) {
                                      return FutureBuilder(
                                        future: null,
                                        builder: (context, snapshot) {
                                          return Text(
                                            '${getTimeDifference(DateTime.parse(gathering.timeStamp))} 대화',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: kMainColor,
                                              height: 17 / 13,
                                            ),
                                          );
                                        },
                                      );
                                    }
                                    return Text(
                                      '${getTimeDifference(DateTime.parse(gathering.timeStamp))} 등록',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: kMainColor,
                                        height: 17 / 13,
                                      ),
                                    );
                                  },
                                ),
                                Text(
                                  'ㆍ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: kFontGray400Color,
                                    height: 17/13,
                                  ),
                                ),
                                FutureBuilder(
                                  future: null,
                                  builder: (context, snapshot) {
                                    int count = 5;
                                    return RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: kFontGray400Color,
                                          height: 17/13,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: '$count명',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              height: 18/13,
                                            ),
                                          ),
                                          const TextSpan(text: '이 찜한 모임'),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
