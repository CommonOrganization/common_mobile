import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/constants_colors.dart';
import '../../controllers/block_controller.dart';
import '../../controllers/user_controller.dart';
import '../../services/report_service.dart';
import '../../utils/local_utils.dart';
import 'bottom_sheet_custom_button.dart';

class CommentReplyReportBottomSheet extends StatelessWidget {
  final String commentId;
  final String? replyId;

  const CommentReplyReportBottomSheet(
      {super.key, required this.commentId, this.replyId});

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
            Builder(builder: (context) {
              String objectId = replyId == null ? commentId : replyId!;
              String objectName = replyId == null ? '댓글' : '대댓글';
              return ClipRRect(
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
                              reporterId: reporterId, reportedId: objectId);
                          Navigator.pop(context);
                          showMessage(context, message: '$objectName을 신고했습니다.');
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
                              .blockObject(objectId);
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
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
