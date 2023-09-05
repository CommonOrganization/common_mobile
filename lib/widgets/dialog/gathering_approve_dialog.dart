import 'package:common/constants/constants_colors.dart';
import 'package:common/constants/constants_value.dart';
import 'package:common/services/gathering_service.dart';
import 'package:common/services/user_service.dart';
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

  String get getTitle => category == kOneDayGatheringCategory
      ? ' 님의 하루모임\n참여 신청을 승인할까요?'
      : ' 님의 소모임\n가입 신청을 승인할까요?';

  String get getText => category == kOneDayGatheringCategory
      ? '하루모임 참여 신청을 승인했습니다.'
      : '소모임 가입 신청을 승인했습니다.';

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
          const SizedBox(height: 30),
          FutureBuilder(
            future: UserService.get(id: applicantId, field: 'name'),
            builder: (context, snapshot) {
              return RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    height: 20 / 14,
                    color: kFontGray800Color,
                  ),
                  children: [
                    TextSpan(
                      text: snapshot.data,
                      style: TextStyle(
                        fontSize: 16,
                        height: 20 / 16,
                        color: kFontGray900Color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: getTitle),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
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
                      .then((value) {
                    Navigator.pop(context);
                    showMessage(context, message: getText);
                  }),
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
          height: 44,
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
