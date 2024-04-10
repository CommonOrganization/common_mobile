import 'package:flutter/material.dart';

import '../../constants/constants_colors.dart';

class BottomSheetCustomButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Color? color;
  final FontWeight? fontWeight;
  const BottomSheetCustomButton(
      {super.key,
      required this.title,
      required this.onPressed,
      this.color,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        color: kDarkGray10Color,
        width: double.infinity,
        height: 50,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: color ?? kFontGray600Color,
            fontWeight: fontWeight ?? FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
