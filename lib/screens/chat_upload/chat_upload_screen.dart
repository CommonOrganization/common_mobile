import 'dart:developer';

import 'package:common/screens/chat_upload/chat_upload_name_screen.dart';
import 'package:common/screens/chat_upload/chat_upload_user_select_screen.dart';
import 'package:common/services/personal_chat_service.dart';
import 'package:common/utils/local_utils.dart';
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
  late List _userIdList;

  Widget getScreen() {
    switch (_stepIndex) {
      case 0:
        return ChatUploadUserSelectScreen(
          onPressed: (List userIdList) async {
            try {
              if (userIdList.isEmpty || userIdList.length == 1) return;
              if (userIdList.length == 2) {
                String? chatId = await PersonalChatService()
                    .startChat(userIdList: userIdList);
                if (chatId == null) throw Exception('채팅방 생성하는데 에러가 발생했습니다.');
                if (!mounted) return;
                Navigator.pop(context, chatId);
                return;
              }
              setState(() {
                _userIdList = userIdList;
                _stepIndex++;
              });
            } catch (e) {
              log('채팅방 생성 에러 : $e');
              showMessage(context, message: '잠시 후 다시 시도해 주세요');
            }
          },
        );
      case 1:
        return ChatUploadNameScreen(
          onPressed: (String title) {},
          userIdList: _userIdList,
        );
      default:
        return Container();
    }
  }

  String get title => _stepIndex == 0 ? '대화상대 선택' : '그룹채팅방 정보 설정';

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
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            height: 28 / 18,
            letterSpacing: -0.5,
            fontWeight: FontWeight.bold,
            color: kFontGray800Color,
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
