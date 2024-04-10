import 'package:flutter/material.dart';

import '../../../constants/constants_colors.dart';

class GatheringButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final bool enabled;
  const GatheringButton(
      {super.key, required this.title, required this.onTap, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!enabled) return;
        onTap();
      },
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
            color: enabled ? kMainColor : kFontGray100Color,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: enabled ? kWhiteColor : kFontGray200Color,
              fontWeight: FontWeight.bold,
              height: 20 / 16,
            ),
          ),
        ),
      ),
    );
  }
}
