import 'package:flutter/material.dart';

import '../constants/constants_colors.dart';

class CommonActionButton extends StatelessWidget {
  final bool value;
  final Function onTap;
  final String title;
  const CommonActionButton(
      {super.key, required this.value, required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).padding.bottom + 20,
        ),
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27),
            color: value ? kMainColor : kFontGray100Color,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: value ? kWhiteColor : kFontGray200Color,
              fontWeight: FontWeight.bold,
              height: 20 / 16,
            ),
          ),
        ),
      ),
    );
  }
}
