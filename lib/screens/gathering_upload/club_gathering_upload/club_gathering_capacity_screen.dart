import 'package:common/constants/constants_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../models/club_gathering/club_gathering.dart';
import '../../../widgets/common_action_button.dart';

class ClubGatheringCapacityScreen extends StatefulWidget {
  final ClubGathering? gathering;
  final Function nextPressed;
  const ClubGatheringCapacityScreen(
      {Key? key, required this.nextPressed, this.gathering})
      : super(key: key);

  @override
  State<ClubGatheringCapacityScreen> createState() =>
      _ClubGatheringCapacityScreenState();
}

class _ClubGatheringCapacityScreenState
    extends State<ClubGatheringCapacityScreen> {
  late final FixedExtentScrollController _decimalController =
      FixedExtentScrollController(initialItem: _decimalNumber - 1);
  late final FixedExtentScrollController _digitController =
      FixedExtentScrollController(initialItem: _digitNumber);

  int _decimalNumber = 1;
  int _digitNumber = 0;

  @override
  void initState() {
    super.initState();
    setGatheringInformation();
  }

  void setGatheringInformation() {
    if (widget.gathering == null) return;
    int capacity = widget.gathering!.capacity;
    if (capacity >= 10) {
      _decimalNumber = capacity ~/ 10;
      _digitNumber = capacity % 10;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    height: 20 / 13,
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
                            scrollController: _decimalController,
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
                            scrollController: _digitController,
                            itemExtent: 50,
                            diameterRatio: 1,
                            selectionOverlay:
                                const CupertinoPickerDefaultSelectionOverlay(
                              background: Colors.transparent,
                              capEndEdge: false,
                              capStartEdge: false,
                            ),
                            onSelectedItemChanged: (index) =>
                                setState(() => _digitNumber = index),
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
                          height: 20 / 13,
                        ),
                      ),
                      Text(
                        '최소 10명 ~ 최대 99명',
                        style: TextStyle(
                          fontSize: 12,
                          color: kFontGray500Color,
                          height: 20 / 12,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        CommonActionButton(
          value: true,
          onTap: () => widget.nextPressed(_decimalNumber * 10 + _digitNumber),
          title: '다음',
        ),
      ],
    );
  }
}
