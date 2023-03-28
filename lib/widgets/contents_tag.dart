import 'package:flutter/material.dart';

import '../constants/constants_colors.dart';

class ContentsTag extends StatelessWidget {
  final String tag;
  const ContentsTag({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: kSubColor1,
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: 11,
          color: kSubColor3,
          letterSpacing: -0.5,
          height: 14 / 11,
        ),
      ),
    );
  }
}
