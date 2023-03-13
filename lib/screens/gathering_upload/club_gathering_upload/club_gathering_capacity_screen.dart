import 'package:common/constants/constants_colors.dart';
import 'package:common/screens/gathering_upload/components/gathering_upload_next_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClubGatheringCapacityScreen extends StatefulWidget {
  final Function nextPressed;
  const ClubGatheringCapacityScreen({Key? key, required this.nextPressed})
      : super(key: key);

  @override
  State<ClubGatheringCapacityScreen> createState() =>
      _ClubGatheringCapacityScreenState();
}

class _ClubGatheringCapacityScreenState
    extends State<ClubGatheringCapacityScreen> {
  int _decimalNumber = 1;
  int _digitNumber = 0;

  @override
  Widget build(BuildContext context) {
    CupertinoDatePicker(
      onDateTimeChanged: (DateTime value) {},
    );
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                const SizedBox(height: 12),
                Text(
                  '몇명과 함께 할까요?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kFontGray900Color,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '본인을 포함한 총 참여 인원 수를 설정해 주세요.',
                  style: TextStyle(
                    fontSize: 13,
                    color: kFontGray500Color,
                    height: 20/13,
                  ),
                ),
                const SizedBox(height: 36),
                Center(
                  child: SizedBox(
                    width: 100,
                    height: 150,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 50,
                            diameterRatio: 1,
                            selectionOverlay:
                                const CupertinoPickerDefaultSelectionOverlay(
                              background: Colors.transparent,
                              capEndEdge: false,
                              capStartEdge: false,
                            ),
                            onSelectedItemChanged: (index) =>
                                setState(() => _decimalNumber = index + 1),
                            children: List.generate(
                              9,
                              (index) => Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: _decimalNumber == index + 1
                                      ? Border.symmetric(
                                          horizontal: BorderSide(
                                            color: kSubColor1,
                                            width: 1.5,
                                          ),
                                        )
                                      : null,
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: 36,
                                    color: kMainColor,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 50,
                            diameterRatio: 1,
                            selectionOverlay:
                                const CupertinoPickerDefaultSelectionOverlay(
                              background: Colors.transparent,
                              capEndEdge: false,
                              capStartEdge: false,
                            ),
                            onSelectedItemChanged: (index) =>
                                setState(() =>_digitNumber = index),
                            children: List.generate(
                              10,
                              (index) => Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: _digitNumber == index
                                      ? Border.symmetric(
                                    horizontal: BorderSide(
                                      color: kSubColor1,
                                      width: 1.5,
                                    ),
                                  )
                                      : null,
                                ),
                                child: Text(
                                  '$index',
                                  style: TextStyle(
                                    fontSize: 36,
                                    color: kMainColor,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 66),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: kFontGray50Color,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '인원 안내',
                        style: TextStyle(
                          fontSize: 13,
                          color: kFontGray600Color,
                          height: 20/13,
                        ),
                      ),
                      Text(
                        '최소 10명 ~ 최대 99명',
                        style: TextStyle(
                          fontSize: 12,
                          color: kFontGray500Color,
                          height: 20/12,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        GatheringUploadNextButton(
          value: true,
          onTap: () =>widget.nextPressed(_decimalNumber * 10 + _digitNumber),
        ),
      ],
    );
  }
}
