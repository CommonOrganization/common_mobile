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
  int _gatheringCapacity = 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            child: ListView(
              children: [
                Text(
                  '몇명과 함께 할까요?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kGrey1C1C1EColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '본인을 포함한 총 참여 인원 수를 설정해 주세요.',
                  style: TextStyle(
                    fontSize: 14,
                    color: kGrey8E8E93Color,
                  ),
                ),
                const SizedBox(height: 36),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: kWhiteC6C6C6Color),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_gatheringCapacity > 2) {
                              setState(() => _gatheringCapacity--);
                            }
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            color: kWhiteColor,
                            child: Icon(
                              Icons.remove,
                              color: kWhiteAEAEB2Color,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              '$_gatheringCapacity',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: kGrey363639Color,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_gatheringCapacity < 10) {
                              setState(() => _gatheringCapacity++);
                            }
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            color: kWhiteColor,
                            child: Icon(
                              Icons.add,
                              color: kGrey363639Color,
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
                    color: kWhiteF6F6F6Color,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '인원 안내',
                        style: TextStyle(
                          fontSize: 11,
                          color: kGrey48484AColor,
                        ),
                      ),
                      Text(
                        '최소 2명 ~ 최대 10명',
                        style: TextStyle(
                          fontSize: 10,
                          color: kGrey636366Color,
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
          onTap: () =>widget.nextPressed(_gatheringCapacity),
        ),
      ],
    );
  }
}
