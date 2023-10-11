import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../constants/constants_colors.dart';

class EditSettingScreen extends StatelessWidget {
  const EditSettingScreen({Key? key}) : super(key: key);

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
          kSettingCard(
            title: '공지사항',
            onTap: () {},
          ),
          kSettingCard(
            title: '이벤트',
            onTap: () {},
          ),
          kSettingCard(
            title: '고객센터',
            onTap: () {},
          ),
          kSettingCard(
            title: '개선 및 의견 남기기',
            onTap: () {},
          ),
          Container(
            width: double.infinity,
            height: 5,
            color: kDarkGray20Color,
          ),
          kTitleText('계정'),
          kSettingCard(
            title: '계정 관리',
            onTap: () {},
          ),
          kSettingCard(
            title: '로그아웃',
            onTap: () {},
          ),
          Container(
            width: double.infinity,
            height: 5,
            color: kDarkGray20Color,
          ),
          kTitleText('정보'),
          kVersionArea(),
          kSettingCard(
            title: '서비스 이용 약관',
            onTap: () {},
          ),
          kSettingCard(
            title: '개인정보 처리방침',
            onTap: () {},
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

  Widget kSettingCard({required String title, required Function onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                height: 20 / 16,
                letterSpacing: -0.5,
                color: kFontGray800Color,
              ),
            ),
            const Spacer(),
            SvgPicture.asset('assets/icons/svg/arrow_more_22px.svg'),
          ],
        ),
      ),
    );
  }

  Widget kVersionArea() {
    return GestureDetector(
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: FutureBuilder(
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
          }),
    );
  }
}
