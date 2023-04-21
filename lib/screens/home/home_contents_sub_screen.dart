import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/constants_colors.dart';

class HomeContentsSubScreen extends StatelessWidget {
  final String category;
  final Future future;
  final String title;
  const HomeContentsSubScreen(
      {Key? key,
      required this.category,
      required this.future,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        foregroundColor: kFontGray800Color,
        backgroundColor: kWhiteColor,
        leadingWidth: 48,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/icons/svg/arrow_left_28px.svg'),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: kFontGray800Color,
            height: 28 / 18,
            letterSpacing: -0.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
    );
  }
}
