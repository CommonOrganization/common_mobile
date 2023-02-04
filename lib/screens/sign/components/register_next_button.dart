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
        color: value ? kMainColor : kWhiteC6C6C6Color,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
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
      ),
    );
  }
}
