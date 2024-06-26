import 'package:common/controllers/block_controller.dart';
import 'package:common/controllers/user_controller.dart';
import 'package:common/services/report_service.dart';
import 'package:common/utils/local_utils.dart';
import 'package:common/widgets/bottom_sheets/bottom_sheet_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants_colors.dart';
import '../../models/gathering/gathering.dart';

class GatheringReportBottomSheet extends StatelessWidget {
  final Gathering gathering;
  const GatheringReportBottomSheet({super.key, required this.gathering});

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
                      title: '신고하기',
                      onPressed: () {
                        String? reporterId =
                            context.read<UserController>().user?.id;
                        if (reporterId == null) return;
                        ReportService.report(
                            reporterId: reporterId, reportedId: gathering.id);
                        Navigator.pop(context);
                        showMessage(context, message: '모임을 신고했습니다.');
                      },
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: kDarkGray20Color,
                    ),
                    BottomSheetCustomButton(
                      title: '숨기기',
                      onPressed: () async {
                        await context
                            .read<BlockController>()
                            .blockObject(gathering.id);
                        if (context.mounted) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
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
