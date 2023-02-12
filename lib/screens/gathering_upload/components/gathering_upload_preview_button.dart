import 'package:flutter/material.dart';

import '../../../constants/constants_colors.dart';

class GatheringUploadPreviewButton extends StatelessWidget {
  final Function onTap;
  const GatheringUploadPreviewButton(
      {Key? key, required this.onTap})
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
            color:kMainColor,
          ),
          child: Text(
            '미리보기',
            style: TextStyle(
              fontSize: 18,
              color: kWhiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
