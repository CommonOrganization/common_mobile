import 'package:common/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/constants_colors.dart';
import '../../constants/constants_reg.dart';
import '../../widgets/common_action_button.dart';
import '../../widgets/common_text_field.dart';

class RegisterInformationScreen extends StatefulWidget {
  final Function nextPressed;
  const RegisterInformationScreen({
    Key? key,
    required this.nextPressed,
  }) : super(key: key);

  @override
  State<RegisterInformationScreen> createState() =>
      _RegisterInformationScreenState();
}

class _RegisterInformationScreenState extends State<RegisterInformationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordCertifyController =
      TextEditingController();

  bool _canUseName = true;

  bool get passwordDuplicated =>
      _passwordCertifyController.text.isNotEmpty &&
      _passwordController.text == _passwordCertifyController.text;

  bool get canNextPressed =>
      _nameController.text.isNotEmpty &&
      _canUseName &&
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
                    '가입정보 입력',
                    style: TextStyle(
                      color: kFontGray900Color,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '닉네임은 언제든 변경할 수 있어요.',
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
                          '닉네임',
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
                              controller: _nameController,
                              hintText: '8자 이내 한글 혹은 영문',
                              textChanged: (text) =>
                                  setState(() => _canUseName = true),
                              maxLength: 8,
                            ),
                            if (_nameController.text.isNotEmpty)
                              Positioned(
                                right: 14,
                                top: 0,
                                bottom: 0,
                                child: SvgPicture.asset(
                                  _canUseName
                                      ? 'assets/icons/svg/success_26px.svg'
                                      : 'assets/icons/svg/error_26px.svg',
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!_canUseName)
                    SizedBox(
                      height: 30,
                      child: Row(
                        children: [
                          const Spacer(),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                '이미 존재하는 닉네임입니다.',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: kNoColor,
                                  height: 14 / 11,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const SizedBox(height: 30),
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
                              obscureText: true,
                              hintText: '영문, 숫자 8자 이상',
                              textChanged: (text) => setState(() {}),
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
                              obscureText: true,
                              hintText: '다시 입력',
                              textChanged: (text) => setState(() {}),
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
            title: '다음',
            onTap: () async {
              if (!canNextPressed) return;
              bool isNameDuplicated = await UserService.duplicate(
                  field: 'name', value: _nameController.text);
              if (isNameDuplicated) {
                setState(() => _canUseName = false);
                return;
              }
              widget.nextPressed(
                  _nameController.text, _passwordController.text);
            },
          ),
        ],
      ),
    );
  }
}
