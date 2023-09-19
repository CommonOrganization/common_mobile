import 'package:common/screens/chat_upload/chat_upload_name_screen.dart';
import 'package:common/screens/chat_upload/chat_upload_user_select_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/constants_colors.dart';

class ChatUploadScreen extends StatefulWidget {
  const ChatUploadScreen({Key? key}) : super(key: key);

  @override
  State<ChatUploadScreen> createState() => _ChatUploadScreenState();
}

class _ChatUploadScreenState extends State<ChatUploadScreen> {
  int _stepIndex = 0;

  Widget getScreen() {
    switch (_stepIndex) {
      case 0:
        return const ChatUploadUserSelectScreen();
      case 1:
        return const ChatUploadNameScreen();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        foregroundColor: kFontGray800Color,
        backgroundColor: kWhiteColor,
        leadingWidth: 48,
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (_stepIndex == 0) {
              Navigator.pop(context);
              return;
            }
            setState(() => _stepIndex--);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/icons/svg/arrow_left_28px.svg'),
          ),
        ),
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset('assets/icons/svg/close_28px.svg'),
          ),
          const SizedBox(width: 20),
        ],
        elevation: 0,
      ),
      body: getScreen(),
    );
  }
}
