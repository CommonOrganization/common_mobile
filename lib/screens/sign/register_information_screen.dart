import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/constants_colors.dart';
import '../../constants/constants_reg.dart';
import 'components/register_next_button.dart';

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

  bool get showPasswordMessage =>
      _passwordCertifyController.text.isNotEmpty &&
      _passwordCertifyController.text != _passwordController.text;

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
                      height: 20/14,
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
                            height: 20/14,
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
                                  controller: _nameController,
                                  maxLength: 8,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    isDense: true,
                                    counterText: '',
                                    hintText: '8자 이내 한글 혹은 영문',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: kFontGray400Color,height: 20/14,
                                    ),
                                  ),
                                  onChanged: (text) =>
                                      setState(() => _canUseName = true),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: kFontGray800Color,height: 20/14,
                                  ),
                                ),
                              ),
                              if (_nameController.text.isNotEmpty)
                                SvgPicture.asset(
                                  _canUseName
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
                  SizedBox(
                    height: 30,
                    child: _canUseName
                        ? null
                        : Row(
                            children: [
                              const Spacer(),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  '이미 존재하는 닉네임입니다.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: kNoColor,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '패스워드',
                          style: TextStyle(
                            fontSize: 14,
                            color: kFontGray800Color,
                            height: 20/14,
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
                                    hintText: '영문, 숫자 8자 이상',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: kFontGray400Color,  height: 20/14,
                                    ),
                                  ),
                                  onChanged: (text) => setState(() {}),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: kFontGray800Color,  height: 20/14,
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
                                    hintText: '다시 입력',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: kFontGray400Color,  height: 20/14,
                                    ),
                                  ),
                                  onChanged: (text) => setState(() {}),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: kFontGray800Color,  height: 20/14,
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
                              height: 1,
                            ),
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
          RegisterNextButton(
            value: canNextPressed,
            onTap: () {
              if (canNextPressed) {
                //TODO 닉네임 체크하기
                widget.nextPressed(
                    _nameController.text, _passwordController.text);
              }
            },
          ),
        ],
      ),
    );
  }
}
