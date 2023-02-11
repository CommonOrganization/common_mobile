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
      child: Padding(
        padding: EdgeInsets.only(
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
            color: value ? kMainColor : kWhiteC6C6C6Color,
          ),
          child: Text(
            '다음',
            style: TextStyle(
              fontSize: 18,
              color: value ? kWhiteColor : kGrey8E8E93Color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
