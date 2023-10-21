import 'package:flutter/material.dart';

import '../constants/constants_colors.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function textChanged;
  final int? maxLength;
  final TextInputType? inputType;
  final bool obsecureText;
  const CommonTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.textChanged,
      this.maxLength,
      this.inputType,
      this.obsecureText = false,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: kFontGray50Color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        maxLength: maxLength,
        obscureText: obsecureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          isDense: true,
          counterText: '',
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            color: kFontGray400Color,
            height: 20 / 14,
          ),
        ),
        onChanged: (text) => textChanged(),
        style: TextStyle(
          fontSize: 14,
          color: kFontGray800Color,
          height: 20 / 14,
        ),
      ),
    );
  }
}
