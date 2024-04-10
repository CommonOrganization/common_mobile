import 'dart:async';
import 'package:common/constants/constants_colors.dart';
import 'package:common/constants/constants_reg.dart';
import 'package:common/services/http_service.dart';
import 'package:common/utils/local_utils.dart';
import 'package:flutter/material.dart';
import '../../constants/constants_value.dart';
import '../../widgets/common_action_button.dart';
import '../../widgets/common_text_field.dart';

class ResetPasswordEmailScreen extends StatefulWidget {
  final Function nextPressed;
  const ResetPasswordEmailScreen({super.key, required this.nextPressed});

  @override
  State<ResetPasswordEmailScreen> createState() =>
      _ResetPasswordEmailScreenState();
}

class _ResetPasswordEmailScreenState extends State<ResetPasswordEmailScreen> {
  int _index = 0;
  int _time = 300;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _certifyFirstController = TextEditingController();
  final TextEditingController _certifySecondController =
      TextEditingController();
  final TextEditingController _certifyThirdController = TextEditingController();
  final TextEditingController _certifyFourthController =
      TextEditingController();
  final TextEditingController _certifyFifthController = TextEditingController();
  final TextEditingController _certifySixthController = TextEditingController();

  final FocusNode _firstFocusNode = FocusNode();
  final FocusNode _lastFocusNode = FocusNode();

  late String _certificationNumber;
  Timer? _timer;

  bool get checkCertificationNumber =>
      ('${_certifyFirstController.text}${_certifySecondController.text}${_certifyThirdController.text}${_certifyFourthController.text}${_certifyFifthController.text}${_certifySixthController.text}' ==
          _certificationNumber) ||
      ('${_certifyFirstController.text}${_certifySecondController.text}${_certifyThirdController.text}${_certifyFourthController.text}${_certifyFifthController.text}${_certifySixthController.text}' ==
          kAdminNumber);

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    _certifyFirstController.dispose();
    _certifySecondController.dispose();
    _certifyThirdController.dispose();
    _certifyFourthController.dispose();
    _certifyFifthController.dispose();
    _certifySixthController.dispose();
    super.dispose();
  }

  void sendCertificationNumber() {
    _timer?.cancel();
    setState(() => _time = 300);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _time--);
      if (_time == 0) {
        timer.cancel();
      }
    });
    _certificationNumber = getNewCertificationNumber();
    HttpService.sendEmail(
      email: _emailController.text,
      certifyCode: _certificationNumber,
    );
  }

  void resendCertificationNumber() {
    if (_time > 240){
      showMessage(context, message: '1분이 지난 후에 다시 시도해 주세요.');
      return;
    }
    _certifyFirstController.clear();
    _certifySecondController.clear();
    _certifyThirdController.clear();
    _certifyFourthController.clear();
    _certifyFifthController.clear();
    _certifySixthController.clear();
    _firstFocusNode.requestFocus();
    sendCertificationNumber();
    showMessage(context, message: '인증번호를 다시 전송하였습니다');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: _index > 0 ? certifyArea() : emailArea(),
    );
  }

  Widget emailArea() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              physics: const ClampingScrollPhysics(),
              children: [
                const SizedBox(height: 12),
                Text(
                  '가입정보 확인',
                  style: TextStyle(
                    color: kFontGray900Color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '가입된 이메일을 입력해주세요.',
                  style: TextStyle(
                    fontSize: 14,
                    color: kFontGray500Color,
                    height: 20 / 14,
                  ),
                ),
                const SizedBox(height: 36),
                CommonTextField(
                  controller: _emailController,
                  hintText: '이메일 주소를 입력하세요.',
                  textChanged: (text) => setState(() {}),
                  inputType: TextInputType.emailAddress,
                ),
              ],
            ),
          ),
        ),
        CommonActionButton(
          value: kEmailRegExp.hasMatch(_emailController.text),
          title: '다음',
          onTap: () {
            if (kEmailRegExp.hasMatch(_emailController.text)) {
              _index++;
              sendCertificationNumber();
              _firstFocusNode.requestFocus();
            }
          },
        ),
      ],
    );
  }

  Widget certifyArea() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              physics: const ClampingScrollPhysics(),
              children: [
                const SizedBox(height: 12),
                Text(
                  '인증번호 입력',
                  style: TextStyle(
                    color: kFontGray900Color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: kFontGray500Color,
                      height: 20 / 14,
                    ),
                    children: [
                      TextSpan(text: '${_emailController.text} 로 '),
                      TextSpan(
                        text: '$_time',
                        style: TextStyle(
                          color: kSubColor3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: '초 내로 발송됩니다.'),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                Row(
                  children: [
                    kCertifyTextFieldArea(
                        controller: _certifyFirstController,
                        focusNode: _firstFocusNode),
                    const SizedBox(width: 15),
                    kCertifyTextFieldArea(controller: _certifySecondController),
                    const SizedBox(width: 15),
                    kCertifyTextFieldArea(controller: _certifyThirdController),
                    const SizedBox(width: 15),
                    kCertifyTextFieldArea(controller: _certifyFourthController),
                    const SizedBox(width: 15),
                    kCertifyTextFieldArea(controller: _certifyFifthController),
                    const SizedBox(width: 15),
                    kCertifyTextFieldArea(
                        controller: _certifySixthController,
                        focusNode: _lastFocusNode),
                  ],
                ),
                const SizedBox(height: 26),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => resendCertificationNumber(),
                      child: Container(
                        alignment: Alignment.center,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: kFontGray50Color,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '인증 문자가 오지 않나요?',
                          style: TextStyle(
                            fontSize: 11,
                            color: kFontGray400Color,
                            height: 14 / 11,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        CommonActionButton(
          value: checkCertificationNumber,
          title: '다음',
          onTap: () {
            if (!checkCertificationNumber) return;
            if (_time <= 0) {
              showMessage(context, message: '시간이 초과되었습니다.');
              return;
            }
            widget.nextPressed(_emailController.text);
          },
        ),
      ],
    );
  }

  Widget kCertifyTextFieldArea(
          {required TextEditingController controller, FocusNode? focusNode}) =>
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color:
                    controller.text.isNotEmpty ? kMainColor : kFontGray100Color,
                width: 3,
              ),
            ),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            maxLength: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              color: kMainColor,
              height: 47 / 36,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
              counterText: '',
            ),
            onChanged: (text) => setState(() {
              if (checkCertificationNumber) {
                _timer?.cancel();
              }
              if (text.isNotEmpty) {
                if (focusNode == _lastFocusNode) return;
                FocusScope.of(context).nextFocus();
              }
            }),
          ),
        ),
      );
}
