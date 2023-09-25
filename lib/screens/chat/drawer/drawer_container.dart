import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/constants_colors.dart';

class DrawerContainer extends StatelessWidget {
  final String icon;
  final Function onPressed;
  final String title;
  const DrawerContainer({Key? key, required this.icon, required this.onPressed, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          SvgPicture.asset(icon),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                height: 20 / 14,
                letterSpacing: -0.5,
                color: kFontGray600Color,
              ),
            ),
          ),
          SvgPicture.asset(
            'assets/icons/svg/arrow_more_14px.svg',
          ),
        ],
      ),
    );
  }
}
