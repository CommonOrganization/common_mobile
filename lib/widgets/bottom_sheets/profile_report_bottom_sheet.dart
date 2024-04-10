import 'package:common/controllers/user_controller.dart';
import 'package:common/services/report_service.dart';
import 'package:common/utils/local_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/constants_colors.dart';
import '../../controllers/block_controller.dart';
import 'bottom_sheet_custom_button.dart';

class ProfileReportBottomSheet extends StatelessWidget {
  final String userId;
  const ProfileReportBottomSheet({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    BottomSheetCustomButton(
                      title: '이용자와 이용자의 컨텐츠 숨기기',
                      onPressed: () => context
                          .read<BlockController>()
                          .blockObject(userId)
                          .then((value) => Navigator.pop(context)),
                    ),
                    Container(
                        width: double.infinity,
                        height: 1,
                        color: kDarkGray20Color),
                    BottomSheetCustomButton(
                      title: '신고하기',
                      onPressed: () {
                        String? reporterId =
                            context.read<UserController>().user?.id;
                        if (reporterId == null) return;
                        ReportService.report(
                            reporterId: reporterId, reportedId: userId);
                        Navigator.pop(context);
                        showMessage(context, message: '유저를 신고했습니다.');
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            SafeArea(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    '취소',
                    style: TextStyle(
                      fontSize: 16,
                      color: kMainColor,
                      fontWeight: FontWeight.bold,
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
