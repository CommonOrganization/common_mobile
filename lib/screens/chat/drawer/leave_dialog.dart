import 'package:flutter/material.dart';

import '../../../constants/constants_colors.dart';

class LeaveDialog extends StatelessWidget {
  final bool isGroupChat;
  const LeaveDialog({super.key, required this.isGroupChat});

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              isGroupChat
                  ? '이 채팅방을 나가면 다른 멤버가 다시 초대하기 전까지 채팅방에 다시 참여할 수 없습니다.\n그래도 나가시겠습니까?'
                  : '이 채팅방을 나가면 직접 상대방에게 채팅을 하기 전까지 채팅방 메시지가 와도 알 수 없습니다.\n그래도 나가시겠습니까?',
              style: TextStyle(
                fontSize: 14,
                height: 20 / 14,
                letterSpacing: -0.5,
                color: kFontGray600Color,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                kDialogButton(
                  title: '닫기',
                  onTap: () => Navigator.pop(context, false),
                  backgroundColor: kDarkGray20Color,
                  titleColor: kDarkGray30Color,
                ),
                const SizedBox(width: 40),
                kDialogButton(
                  title: '나가기',
                  onTap: () => Navigator.pop(context, true),
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
          height: 32,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
