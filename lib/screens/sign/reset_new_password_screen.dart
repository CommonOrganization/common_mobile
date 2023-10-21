import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/constants_colors.dart';
import '../../constants/constants_reg.dart';
import '../../widgets/common_action_button.dart';
import '../../widgets/common_text_field.dart';

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

  bool get passwordDuplicated =>
      _passwordCertifyController.text.isNotEmpty &&
      _passwordCertifyController.text == _passwordController.text;

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
                physics: const ClampingScrollPhysics(),
                children: [
                  const SizedBox(height: 12),
                  Text(
                    '비밀번호 재설정',
                    style: TextStyle(
                      color: kFontGray900Color,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '변경할 비밀번호를 입력해주세요.',
                    style: TextStyle(
                      fontSize: 14,
                      color: kFontGray500Color,
                      height: 20 / 14,
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
                            height: 20 / 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Stack(
                          children: [
                            CommonTextField(
                              controller: _passwordController,
                              obsecureText: true,
                              hintText: '새 비밀번호 (영문, 숫자 혼합 8자이상)',
                              textChanged: () => setState(() {}),
                            ),
                            if (_passwordController.text.isNotEmpty)
                              Positioned(
                                right: 14,
                                top: 0,
                                bottom: 0,
                                child: SvgPicture.asset(
                                  kPasswordRegExp
                                          .hasMatch(_passwordController.text)
                                      ? 'assets/icons/svg/success_26px.svg'
                                      : 'assets/icons/svg/error_26px.svg',
                                ),
                              ),
                          ],
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
                        child: Stack(
                          children: [
                            CommonTextField(
                              controller: _passwordCertifyController,
                              obsecureText: true,
                              hintText: '새 비밀번호 확인',
                              textChanged: () => setState(() {}),
                            ),
                            if (_passwordCertifyController.text.isNotEmpty)
                              Positioned(
                                right: 14,
                                top: 0,
                                bottom: 0,
                                child: SvgPicture.asset(
                                  passwordDuplicated
                                      ? 'assets/icons/svg/success_26px.svg'
                                      : 'assets/icons/svg/error_26px.svg',
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (!passwordDuplicated &&
                      _passwordCertifyController.text.isNotEmpty)
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
                              height: 14 / 11,
                            ),
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
          CommonActionButton(
            value: canNextPressed,
            title: '확인',
            onTap: () {
              if (!canNextPressed) return;
              widget.nextPressed(_passwordController.text);
            },
          ),
        ],
      ),
    );
  }
}
