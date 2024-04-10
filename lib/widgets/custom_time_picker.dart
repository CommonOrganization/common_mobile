import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/constants_colors.dart';
import '../constants/constants_value.dart';
import '../utils/local_utils.dart';

class CustomTimePicker extends StatefulWidget {
  const CustomTimePicker({super.key});

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {

  final FixedExtentScrollController _hourController =
  FixedExtentScrollController(initialItem: 12);
  final FixedExtentScrollController _minuteController =
  FixedExtentScrollController();

  int _hour = 12;
  int _minute = 0;

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
                      scrollController: _hourController,
                      itemExtent: 35,
                      onSelectedItemChanged: (int index) =>
                      _hour = index,
                      selectionOverlay:
                      const CupertinoPickerDefaultSelectionOverlay(
                        capEndEdge: false,
                      ),
                      offAxisFraction: -0.5,
                      squeeze: 1.2,
                      children: List.generate(
                        24,
                            (index) => Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '$index시',
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
                      scrollController: _minuteController,
                      itemExtent: 35,
                      onSelectedItemChanged: (int index) => _minute = index *10,
                      selectionOverlay:
                      const CupertinoPickerDefaultSelectionOverlay(
                        capStartEdge: false,
                        capEndEdge: false,
                      ),
                      squeeze: 1.2,
                      children: List.generate(
                        6,
                            (index) => Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${index*10}분',
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
                TimeOfDay selectedTime = TimeOfDay(hour: _hour,minute: _minute);
                if (selectedTime.hour != _hour ||
                    selectedTime.minute != _minute) {
                  showMessage(context, message: '모임 시간을 다시 한번 확인해 주세요');
                  return;
                }
                Navigator.pop(context, selectedTime);
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
