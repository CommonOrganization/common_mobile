import 'package:flutter/material.dart';

import '../../constants/constants_colors.dart';
import '../../services/daily_service.dart';
import '../../utils/local_utils.dart';
import 'bottom_sheet_custom_button.dart';

class CommentReplyEditBottomSheet extends StatelessWidget {
  final String dailyId;
  final String commentId;
  final String? replyId;

  const CommentReplyEditBottomSheet(
      {super.key, required this.dailyId, required this.commentId, this.replyId});

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
                  onPressed: () {
                    if (replyId == null) {
                      DailyService.deleteComment(
                              dailyId: dailyId, commentId: commentId)
                          .then((value) {
                        Navigator.pop(context);
                        showMessage(context, message: '댓글을 삭제했습니다.');
                      });
                      return;
                    }
                    DailyService.deleteReply(
                        dailyId: dailyId, commentId: commentId,replyId: replyId!)
                        .then((value) {
                      Navigator.pop(context);
                      showMessage(context, message: '대댓글을 삭제했습니다.');
                    });
                    return;
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
