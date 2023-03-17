import 'dart:async';

import 'package:common/constants/constants_colors.dart';
import 'package:common/constants/constants_enum.dart';
import 'package:common/constants/constants_reg.dart';
import 'package:common/screens/sign/bottom_sheets/country_select_bottom_sheet.dart';
import 'package:common/services/http_service.dart';
import 'package:common/utils/local_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'components/register_next_button.dart';

class ResetPasswordPhoneScreen extends StatefulWidget {
  final Function nextPressed;
  const ResetPasswordPhoneScreen({Key? key, required this.nextPressed})
      : super(key: key);

  @override
  State<ResetPasswordPhoneScreen> createState() =>
      _ResetPasswordPhoneScreenState();
}

class _ResetPasswordPhoneScreenState extends State<ResetPasswordPhoneScreen> {
  int _index = 0;
  int _time = 60;

  final TextEditingController _phoneController = TextEditingController();
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

  Country _country = Country.republicOfKorea;

  late String _certificationNumber;
  Timer? _timer;

  bool get checkCertificationNumber =>
      '${_certifyFirstController.text}${_certifySecondController.text}${_certifyThirdController.text}${_certifyFourthController.text}${_certifyFifthController.text}${_certifySixthController.text}' ==
      _certificationNumber;

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    _certifyFirstController.dispose();
    _certifySecondController.dispose();
    _certifyThirdController.dispose();
    _certifyFourthController.dispose();
    _certifyFifthController.dispose();
    _certifySixthController.dispose();
    super.dispose();
  }

  void sendCertificationNumber() {
    setState(() => _time = 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _time--);
      if (_time == 0) {
        timer.cancel();
      }
    });
    _certificationNumber = getNewCertificationNumber();
    HttpService.sendSMS(
      phoneNumber: _phoneController.text,
      certificationNumber: _certificationNumber,
      country: _country,
    );
  }

  void resendCertificationNumber() {
    if (_time > 50) return;
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
      child: _index > 0 ? certifyArea() : phoneArea(),
    );
  }

  Widget phoneArea() => Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
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
                    '가입한 전화번호를 입력해주세요.',
                    style: TextStyle(
                      fontSize: 14,
                      color: kFontGray500Color,
                      height: 20 / 14,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Country? selectedCountry = await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) =>
                                CountrySelectBottomSheet(country: _country),
                          );
                          if (selectedCountry != null) {
                            setState(() => _country = selectedCountry);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.center,
                          constraints: const BoxConstraints(minWidth: 70),
                          height: 52,
                          decoration: BoxDecoration(
                            color: kFontGray50Color,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '+${_country.code}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: kFontGray800Color,
                                  height: 20 / 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              SvgPicture.asset(
                                'assets/icons/svg/arrow_down_20px.svg',
                                colorFilter: ColorFilter.mode(
                                  kFontGray400Color,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            color: kFontGray50Color,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.number,
                            maxLength: 11,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              isDense: true,
                              counterText: '',
                              hintText: '전화번호를 입력하세요.',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: kFontGray400Color,
                                height: 20 / 14,
                              ),
                            ),
                            onChanged: (text) => setState(() {}),
                            style: TextStyle(
                              fontSize: 14,
                              color: kFontGray800Color,
                              height: 20 / 14,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          RegisterNextButton(
            value: kPhoneRegExp.hasMatch(_phoneController.text),
            onTap: () {
              if (kPhoneRegExp.hasMatch(_phoneController.text)) {
                _index++;
                sendCertificationNumber();
                _firstFocusNode.requestFocus();
              }
            },
          ),
        ],
      );

  Widget certifyArea() => Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
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
                        height: 20/14,
                      ),
                      children: [
                        TextSpan(text: '${_phoneController.text} 로 '),
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
                      kCertifyTextFieldArea(
                          controller: _certifySecondController),
                      const SizedBox(width: 15),
                      kCertifyTextFieldArea(
                          controller: _certifyThirdController),
                      const SizedBox(width: 15),
                      kCertifyTextFieldArea(
                          controller: _certifyFourthController),
                      const SizedBox(width: 15),
                      kCertifyTextFieldArea(
                          controller: _certifyFifthController),
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
                              height: 14/11,
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
          RegisterNextButton(
            value: checkCertificationNumber,
            onTap: () {
              if (!checkCertificationNumber) return;
              if (_time <= 0) {
                showMessage(context, message: '시간이 초과되었습니다.');
                return;
              }
              widget.nextPressed(_phoneController.text);
            },
          ),
        ],
      );

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
              height: 47/36,
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
