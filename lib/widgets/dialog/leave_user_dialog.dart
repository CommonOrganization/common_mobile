import 'package:common/constants/constants_colors.dart';
import 'package:flutter/material.dart';


class LeaveUserDialog extends StatelessWidget {
  const LeaveUserDialog({super.key});

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
          Text(
            '정말 탈퇴하시겠습니까?',
            style: TextStyle(
              fontSize: 16,
              height: 20 / 16,
              color: kFontGray800Color,
            ),
          ),
          const SizedBox(height: 30),
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
                  title: '탈퇴하기',
                  onTap: () =>Navigator.pop(context,true),
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
