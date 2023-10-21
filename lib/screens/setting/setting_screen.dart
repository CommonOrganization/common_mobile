import 'package:common/constants/constants_enum.dart';
import 'package:common/controllers/user_controller.dart';
import 'package:common/screens/setting/account_manage_screen.dart';
import 'package:common/screens/setting/notice_screen.dart';
import 'package:common/screens/sign/login_screen.dart';
import 'package:common/utils/local_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/constants_colors.dart';
import '../../constants/constants_value.dart';
import 'components/setting_more_button.dart';
import 'customer_service_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

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
          '설정 및 개인정보',
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
      body: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          kTitleText('안내'),
          SettingMoreButton(
            title: '공지사항',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const NoticeScreen(type: NoticeType.notice),
              ),
            ),
          ),
          SettingMoreButton(
            title: '이벤트',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const NoticeScreen(type: NoticeType.event),
              ),
            ),
          ),
          SettingMoreButton(
            title: '고객센터',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CustomerServiceScreen(),
              ),
            ),
          ),
          SettingMoreButton(
            title: '개선 및 의견 남기기',
            onTap: () async {
              bool canLaunchOpinionUrl =
                  await canLaunchUrl(Uri.parse(kOpinionUrl));
              if (context.mounted) {
                if (!canLaunchOpinionUrl) {
                  showMessage(context, message: '잠시 후에 다시 시도해 주세요.');
                  return;
                }
                launchUrl(Uri.parse(kOpinionUrl));
              }
            },
          ),
          Container(
            width: double.infinity,
            height: 5,
            color: kDarkGray20Color,
          ),
          kTitleText('계정'),
          SettingMoreButton(
            title: '계정 관리',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AccountManageScreen(),
              ),
            ),
          ),
          SettingMoreButton(
            title: '로그아웃',
            onTap: () async {
              await context.read<UserController>().logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              }
            },
          ),
          Container(
            width: double.infinity,
            height: 5,
            color: kDarkGray20Color,
          ),
          kTitleText('정보'),
          kVersionArea(),
          SettingMoreButton(
            title: '서비스 이용 약관',
            onTap: () => launchServiceUsePolicy(),
          ),
          SettingMoreButton(
            title: '개인정보 처리방침',
            onTap: () => launchPersonalInformationProcessingPolicy(),
          ),
        ],
      ),
    );
  }

  Widget kTitleText(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          height: 20 / 14,
          letterSpacing: -0.5,
          color: kFontGray800Color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget kVersionArea() {
    return FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            PackageInfo? packageInfo = snapshot.data;
            if (packageInfo != null) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Text(
                      '현재 버전',
                      style: TextStyle(
                        fontSize: 16,
                        height: 20 / 16,
                        letterSpacing: -0.5,
                        color: kFontGray800Color,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${packageInfo.version} (${packageInfo.buildNumber})',
                      style: TextStyle(
                        fontSize: 14,
                        height: 20 / 14,
                        letterSpacing: -0.5,
                        color: kFontGray600Color,
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              '현재 버전',
              style: TextStyle(
                fontSize: 16,
                height: 20 / 16,
                letterSpacing: -0.5,
                color: kFontGray800Color,
              ),
            ),
          );
        });
  }
}
