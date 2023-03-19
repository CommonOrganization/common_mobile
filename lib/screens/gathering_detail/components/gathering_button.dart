import 'package:flutter/material.dart';

import '../../../constants/constants_colors.dart';

class GatheringButton extends StatelessWidget {
  final String title;
  final Function onTap;
  const GatheringButton({Key? key, required this.title, required this.onTap})
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
            color: kMainColor,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: kWhiteColor,
              fontWeight: FontWeight.bold,
              height: 20 / 16,
            ),
          ),
        ),
      ),
    );
  }
}
