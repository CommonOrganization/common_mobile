import 'package:common/constants/constants_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../home/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: const HomeScreen(),
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
                  activeImage: 'assets/icons/svg/bottom_nav_home_clicked.svg',
                  inactiveImage: 'assets/icons/svg/bottom_nav_home.svg',
                  index: 0,
                ),
                kBottomNavigationBarItem(
                  activeImage: 'assets/icons/svg/bottom_nav_search_clicked.svg',
                  inactiveImage: 'assets/icons/svg/bottom_nav_search.svg',
                  index: 1,
                ),
                kBottomNavigationBarItem(
                  activeImage: 'assets/icons/svg/bottom_nav_chat_clicked.svg',
                  inactiveImage:'assets/icons/svg/bottom_nav_chat.svg',
                  index: 2,
                ),
                kBottomNavigationBarItem(
                  activeImage: 'assets/icons/svg/bottom_nav_community_clicked.svg',
                  inactiveImage: 'assets/icons/svg/bottom_nav_community.svg',
                  index: 3,
                ),
                kBottomNavigationBarItem(
                  activeImage: 'assets/icons/svg/bottom_nav_smile_clicked.svg',
                  inactiveImage: 'assets/icons/svg/bottom_nav_smile.svg',
                  index: 4,
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
