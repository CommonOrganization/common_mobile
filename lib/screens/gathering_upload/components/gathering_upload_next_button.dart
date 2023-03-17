import 'package:flutter/material.dart';

import '../../../constants/constants_colors.dart';

class GatheringUploadNextButton extends StatelessWidget {
  final bool value;
  final Function onTap;
  const GatheringUploadNextButton(
      {Key? key, required this.value, required this.onTap})
      : super(key: key);

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
            '다음',
            style: TextStyle(
              fontSize: 16,
              color: value ? kWhiteColor : kFontGray200Color,
              fontWeight: FontWeight.bold,
              height: 20/16,
            ),
          ),
        ),
      ),
    );
  }
}
