import 'package:common/utils/local_utils.dart';
import 'package:flutter/cupertino.dart';
import '../constants/constants_colors.dart';
import '../constants/constants_value.dart';

class BirthdayDatePicker extends StatefulWidget {
  const BirthdayDatePicker({super.key});

  @override
  State<BirthdayDatePicker> createState() => _BirthdayDatePickerState();
}

class _BirthdayDatePickerState extends State<BirthdayDatePicker> {
  final int _yearCount = DateTime.now().year - 1900 + 1;

  final FixedExtentScrollController _yearController =
      FixedExtentScrollController(initialItem: 100);
  final FixedExtentScrollController _monthController =
      FixedExtentScrollController();
  final FixedExtentScrollController _dayController =
      FixedExtentScrollController();

  int _year = 2000;
  int _month = 1;
  int _day = 1;

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
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: _yearController,
                      itemExtent: 35,
                      onSelectedItemChanged: (int index) =>
                          _year = index + 1900,
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
                            '${1900 + index}년',
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
                  showMessage(context, message: '생년월일을 다시 한번 확인해 주세요');
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
