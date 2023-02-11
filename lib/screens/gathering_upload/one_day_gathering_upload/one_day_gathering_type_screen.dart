import 'package:common/constants/constants_colors.dart';
import 'package:common/constants/constants_enum.dart';
import 'package:common/screens/gathering_upload/components/gathering_upload_next_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OneDayGatheringTypeScreen extends StatefulWidget {
  final Function nextPressed;
  const OneDayGatheringTypeScreen({Key? key, required this.nextPressed})
      : super(key: key);

  @override
  State<OneDayGatheringTypeScreen> createState() =>
      _OneDayGatheringTypeScreenState();
}

class _OneDayGatheringTypeScreenState extends State<OneDayGatheringTypeScreen> {
  GatheringType _selectedGatheringType = GatheringType.oneDay;

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
                  '어떤 하루모임을 열어볼까요?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kGrey1C1C1EColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '\'하루모임\'은 원데이로 만나 활동을 하는 모임이에요.\n장기간 함께 활동하는 모임을 원하실 경우 \'소모임\'으로 열어주세요!',
                  style: TextStyle(
                    fontSize: 13,
                    color: kGrey8E8E93Color,
                  ),
                ),
                const SizedBox(height: 36),
                kGatheringTypeCard(GatheringType.oneDay),
                const SizedBox(height: 12),
                kGatheringTypeCard(GatheringType.clubOneDay),
              ],
            ),
          ),
        ),
        GatheringUploadNextButton(
          value: true,
          onTap: () => widget.nextPressed(_selectedGatheringType),
        ),
      ],
    );
  }

  Widget kGatheringTypeCard(GatheringType gatheringType) {
    return GestureDetector(
      onTap: () => setState(() => _selectedGatheringType = gatheringType),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        height: 82,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: _selectedGatheringType == gatheringType
              ? kMainColor
              : kWhiteF6F6F6Color,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              gatheringType.icon,
              width: 22,
              height: 22,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    gatheringType.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _selectedGatheringType == gatheringType
                          ? kWhiteColor
                          : kGrey48484AColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    gatheringType.content,
                    style: TextStyle(
                      fontSize: 13,
                      color: _selectedGatheringType == gatheringType
                          ? kWhiteColor
                          : kGrey8E8E93Color,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
