import 'package:common/constants/constants_enum.dart';
import 'package:common/models/user_place/user_place.dart';
import 'package:common/screens/sign/bottom_sheets/user_place_bottom_sheet.dart';
import 'package:common/widgets/custom_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/constants_colors.dart';
import '../../utils/date_utils.dart';
import 'components/register_next_button.dart';

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

  Widget genderArea() => Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    '회원정보 입력',
                    style: TextStyle(
                      color: kGrey1C1C1EColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '응답하신 정보는 모두에게 공개됩니다.',
                    style: TextStyle(
                      fontSize: 14,
                      color: kGrey8E8E93Color,
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
                            color: kGrey363639Color,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: Gender.values
                              .map(
                                (gender) => GestureDetector(
                                  onTap: () => setState(() => _gender = gender),
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(right: 10),
                                    width: 80,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: _gender == gender
                                          ? kMainBackgroundColor
                                          : kWhiteF6F6F6Color,
                                      border: _gender == gender
                                          ? Border.all(color: kMainColor)
                                          : null,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      gender.name,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: _gender == gender
                                            ? FontWeight.bold
                                            : null,
                                        color: _gender == gender
                                            ? kFontMainColor
                                            : kWhiteAEAEB2Color,
                                      ),
                                    ),
                                  ),
                                ),
                              )
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
                            color: kGrey363639Color,
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
                              builder: (context) => const CustomDatePicker(),
                            );
                            if (selectedDate != null) {
                              setState(() => _birthday = selectedDate);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            width: double.infinity,
                            height: 52,
                            decoration: BoxDecoration(
                              color: kWhiteF4F4F4Color,
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
                                          ? kGrey363639Color
                                          : kWhiteAEAEB2Color,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.expand_more,
                                  size: 20,
                                  color: kWhiteAEAEB2Color,
                                ),
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
          RegisterNextButton(
            value: canNextPressed,
            onTap: () {
              if (!canNextPressed) return;
              setState(() => _index++);
            },
          ),
        ],
      );

  Widget locationArea() => Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    '거주지역 선택',
                    style: TextStyle(
                      color: kGrey1C1C1EColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '선택한 지역의 게시글을 모아 볼 수 있어요.',
                    style: TextStyle(
                      fontSize: 14,
                      color: kGrey8E8E93Color,
                    ),
                  ),
                  const SizedBox(height: 36),
                  GestureDetector(
                    onTap: () async {
                      UserPlace? selectedUserPlace = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const UserPlaceBottomSheet(),
                      );
                      if (selectedUserPlace != null) {
                        setState(() => _userPlace = selectedUserPlace);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: kWhiteF6F6F6Color,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/icons/svg/location.svg'),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Builder(builder: (context) {
                              if (_userPlace == null) {
                                return Text(
                                  '사는 지역을 선택해 주세요.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: kWhiteAEAEB2Color,
                                  ),
                                );
                              }
                              return Text(
                                '${_userPlace!.city} ${_userPlace!.county}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: kGrey363639Color,
                                ),
                              );
                            }),
                          ),
                          Icon(
                            Icons.expand_more,
                            size: 20,
                            color: kWhiteAEAEB2Color,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          RegisterNextButton(
            value: canNextPressed,
            onTap: () {
              if (!canNextPressed) return;
              widget.nextPressed(_gender.name, _birthday, _userPlace);
            },
          ),
        ],
      );
}
