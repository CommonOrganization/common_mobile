import 'package:common/constants/constants_colors.dart';
import 'package:common/screens/gathering_upload/components/gathering_upload_next_button.dart';
import 'package:flutter/material.dart';

class OneDayGatheringCapacityScreen extends StatefulWidget {
  final Function nextPressed;
  const OneDayGatheringCapacityScreen({Key? key, required this.nextPressed})
      : super(key: key);

  @override
  State<OneDayGatheringCapacityScreen> createState() =>
      _OneDayGatheringCapacityScreenState();
}

class _OneDayGatheringCapacityScreenState
    extends State<OneDayGatheringCapacityScreen> {
  final TextEditingController _gatheringCapacityController =
      TextEditingController(text: '2');

  int _gatheringCapacity = 2;

  void onChanged(String text) {
    try {
      int capacity = int.parse(text);
      if (capacity < 2 || capacity > 30) {
        // 조건에 맞지 않을경우 기존에 저장된 값을 가져와서 저장한다.
        _gatheringCapacityController.text = _gatheringCapacity.toString();
        _gatheringCapacityController.selection = TextSelection.fromPosition(
            TextPosition(offset: _gatheringCapacityController.text.length));
        return;
      }
      // 적당한 값일경우 새로운 값으로 바꾸어준다 -> 텍스트필드에서 자체적으로 값을 바꾸어보여주기에 여기서는 값만 새로 업데이트해준다
      _gatheringCapacity = capacity;
    } catch (e) {
      // 에러가 발생할경우 기존에 저장된 값을 가져와서 저장한다.
      _gatheringCapacityController.text = _gatheringCapacity.toString();
      _gatheringCapacityController.selection = TextSelection.fromPosition(
          TextPosition(offset: _gatheringCapacityController.text.length));
    }
  }

  void onValueChanged(int value) {
    try {
      setState(() {
        if (value < 2 || value > 30) {
          // 조건에 맞지 않을경우 기존에 저장된 값을 가져와서 저장한다.
          _gatheringCapacityController.text = _gatheringCapacity.toString();
          _gatheringCapacityController.selection = TextSelection.fromPosition(
              TextPosition(offset: _gatheringCapacityController.text.length));
          return;
        }
        // 적당한 값일경우 새로운 값으로 바꾸어준다
        _gatheringCapacity = value;
        _gatheringCapacityController.text = value.toString();
        _gatheringCapacityController.selection = TextSelection.fromPosition(
            TextPosition(offset: _gatheringCapacityController.text.length));
      });
    } catch (e) {
      setState(() {
        // 에러가 발생할경우 기존에 저장된 값을 가져와서 저장한다.
        _gatheringCapacityController.text = _gatheringCapacity.toString();
        _gatheringCapacityController.selection = TextSelection.fromPosition(
            TextPosition(offset: _gatheringCapacityController.text.length));
      });
    }
  }

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
                      fontSize: 14,
                      color: kFontGray500Color,
                      height: 20 / 13,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: kFontGray100Color),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => onValueChanged(
                                int.parse(_gatheringCapacityController.text) -
                                    1),
                            child: Container(
                              width: 30,
                              height: 30,
                              color: kWhiteColor,
                              child: Icon(
                                Icons.remove,
                                color: int.parse(_gatheringCapacityController
                                            .text) ==
                                        2
                                    ? kFontGray100Color
                                    : kFontGray500Color,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: _gatheringCapacityController,
                              style: TextStyle(
                                fontSize: 18,
                                color: kFontGray800Color,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                                height: 20 / 18,
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 2,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                isDense: true,
                                counterText: '',
                              ),
                              onChanged: (text) => onChanged(text),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => onValueChanged(
                                int.parse(_gatheringCapacityController.text) +
                                    1),
                            child: Container(
                              width: 30,
                              height: 30,
                              color: kWhiteColor,
                              child: Icon(
                                Icons.add,
                                color: int.parse(_gatheringCapacityController
                                            .text) ==
                                        30
                                    ? kFontGray100Color
                                    : kFontGray500Color,
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
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
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
                          '최소 2명 ~ 최대 30명',
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
          GatheringUploadNextButton(
            value: true,
            onTap: () => widget.nextPressed(_gatheringCapacity),
            title: '다음',
          ),
        ],
      ),
    );
  }
}
