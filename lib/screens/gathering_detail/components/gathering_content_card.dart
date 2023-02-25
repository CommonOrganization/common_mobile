import 'package:flutter/material.dart';

import '../../../constants/constants_colors.dart';

class GatheringContentCard extends StatelessWidget {
  final String content;
  const GatheringContentCard({Key? key, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kWhiteF6F6F6Color,
        ),
        child: Text(
          content,
          style: TextStyle(
            fontSize: 14,
            color: kGrey48484AColor,
          ),
        ),
      ),
    );
  }
}
