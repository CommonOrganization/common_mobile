import 'package:common/constants/constants_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../chat/chat_screen.dart';
import '../home/home_screen.dart';
import 'components/main_upload_bottom_sheet.dart';

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
        return const ChatScreen();
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
                      builder: (context) => const MainUploadBottomSheet(),
                    ).then((value) => setState(() {})),
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
