import 'package:common/constants/constants_colors.dart';
import 'package:common/constants/constants_value.dart';
import 'package:common/services/gathering_service.dart';
import 'package:flutter/material.dart';

import '../../utils/local_utils.dart';

class GatheringApproveDialog extends StatelessWidget {
  final String category;
  final String gatheringId;
  final String applicantId;
  const GatheringApproveDialog({
    Key? key,
    required this.category,
    required this.gatheringId,
    required this.applicantId,
  }) : super(key: key);

  String getText() {
    switch (category) {
      case kOneDayGatheringCategory:
        return '하루모임 신청을';
      case kClubGatheringCategory:
      default:
        return '소모임 가입 신청을';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: kWhiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 20),
            constraints: const BoxConstraints(
              minHeight: 100,
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  height: 24 / 16,
                  color: kFontGray800Color,
                ),
                children: [
                  TextSpan(text: getText()),
                  TextSpan(
                    text: ' 승인 ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kOkColor,
                    ),
                  ),
                  const TextSpan(text: '할까요?'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                kDialogButton(
                  title: '닫기',
                  onTap: () => Navigator.pop(context),
                  backgroundColor: kDarkGray20Color,
                  titleColor: kDarkGray30Color,
                ),
                const SizedBox(width: 10),
                kDialogButton(
                  title: '승인',
                  onTap: () => GatheringService.approveGathering(
                          category: category,
                          id: gatheringId,
                          applicantId: applicantId)
                      .then(
                    (value) {
                      Navigator.pop(context);
                      showMessage(context,message: '${getText()} 승인했습니다');
                    }
                  ),
                  backgroundColor: kMainColor,
                  titleColor: kSubColor1,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget kDialogButton({
    required String title,
    required Function onTap,
    required Color backgroundColor,
    required Color titleColor,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(),
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 50,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
