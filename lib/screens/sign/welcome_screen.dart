import 'package:common/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/constants_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 50),
            child: SvgPicture.asset(
              'assets/images/common_text_logo.svg',
              width: 292,
              fit: BoxFit.scaleDown,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '커먼에 오신 것을 환영합니다!',
            style: TextStyle(
              fontSize: 18,
              color: kSubColor3,
              height: 20/18,
            ),
          ),
          const SizedBox(height: 328),
          GestureDetector(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MainScreen(),
              ),
            ),
            child: Container(
              color: kMainColor,
              child: SafeArea(
                top: false,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    '시작하기',
                    style: TextStyle(
                      fontSize: 16,
                      color: kFontGray0Color,
                      fontWeight: FontWeight.bold,
                      height: 20/16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
