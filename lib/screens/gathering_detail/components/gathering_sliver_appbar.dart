import 'package:common/models/gathering/gathering.dart';
import 'package:flutter/material.dart';
import '../../../constants/constants_colors.dart';
import '../../../constants/constants_enum.dart';
import '../../../utils/date_utils.dart';

class GatheringSliverAppbar extends StatelessWidget {
  final bool showAppbarBlack;
  final double size;
  final Gathering gathering;
  const GatheringSliverAppbar(
      {Key? key,
      required this.showAppbarBlack,
      required this.size,
      required this.gathering})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        foregroundColor: showAppbarBlack ? kBlackColor : kWhiteColor,
        backgroundColor: showAppbarBlack ? kWhiteColor : Colors.transparent,
        elevation: 0.5,
        shadowColor: kWhiteF4F4F4Color,
        pinned: true,
        expandedHeight: MediaQuery.of(context).size.width,
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.share_outlined,
              size: 28,
            ),
          ),
          const SizedBox(width: 18),
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.favorite_outline,
              size: 28,
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
                                      borderRadius: BorderRadius.circular(13),
                                      border: Border.all(
                                          color: kWhiteColor, width: 1.25)),
                                  child: Text(
                                    tag,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: kWhiteColor,
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
                            left: 20, right: 20, top: 26, bottom: 18),
                        width: MediaQuery.of(context).size.width,
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.width / 3,
                        ),
                        decoration: BoxDecoration(
                            color: kWhiteColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Builder(builder: (context) {
                              CommonCategory category =
                                  CommonCategoryMap.getCategory(
                                      gathering.category);
                              return Row(
                                children: [
                                  Container(
                                    width: 22,
                                    height: 22,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      color: category.backgroundColor,
                                    ),
                                    child: Image.asset(
                                      category.image,
                                      width: 22,
                                      height: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    category.title,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: kGrey636366Color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Container(
                                      width: 1,
                                      height: 10,
                                      color: kGrey8E8E93Color,
                                    ),
                                  ),
                                  Text(
                                    gathering.detailCategory,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: kGrey636366Color,
                                    ),
                                  ),
                                ],
                              );
                            }),
                            Text(
                              gathering.title,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: kGrey2C2C2EColor,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                  '${getTimeDifference(DateTime.parse(gathering.timeStamp))} 등록ㆍ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: kGrey8E8E93Color,
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
                                          color: kGrey8E8E93Color,
                                        ),
                                        children: [
                                          TextSpan(
                                              text: '$count명',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              )),
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
