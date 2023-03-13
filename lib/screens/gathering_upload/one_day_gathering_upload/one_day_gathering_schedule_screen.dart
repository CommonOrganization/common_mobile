import 'package:common/constants/constants_colors.dart';
import 'package:common/constants/constants_value.dart';
import 'package:common/models/user_place/user_place.dart';
import 'package:common/screens/gathering_upload/components/gathering_upload_next_button.dart';
import 'package:common/utils/local_utils.dart';
import 'package:common/widgets/custom_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../widgets/custom_date_picker.dart';
import '../../../widgets/select_location_bottom_sheet.dart';

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
                    '하루모임 일정을 설정해볼까요?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kFontGray900Color,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Text(
                    '모임 일정',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kFontGray800Color,
                      height: 20 / 15,
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
                            .difference(DateTime.now()
                                .subtract(const Duration(days: 1)))
                            .isNegative) {
                          showMessage(context,
                              message: '이미 지난 날짜로는 설정할 수 없습니다');
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
                        color: kFontGray50Color,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                              'assets/icons/svg/calendar_24px.svg'),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Builder(builder: (context) {
                              if (_gatheringDate == null) {
                                return Text(
                                  '모임 날짜를 선택해 주세요.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: kFontGray400Color,
                                    height: 20 / 14,
                                  ),
                                );
                              }
                              return Text(
                                '${_gatheringDate!.month}.${_gatheringDate!.day} (${kShortWeekdayList[_gatheringDate!.weekday - 1]})',
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
                        color: kFontGray50Color,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/icons/svg/clock_24px.svg'),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Builder(builder: (context) {
                              if (_gatheringTime == null) {
                                return Text(
                                  '모임 시간을 선택해 주세요.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: kFontGray400Color,
                                    height: 20 / 14,
                                  ),
                                );
                              }
                              return Text(
                                '${_gatheringTime!.hour >= 12 ? '오후' : '오전'} ${_gatheringTime!.hour > 12 ? _gatheringTime!.hour - 12 : _gatheringTime!.hour}:${_gatheringTime!.minute.toString().padLeft(2, '0')}',
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
                  const SizedBox(height: 36),
                  Text(
                    '모임 장소',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kFontGray800Color,
                      height: 20 / 15,
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
                        builder: (context) => const SelectLocationBottomSheet(),
                      );
                      if (selectedGatheringPlace != null) {
                        setState(
                            () => _gatheringPlace = selectedGatheringPlace);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: kFontGray50Color,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                              'assets/icons/svg/location_24px.svg'),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Builder(builder: (context) {
                              if (_gatheringPlace == null) {
                                return Text(
                                  '모임 장소를 선택해 주세요.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: kFontGray400Color,
                                    height: 20 / 14,
                                  ),
                                );
                              }
                              return Text(
                                '${_gatheringPlace!.city} ${_gatheringPlace!.county}',
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
                  const SizedBox(height: 8),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: kFontGray50Color,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: _gatheringPlaceDetailController,
                      style: TextStyle(
                        fontSize: 14,
                        color: kFontGray800Color,
                        height: 20 / 14,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        counterText: '',
                        hintText: '상세주소를 입력해 주세요. ex) 역삼동 스타벅스',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: kFontGray400Color,
                          height: 20 / 14,
                        ),
                      ),
                      onChanged: (text) => setState(() {}),
                    ),
                  ),
                  const SizedBox(height: 36),
                  Text(
                    '모임비',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kGrey2C2C2EColor,
                      height: 20 / 15,
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
                        color: kFontGray50Color,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/svg/wallet_24px.svg',
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _gatheringEntryFeeController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 14,
                                color: kFontGray800Color,
                                height: 20 / 14,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                isDense: true,
                                counterText: '',
                                hintText: '예: 식사비 10,000원',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: kFontGray400Color,
                                  height: 20 / 14,
                                ),
                              ),
                              onChanged: (text) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 40),
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
      ),
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
            color: _isHaveEntryFee == value ? kSubColor1 : kFontGray50Color,
            border:
                _isHaveEntryFee == value ? Border.all(color: kMainColor) : null,
          ),
          child: Text(
            '모임비 ${value ? '있음' : '없음'}',
            style: TextStyle(
              color: _isHaveEntryFee == value ? kSubColor3 : kFontGray400Color,
              fontWeight: _isHaveEntryFee == value
                  ? FontWeight.bold
                  : FontWeight.normal,
              fontSize: 14,
              height: 20 / 14,
            ),
          ),
        ),
      ),
    );
  }
}
