import 'package:common/constants/constants_colors.dart';
import 'package:common/constants/constants_value.dart';
import 'package:common/models/user_place/user_place.dart';
import 'package:common/screens/gathering_upload/components/gathering_upload_next_button.dart';
import 'package:common/utils/local_utils.dart';
import 'package:common/widgets/custom_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../widgets/custom_date_picker.dart';
import '../../sign/bottom_sheets/user_place_bottom_sheet.dart';

class OneDayGatheringScheduleScreen extends StatefulWidget {
  final Function nextPressed;
  const OneDayGatheringScheduleScreen({Key? key, required this.nextPressed})
      : super(key: key);

  @override
  State<OneDayGatheringScheduleScreen> createState() =>
      _OneDayGatheringScheduleScreenState();
}

class _OneDayGatheringScheduleScreenState
    extends State<OneDayGatheringScheduleScreen> {
  final TextEditingController _gatheringPlaceDetailController =
      TextEditingController();
  final TextEditingController _gatheringEntryFeeController =
      TextEditingController();

  DateTime? _gatheringDate;
  TimeOfDay? _gatheringTime;
  UserPlace? _gatheringPlace;
  bool? _isHaveEntryFee;

  bool get canNextPress =>
      _gatheringPlace != null &&
      _gatheringPlaceDetailController.text.isNotEmpty &&
      _isHaveEntryFee != null &&
      ((_isHaveEntryFee ?? false)
          ? _gatheringEntryFeeController.text.isNotEmpty
          : true);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 18),
            child: ListView(
              children: [
                Text(
                  '하루모임 일정을 설정해볼까요?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kGrey1C1C1EColor,
                  ),
                ),
                const SizedBox(height: 36),
                Text(
                  '모임 일정',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kGrey2C2C2EColor,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    DateTime? selectedDate = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const CustomDatePicker(),
                    );
                    if (!mounted) return;
                    if (selectedDate != null) {
                      if (selectedDate
                          .difference(
                              DateTime.now().subtract(const Duration(days: 1)))
                          .isNegative) {
                        showMessage(context, message: '이미 지난 날짜로는 설정할 수 없습니다');
                        return;
                      }
                      setState(() => _gatheringDate = selectedDate);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: kWhiteF6F6F6Color,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/svg/calendar.svg'),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Builder(builder: (context) {
                            if (_gatheringDate == null) {
                              return Text(
                                '모임 날짜를 선택해 주세요.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: kWhiteAEAEB2Color,
                                ),
                              );
                            }
                            return Text(
                              '${_gatheringDate!.month}.${_gatheringDate!.day} (${kShortWeekdayList[_gatheringDate!.weekday - 1]})',
                              style: TextStyle(
                                fontSize: 13,
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
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    TimeOfDay? selectedTimeOfDay = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const CustomTimePicker(),
                    );
                    if (!mounted) return;
                    if (selectedTimeOfDay != null) {
                      setState(() => _gatheringTime = selectedTimeOfDay);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: kWhiteF6F6F6Color,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/svg/clock.svg'),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Builder(builder: (context) {
                            if (_gatheringTime == null) {
                              return Text(
                                '모임 시간을 선택해 주세요.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: kWhiteAEAEB2Color,
                                ),
                              );
                            }
                            return Text(
                              '${_gatheringTime!.hour >= 12 ? '오후' : '오전'} ${_gatheringTime!.hour > 12 ? _gatheringTime!.hour - 12 : _gatheringTime!.hour}:${_gatheringTime!.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 13,
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
                ),
                const SizedBox(height: 36),
                Text(
                  '모임 장소',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kGrey2C2C2EColor,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    UserPlace? selectedGatheringPlace =
                        await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const UserPlaceBottomSheet(),
                    );
                    if (selectedGatheringPlace != null) {
                      setState(() => _gatheringPlace = selectedGatheringPlace);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
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
                            if (_gatheringPlace == null) {
                              return Text(
                                '모임 장소를 선택해 주세요.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: kWhiteAEAEB2Color,
                                ),
                              );
                            }
                            return Text(
                              '${_gatheringPlace!.city} ${_gatheringPlace!.county}',
                              style: TextStyle(
                                fontSize: 13,
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
                ),
                const SizedBox(height: 8),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: kWhiteF6F6F6Color,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: _gatheringPlaceDetailController,
                    style: TextStyle(fontSize: 13, color: kGrey363639Color),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      counterText: '',
                      hintText: '상세주소를 입력해 주세요. ex) 역삼동 스타벅스',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: kWhiteAEAEB2Color,
                      ),
                    ),
                    onChanged: (text) => setState(() {}),
                  ),
                ),
                const SizedBox(height: 36),
                Text(
                  '모임비',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kGrey2C2C2EColor,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    kEntryFeeButton(true),
                    const SizedBox(width: 10),
                    kEntryFeeButton(false),
                  ],
                ),
                const SizedBox(height: 16),
                if (_isHaveEntryFee ?? false)
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: kWhiteF6F6F6Color,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/svg/wallet.svg',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _gatheringEntryFeeController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                fontSize: 13, color: kGrey363639Color),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              isDense: true,
                              counterText: '',
                              hintText: '예: 식사비 10,000원',
                              hintStyle: TextStyle(
                                fontSize: 13,
                                color: kWhiteAEAEB2Color,
                              ),
                            ),
                            onChanged: (text) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        GatheringUploadNextButton(
          value: canNextPress,
          onTap: () {
            if (!canNextPress) return;
            widget.nextPressed(
              DateTime(
                  _gatheringDate!.year,
                  _gatheringDate!.month,
                  _gatheringDate!.day,
                  _gatheringTime!.hour,
                  _gatheringTime!.minute),
              _gatheringPlace,
              _gatheringPlaceDetailController.text,
              _isHaveEntryFee,
              _gatheringEntryFeeController.text,
            );
          },
        ),
      ],
    );
  }

  Widget kEntryFeeButton(bool value) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isHaveEntryFee = value),
        child: Container(
          alignment: Alignment.center,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: _isHaveEntryFee == value
                ? kMainBackgroundColor
                : kWhiteF6F6F6Color,
            border:
                _isHaveEntryFee == value ? Border.all(color: kMainColor) : null,
          ),
          child: Text(
            '모임비 ${value ? '있음' : '없음'}',
            style: TextStyle(
              color:
                  _isHaveEntryFee == value ? kFontMainColor : kWhiteAEAEB2Color,
            ),
          ),
        ),
      ),
    );
  }
}
