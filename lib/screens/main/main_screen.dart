import 'package:common/constants/constants_colors.dart';
import 'package:common/screens/gathering_upload/club_gathering_upload/club_gathering_upload_main_screen.dart';
import 'package:common/screens/gathering_upload/one_day_gathering_upload/one_day_gathering_upload_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/constants_value.dart';
import '../home/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  Widget getScreen() {
    switch (_currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
      case 2:
      case 3:
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: getScreen(),
      bottomNavigationBar: Container(
        color: kWhiteColor,
        child: SafeArea(
          child: Container(
            color: kWhiteColor,
            width: double.infinity,
            height: 60,
            child: Row(
              children: [
                kBottomNavigationBarItem(
                  activeImage: 'assets/icons/nav/nav_home_active.svg',
                  inactiveImage: 'assets/icons/nav/nav_home_inactive.svg',
                  index: 0,
                ),
                kBottomNavigationBarItem(
                  activeImage: 'assets/icons/nav/nav_chat_active.svg',
                  inactiveImage: 'assets/icons/nav/nav_chat_inactive.svg',
                  index: 1,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => ClipRRect(
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
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.center,
                                width: double.infinity,
                                child: Container(
                                  width: 60,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: kFontGray100Color,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 22),
                              Container(
                                width: double.infinity,
                                height: 1,
                                color: kFontGray50Color,
                              ),
                              Expanded(
                                child: ListView(
                                  children: [
                                    GestureDetector(
                                      onTap: () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const OneDayGatheringUploadMainScreen(),
                                        ),
                                      ),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        width: double.infinity,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: kFontGray50Color,
                                            ),
                                          ),
                                        ),
                                        child: const Text('새로운 하루모임 만들기'),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ClubGatheringUploadMainScreen(),
                                        ),
                                      ),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        width: double.infinity,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: kFontGray50Color,
                                            ),
                                          ),
                                        ),
                                        child: const Text('새로운 소모임 만들기'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    child: Container(
                      color: kWhiteColor,
                      child: SvgPicture.asset(
                        'assets/icons/nav/nav_plus.svg',
                      ),
                    ),
                  ),
                ),
                kBottomNavigationBarItem(
                  activeImage: 'assets/icons/nav/nav_feed_active.svg',
                  inactiveImage: 'assets/icons/nav/nav_feed_inactive.svg',
                  index: 2,
                ),
                kBottomNavigationBarItem(
                  activeImage: 'assets/icons/nav/nav_my_active.svg',
                  inactiveImage: 'assets/icons/nav/nav_my_inactive.svg',
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget kBottomNavigationBarItem(
      {required String activeImage,
      required String inactiveImage,
      required int index}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        child: Container(
          color: kWhiteColor,
          child: SvgPicture.asset(
            _currentIndex == index ? activeImage : inactiveImage,
          ),
        ),
      ),
    );
  }
}
