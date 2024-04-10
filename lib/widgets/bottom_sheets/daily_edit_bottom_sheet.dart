import 'package:common/controllers/screen_controller.dart';
import 'package:common/models/daily/daily.dart';
import 'package:common/services/daily_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/constants_colors.dart';
import '../../utils/local_utils.dart';
import 'bottom_sheet_custom_button.dart';

class DailyEditBottomSheet extends StatelessWidget {
  final Daily daily;
  const DailyEditBottomSheet({super.key, required this.daily});

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
                  title: '삭제하기',
                  onPressed: () =>
                      DailyService.deleteDaily(dailyId: daily.id).then(
                    (value) {
                      context.read<ScreenController>().pageRefresh();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      showMessage(context, message: '데일리를 삭제했습니다.');
                    },
                  ),
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
