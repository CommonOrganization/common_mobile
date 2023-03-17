import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../constants/constants_colors.dart';

class GatheringTabBar implements SliverPersistentHeaderDelegate {
  @override
  final double minExtent;
  @override
  final double maxExtent;
  final Function onTap;
  final int currentIndex;

  GatheringTabBar({
    required this.minExtent,
    required this.maxExtent,
    required this.onTap,
    required this.currentIndex,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: maxExtent,
      decoration: BoxDecoration(
        color: kWhiteColor,
        border: Border.symmetric(
          horizontal: BorderSide(color: kFontGray50Color, width: 1),
        ),
      ),
      child: Row(
        children: [
          kTabBarButton(title: '정보', index: 0),
          kTabBarButton(title: '하루모임', index: 1),
          kTabBarButton(title: '피드', index: 2),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  PersistentHeaderShowOnScreenConfiguration? get showOnScreenConfiguration =>
      null;

  @override
  FloatingHeaderSnapConfiguration? get snapConfiguration =>
      FloatingHeaderSnapConfiguration();

  @override
  OverScrollHeaderStretchConfiguration? get stretchConfiguration =>
      OverScrollHeaderStretchConfiguration();

  @override
  TickerProvider? get vsync => null;

  Widget kTabBarButton({required String title, required int index}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: kWhiteColor,
            border: currentIndex == index
                ? Border(
                    bottom: BorderSide(
                    color: kMainColor,
                    width: 2,
                  ))
                : null,
          ),
          child: Text(
            title,
            style: TextStyle(
              color:
                  currentIndex == index ? kFontGray800Color : kFontGray200Color,
              fontSize: 14,
              height: 20 / 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
