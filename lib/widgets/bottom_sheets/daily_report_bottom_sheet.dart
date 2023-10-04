import 'package:common/models/daily/daily.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/constants_colors.dart';
import '../../controllers/user_controller.dart';
import '../../services/report_service.dart';
import '../../utils/local_utils.dart';
import 'bottom_sheet_custom_button.dart';

class DailyReportBottomSheet extends StatelessWidget {
  final Daily daily;
  const DailyReportBottomSheet({Key? key, required this.daily})
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
                  color: kErrorColor,
                  onPressed: () {
                    String? reporterId =
                        context.read<UserController>().user?.id;
                    if (reporterId == null) return;
                    ReportService.report(
                        reporterId: reporterId, reportedId: daily.id);
                    Navigator.pop(context);
                    showMessage(context, message: '데일리를 신고했습니다.');
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
