import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/constants_colors.dart';
import '../../constants/constants_reg.dart';

class ResetNewPasswordScreen extends StatefulWidget {
  final Function nextPressed;
  const ResetNewPasswordScreen({
    Key? key,
    required this.nextPressed,
  }) : super(key: key);

  @override
  State<ResetNewPasswordScreen> createState() => _ResetNewPasswordScreenState();
}

class _ResetNewPasswordScreenState extends State<ResetNewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordCertifyController =
      TextEditingController();

  bool get showPasswordMessage =>
      _passwordCertifyController.text.isNotEmpty &&
      _passwordCertifyController.text != _passwordController.text;

  bool get canNextPressed =>
      _passwordController.text.isNotEmpty &&
      kPasswordRegExp.hasMatch(_passwordController.text) &&
      _passwordCertifyController.text.isNotEmpty &&
      _passwordController.text == _passwordCertifyController.text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  const SizedBox(height: 12),
                  Text(
                    '비밀번호 재설정',
                    style: TextStyle(
                      color: kFontGray900Color,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '변경할 비밀번호를 입력해주세요.',
                    style: TextStyle(
                      fontSize: 14,
                      color: kFontGray500Color,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '패스워드',
                          style: TextStyle(
                            fontSize: 14,
                            color: kFontGray800Color,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            color: kFontGray50Color,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    isDense: true,
                                    counterText: '',
                                    hintText: '새 비밀번호 (영문, 숫자 혼합 8자이상)',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: kFontGray400Color,
                                    ),
                                  ),
                                  onChanged: (text) => setState(() {}),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: kFontGray800Color,
                                  ),
                                ),
                              ),
                              if (_passwordController.text.isNotEmpty)
                                SvgPicture.asset(
                                  kPasswordRegExp
                                          .hasMatch(_passwordController.text)
                                      ? 'assets/icons/svg/success_26px.svg'
                                      : 'assets/icons/svg/error_26px.svg',
                                  width: 26,
                                  height: 26,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Spacer(),
                      Expanded(
                        flex: 3,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            color: kFontGray50Color,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _passwordCertifyController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    isDense: true,
                                    counterText: '',
                                    hintText: '새 비밀번호 확인',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: kFontGray400Color,
                                    ),
                                  ),
                                  onChanged: (text) => setState(() {}),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: kFontGray800Color,
                                  ),
                                ),
                              ),
                              if (_passwordCertifyController.text.isNotEmpty)
                                SvgPicture.asset(
                                  !showPasswordMessage
                                      ? 'assets/icons/svg/success_26px.svg'
                                      : 'assets/icons/svg/error_26px.svg',
                                  width: 26,
                                  height: 26,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (showPasswordMessage)
                    Row(
                      children: [
                        const Spacer(),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: Text(
                            '비밀번호가 일치하지 않습니다.',
                            style: TextStyle(
                              fontSize: 11,
                              color: kNoColor,
                            ),
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (canNextPressed) {
                widget.nextPressed(_passwordController.text);
              }
            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              color: canNextPressed ? kMainColor : kFontGray100Color,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    '확인',
                    style: TextStyle(
                      fontSize: 16,
                      color: canNextPressed ? kWhiteColor : kFontGray200Color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}