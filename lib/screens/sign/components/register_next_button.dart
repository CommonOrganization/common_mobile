import 'package:common/constants/constants_colors.dart';
import 'package:flutter/material.dart';

class RegisterNextButton extends StatelessWidget {
  final bool value;
  final Function onTap;
  const RegisterNextButton({Key? key, required this.value, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        color: value ? kMainColor : kFontGray100Color,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
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
      ),
    );
  }
}
