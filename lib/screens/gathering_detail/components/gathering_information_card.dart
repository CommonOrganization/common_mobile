import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/constants_colors.dart';

class GatheringInformationCard extends StatelessWidget {
  final String image;
  final String title;
  const GatheringInformationCard(
      {Key? key, required this.image, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          SvgPicture.asset(
            image,
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: kGrey363639Color,
            ),
          ),
        ],
      ),
    );
  }
}
