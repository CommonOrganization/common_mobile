import 'package:common/screens/daily_upload/daily_upload_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../constants/constants_colors.dart';
import '../../../constants/constants_value.dart';
import '../../gathering_upload/club_gathering_upload/club_gathering_upload_main_screen.dart';
import '../../gathering_upload/one_day_gathering_upload/one_day_gathering_upload_main_screen.dart';

class MainUploadBottomSheet extends StatelessWidget {
  const MainUploadBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(18),
        topRight: Radius.circular(18),
      ),
      child: Container(
        height: kBottomSheetHeight,
        color: kWhiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset(
                    'assets/icons/svg/close_26px.svg',
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                physics: const ClampingScrollPhysics(),
                children: [
                  kUploadButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const OneDayGatheringUploadMainScreen(),
                      ),
                    ),
                    image: 'assets/images/one_day_gathering.png',
                    title: '하루모임 만들기',
                    subtitle: '일회성 모임으로 번개처럼 가볍게 만나요',
                  ),
                  kUploadButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ClubGatheringUploadMainScreen(),
                      ),
                    ),
                    image: 'assets/images/club_gathering.png',
                    title: '소모임 만들기',
                    subtitle: '지속형 모임으로 계속해서 친하게 지내요',
                  ),
                  kUploadButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DailyUploadMainScreen(),
                      ),
                    ),
                    image: 'assets/images/daily.png',
                    title: '데일리 만들기',
                    subtitle: '오늘의 일상을 공유해 보세요',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget kUploadButton(
      {required Function onPressed,
      required String image,
      required String title,
      required String subtitle}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onPressed(),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(bottom: 28),
        width: double.infinity,
        height: 50,
        child: Row(
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Image.asset(image),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    height: 20 / 15,
                    color: kFontGray800Color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    height: 20 / 13,
                    color: kFontGray500Color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
