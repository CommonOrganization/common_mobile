import 'package:common/constants/constants_enum.dart';
import 'package:common/models/user_place/user_place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/constants_colors.dart';
import '../../utils/date_utils.dart';
import '../../widgets/birthday_date_picker.dart';
import '../../widgets/bottom_sheets/select_location_bottom_sheet.dart';
import '../../widgets/common_action_button.dart';

class RegisterUserInformationScreen extends StatefulWidget {
  final Function nextPressed;
  const RegisterUserInformationScreen({Key? key, required this.nextPressed})
      : super(key: key);

  @override
  State<RegisterUserInformationScreen> createState() =>
      _RegisterUserInformationScreenState();
}

class _RegisterUserInformationScreenState
    extends State<RegisterUserInformationScreen> {
  int _index = 0;

  Gender _gender = Gender.male;
  DateTime? _birthday;

  bool get canNextPressed =>
      _index == 0 ? _birthday != null : _userPlace != null;

  UserPlace? _userPlace;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: _index == 0 ? genderArea() : locationArea(),
    );
  }

  Widget genderArea() {
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
                  '회원정보 입력',
                  style: TextStyle(
                    color: kFontGray900Color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '응답하신 정보는 모두에게 공개됩니다.',
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
                        '성별',
                        style: TextStyle(
                          fontSize: 14,
                          color: kFontGray800Color,
                          height: 20 / 14,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: Gender.values
                            .map((gender) => genderButton(gender))
                            .toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '생년월일',
                        style: TextStyle(
                          fontSize: 14,
                          color: kFontGray800Color,
                          height: 20 / 14,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () async {
                          DateTime? selectedDate = await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const BirthdayDatePicker(),
                          );
                          if (selectedDate == null) return;
                          setState(() => _birthday = selectedDate);
                        },
                        child: Container(
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
                                child: Text(
                                  _birthday != null
                                      ? getDateFromDateTime(_birthday!)
                                      : '생년월일을 선택해 주세요.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _birthday != null
                                        ? kFontGray800Color
                                        : kFontGray400Color,
                                    height: 20 / 14,
                                  ),
                                ),
                              ),
                              SvgPicture.asset(
                                  'assets/icons/svg/arrow_down_20px.svg'),
                            ],
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
          value: canNextPressed,
          title: '다음',
          onTap: () {
            if (!canNextPressed) return;
            setState(() => _index++);
          },
        ),
      ],
    );
  }

  Widget locationArea() {
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
                  '거주지역 선택',
                  style: TextStyle(
                    color: kFontGray900Color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '선택한 지역의 게시글을 모아 볼 수 있어요.',
                  style: TextStyle(
                    fontSize: 14,
                    color: kFontGray500Color,
                    height: 20 / 14,
                  ),
                ),
                const SizedBox(height: 36),
                GestureDetector(
                  onTap: () async {
                    UserPlace? selectedUserPlace = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const SelectLocationBottomSheet(),
                    );
                    if (selectedUserPlace == null) return;
                    setState(() => _userPlace = selectedUserPlace);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: kFontGray50Color,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/svg/location_24px.svg'),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Builder(builder: (context) {
                            if (_userPlace == null) {
                              return Text(
                                '사는 지역을 선택해 주세요.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: kFontGray400Color,
                                  height: 20 / 14,
                                ),
                              );
                            }
                            return Text(
                              '${_userPlace!.city} ${_userPlace!.county}',
                              style: TextStyle(
                                fontSize: 14,
                                color: kFontGray800Color,
                                height: 20 / 14,
                              ),
                            );
                          }),
                        ),
                        SvgPicture.asset(
                          'assets/icons/svg/arrow_down_20px.svg',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        CommonActionButton(
          value: canNextPressed,
          title: '다음',
          onTap: () {
            if (!canNextPressed) return;
            widget.nextPressed(_gender.name, _birthday, _userPlace);
          },
        ),
      ],
    );
  }

  Widget genderButton(Gender gender) {
    return GestureDetector(
      onTap: () => setState(() => _gender = gender),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 10),
        width: 80,
        height: 52,
        decoration: BoxDecoration(
          color: _gender == gender ? kSubColor1 : kFontGray50Color,
          border: _gender == gender ? Border.all(color: kMainColor) : null,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          gender.name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: _gender == gender ? FontWeight.bold : null,
            color: _gender == gender ? kSubColor3 : kFontGray400Color,
            height: 20 / 14,
          ),
        ),
      ),
    );
  }
}
