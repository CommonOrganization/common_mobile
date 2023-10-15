import 'package:common/constants/constants_value.dart';
import 'package:common/widgets/common_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/constants_colors.dart';
import '../../utils/local_utils.dart';

class CustomerServiceScreen extends StatelessWidget {
  const CustomerServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        foregroundColor: kFontGray800Color,
        backgroundColor: kWhiteColor,
        leadingWidth: 48,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/icons/svg/arrow_left_28px.svg'),
          ),
        ),
        centerTitle: true,
        titleSpacing: 0,
        title: Text(
          '고객센터',
          style: TextStyle(
            fontSize: 18,
            height: 28 / 18,
            letterSpacing: -0.5,
            color: kFontGray800Color,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '궁금하거나 불편한 점이 있으신가요?\n문의사항에 대해 친절히 답변해 드릴게요.',
              style: TextStyle(
                fontSize: 16,
                height: 20 / 16,
                letterSpacing: -0.5,
                color: kFontGray800Color,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '고객센터 운영시간\n월~일 09:00 ~ 18:00',
              style: TextStyle(
                fontSize: 12,
                height: 16 / 12,
                letterSpacing: -0.5,
                color: kFontGray600Color,
              ),
            ),
          ),
          const SizedBox(height: 30),
          CommonActionButton(
            value: true,
            onTap: () async {
              bool canLaunchKakaoChatUrl =
                  await canLaunchUrl(Uri.parse(kKakaoChannelChatUrl));
              bool canLaunchKakaoUrl =
                  await canLaunchUrl(Uri.parse(kKakaoChannelUrl));
              if (context.mounted) {
                if (canLaunchKakaoChatUrl) {
                  launchUrl(Uri.parse(kKakaoChannelChatUrl));
                  return;
                }
                if (canLaunchKakaoUrl) {
                  launchUrl(Uri.parse(kKakaoChannelUrl));
                  return;
                }
                showMessage(context, message: '잠시 후에 다시 시도해 주세요.');
              }
            },
            title: '문의하기',
          ),
        ],
      ),
    );
  }
}
