import 'package:common/utils/local_utils.dart';
import 'package:flutter/cupertino.dart';
import '../constants/constants_colors.dart';
import '../constants/constants_value.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({super.key});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  final int _yearCount = 2;

  late final FixedExtentScrollController _yearController;
  late final FixedExtentScrollController _monthController;
  late final FixedExtentScrollController _dayController;

  late int _year;
  late int _currentYear;
  late int _month;
  late int _day;

  @override
  void initState() {
    super.initState();
    DateTime nowDate = DateTime.now();
    _year = nowDate.year;
    _currentYear = nowDate.year;
    _month = nowDate.month;
    _day = nowDate.day;
    _yearController = FixedExtentScrollController();
    _monthController = FixedExtentScrollController(initialItem: _month - 1);
    _dayController = FixedExtentScrollController(initialItem: _day - 1);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        height: kBottomSheetHeight,
        color: kWhiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              width: double.infinity,
              child: Container(
                width: 60,
                height: 4,
                color: kFontGray100Color,
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: _yearController,
                      itemExtent: 35,
                      onSelectedItemChanged: (int index) =>
                          _year = index + _currentYear,
                      selectionOverlay:
                          const CupertinoPickerDefaultSelectionOverlay(
                        capEndEdge: false,
                      ),
                      offAxisFraction: -0.5,
                      squeeze: 1.2,
                      children: List.generate(
                        _yearCount,
                        (index) => Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${index + _currentYear}년',
                            style: const TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      useMagnifier: true,
                      scrollController: _monthController,
                      itemExtent: 35,
                      onSelectedItemChanged: (int index) => _month = index + 1,
                      selectionOverlay:
                          const CupertinoPickerDefaultSelectionOverlay(
                        capStartEdge: false,
                        capEndEdge: false,
                      ),
                      squeeze: 1.2,
                      children: List.generate(
                        12,
                        (index) => Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 1}월',
                            style: const TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: _dayController,
                      itemExtent: 35,
                      onSelectedItemChanged: (int index) => _day = index + 1,
                      selectionOverlay:
                          const CupertinoPickerDefaultSelectionOverlay(
                        capStartEdge: false,
                      ),
                      offAxisFraction: 0.5,
                      squeeze: 1.2,
                      children: List.generate(
                        31,
                        (index) => Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${index + 1}일',
                            style: const TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                DateTime selectedDate = DateTime(_year, _month, _day);
                if (selectedDate.year != _year ||
                    selectedDate.month != _month ||
                    selectedDate.day != _day) {
                  showMessage(context, message: '날짜를 다시 한번 확인해 주세요');
                  return;
                }
                Navigator.pop(context, selectedDate);
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                color: kMainColor,
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Text(
                      '완료',
                      style: TextStyle(
                        fontSize: 18,
                        color: kWhiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
