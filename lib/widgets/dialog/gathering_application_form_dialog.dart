import 'package:common/models/recruit_answer/recruit_answer.dart';
import 'package:common/services/recruit_answer_service.dart';
import 'package:common/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/constants_colors.dart';
import '../../constants/constants_value.dart';
import '../../services/gathering_service.dart';
import '../../utils/local_utils.dart';

class GatheringApplicationFormDialog extends StatelessWidget {
  final String category;
  final String gatheringId;
  final String applierId;

  const GatheringApplicationFormDialog({
    Key? key,
    required this.gatheringId,
    required this.applierId,
    required this.category,
  }) : super(key: key);

  String get getTitle =>
      category == kOneDayGatheringCategory ? '하루모임 참여 신청서' : '소모임 가입 신청서';

  String get getApproveText => category == kOneDayGatheringCategory
      ? '하루모임 참여 신청을 승인했습니다.'
      : '소모임 가입 신청을 승인했습니다.';

  String get getDisapproveText => category == kOneDayGatheringCategory
      ? '하루모임 참여 신청을 거부했습니다.'
      : '소모임 가입 신청을 거부했습니다.';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        constraints: const BoxConstraints(
          minHeight: 150,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: double.infinity),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 20),
                Text(
                  getTitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: kFontGray800Color,
                    fontWeight: FontWeight.bold,
                    height: 24 / 16,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  behavior: HitTestBehavior.opaque,
                  child: SvgPicture.asset(
                    'assets/icons/svg/close_20px.svg',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getProfileArea(applierId),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getNameArea(applierId),
                      getInformationArea(applierId),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FutureBuilder(
                future: RecruitAnswerService.getRecruitAnswer(
                  gatheringId: gatheringId,
                  userId: applierId,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    RecruitAnswer recruitAnswer =
                        snapshot.data as RecruitAnswer;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '모임 질문 : ${recruitAnswer.question}',
                          style: TextStyle(
                            fontSize: 14,
                            color: kFontGray800Color,
                            height: 20 / 14,
                          ),
                        ),
                        Text(
                          '멤버의 답변 : ${recruitAnswer.answer}',
                          style: TextStyle(
                            fontSize: 14,
                            color: kFontGray800Color,
                            height: 20 / 14,
                          ),
                        ),
                      ],
                    );
                  }
                  return Container();
                }),
            const SizedBox(height: 24),
            Row(
              children: [
                kDialogButton(
                  title: '거부',
                  onTap: () => GatheringService.disapproveGathering(
                          category: category,
                          id: gatheringId,
                          applierId: applierId)
                      .then((value) {
                    Navigator.pop(context);
                    showMessage(context, message: getDisapproveText);
                  }),
                  backgroundColor: kDarkGray20Color,
                  titleColor: kDarkGray30Color,
                ),
                const SizedBox(width: 10),
                kDialogButton(
                  title: '승인',
                  onTap: () => GatheringService.approveGathering(
                          category: category,
                          id: gatheringId,
                          applierId: applierId)
                      .then((value) {
                    Navigator.pop(context);
                    showMessage(context, message: getApproveText);
                  }),
                  backgroundColor: kMainColor,
                  titleColor: kSubColor1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getProfileArea(String userId) {
    return FutureBuilder(
      future: UserService.get(id: userId, field: 'profileImage'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(42),
              color: kDarkGray20Color,
              image: DecorationImage(
                image: NetworkImage(snapshot.data as String),
                fit: BoxFit.cover,
              ),
            ),
          );
        }
        return Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(42),
            color: kDarkGray20Color,
          ),
        );
      },
    );
  }

  Widget getNameArea(String userId) {
    return FutureBuilder(
      future: UserService.get(id: userId, field: 'name'),
      builder: (context, snapshot) {
        return Text(
          snapshot.data ?? '',
          style: TextStyle(
            fontSize: 14,
            color: kFontGray800Color,
            height: 20 / 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }

  Widget getInformationArea(String userId) {
    return FutureBuilder(
      future: UserService.get(id: userId, field: 'information'),
      builder: (context, snapshot) {
        return Text(
          snapshot.data ?? '',
          style: TextStyle(
            fontSize: 13,
            color: kFontGray500Color,
            height: 16 / 13,
          ),
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        );
      },
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
