import 'package:common/constants/constants_enum.dart';
import 'package:common/screens/home/club_gathering/home_club_gathering_screen.dart';
import 'package:common/screens/home/one_day_gathering/home_one_day_gathering_screen.dart';
import 'package:common/screens/search/category_search_screen.dart';
import 'package:common/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/constants_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _headerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) => [
            SliverAppBar(
              backgroundColor: kWhiteColor,
              automaticallyImplyLeading: false,
              centerTitle: false,
              titleSpacing: 20,
              floating: true,
              elevation: 0,
              title: SvgPicture.asset(
                'assets/images/common_text_logo.svg',
                height: 18,
                fit: BoxFit.cover,
              ),
              actions: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  ),
                  child: SvgPicture.asset('assets/icons/svg/search_26px.svg'),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategorySearchScreen(
                          category: CommonCategory.all),
                    ),
                  ),
                  child: SvgPicture.asset('assets/icons/svg/menu_26px.svg'),
                ),
                // const SizedBox(width: 16),
                // SvgPicture.asset('assets/icons/svg/notification_26px.svg'),
                const SizedBox(width: 20),
              ],
            ),
            SliverAppBar(
              primary: false,
              toolbarHeight: 48,
              pinned: true,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              elevation: 0,
              title: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  border: Border(
                    bottom: BorderSide(color: kFontGray50Color, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    kTabBarButton(title: '하루모임', index: 0),
                    kTabBarButton(title: '소모임', index: 1),
                  ],
                ),
              ),
            ),
          ],
          body: (_headerIndex == 0
              ? const HomeOneDayGatheringScreen()
              : const HomeClubGatheringScreen()),
        ),
      ),
    );
  }

  Widget kTabBarButton({required String title, required int index}) {
    return GestureDetector(
      onTap: () => setState(() => _headerIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: kWhiteColor,
          border: _headerIndex == index
              ? Border(bottom: BorderSide(color: kMainColor, width: 2))
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color:
                _headerIndex == index ? kFontGray800Color : kFontGray200Color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
