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
  const GatheringReportBottomSheet({Key? key, required this.gathering})
      : super(key: key);

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
                child: BottomSheetCustomButton(
                  title: '신고하기',
                  onPressed: () {
                    String? reporterId = context.read<UserController>().user?.id;
                    if(reporterId==null) return;
                    ReportService.report(reporterId: reporterId, reportedId: gathering.id);
                    Navigator.pop(context);
                    showMessage(context, message: '모임을 신고했습니다.');
                  },
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
