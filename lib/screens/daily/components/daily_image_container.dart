import 'package:common/models/daily/daily.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants_colors.dart';

class DailyImageContainer extends StatefulWidget {
  final Daily daily;
  const DailyImageContainer({super.key, required this.daily});

  @override
  State<DailyImageContainer> createState() => _DailyImageContainerState();
}

class _DailyImageContainerState extends State<DailyImageContainer> {

  final PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      double size = MediaQuery.of(context).size.width;
      return SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: SizedBox(
                width: size,
                height: size,
                child: PageView(
                  physics: const ClampingScrollPhysics(),
                  controller: pageController,
                  children: [
                    widget.daily.mainImage,
                    ...widget.daily.imageList
                  ]
                      .map(
                        (image) => Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: kDarkGray20Color,
                        image: DecorationImage(
                          image: NetworkImage(image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: size,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                child: Wrap(
                  runSpacing: 8,
                  spacing: 8,
                  children: widget.daily.tagList
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
            ),
          ],
        ),
      );
    });
  }
}
