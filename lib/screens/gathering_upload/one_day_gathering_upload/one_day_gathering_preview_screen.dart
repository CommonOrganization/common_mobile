import 'package:common/constants/constants_enum.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/constants_colors.dart';

class OneDayGatheringPreviewScreen extends StatelessWidget {
  final Map gathering;
  const OneDayGatheringPreviewScreen({
    Key? key,
    required this.gathering,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        foregroundColor: kWhiteColor,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.share,
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
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Builder(builder: (context) {
            double sizeWidth = MediaQuery.of(context).size.width;
            return SizedBox(
              width: sizeWidth,
              height: sizeWidth * 4 / 3,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    child: Container(
                      width: sizeWidth,
                      height: sizeWidth,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(gathering['mainImage']),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        width: sizeWidth,
                        height: sizeWidth,
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
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 26, bottom: 18),
                      width: sizeWidth,
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
                                    gathering['category']);
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
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: Container(
                                    width: 1,
                                    height: 10,
                                    color: kGrey8E8E93Color,
                                  ),
                                ),
                                Text(
                                  gathering['detailCategory'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: kGrey636366Color,
                                  ),
                                ),
                              ],
                            );
                          }),
                          Text(
                            gathering['title'],
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: kGrey2C2C2EColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Text(
                                '1분전 대화',
                              ),
                              const Text(
                                'ㆍ24명이 찜한 모임',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
