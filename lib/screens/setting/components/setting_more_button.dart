import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/constants_colors.dart';

class SettingMoreButton extends StatelessWidget {
  final String title;
  final Function onTap;
  const SettingMoreButton({Key? key, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                height: 20 / 16,
                letterSpacing: -0.5,
                color: kFontGray800Color,
              ),
            ),
            const Spacer(),
            SvgPicture.asset('assets/icons/svg/arrow_more_22px.svg'),
          ],
        ),
      ),
    );
  }

}
