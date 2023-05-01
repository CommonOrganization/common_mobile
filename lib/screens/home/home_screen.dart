import 'package:common/screens/home/components/gathering_header.dart';
import 'package:common/screens/home/club_gathering/home_club_gathering_screen.dart';
import 'package:common/screens/home/one_day_gathering/home_one_day_gathering_screen.dart';
import 'package:common/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/constants_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: kWhiteColor,
                automaticallyImplyLeading: false,
                centerTitle: false,
                titleSpacing: 20,
                floating: true,
                snap: true,
                forceElevated: innerBoxIsScrolled,
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
                    child: SvgPicture.asset('assets/icons/nav/search_26px.svg'),
                  ),
                  const SizedBox(width: 16),
                  SvgPicture.asset('assets/icons/nav/hamburger_26px.svg'),
                  const SizedBox(width: 16),
                  SvgPicture.asset('assets/icons/nav/alert_26px.svg'),
                  const SizedBox(width: 20),
                ],
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: GatheringHeader(
                    minExtent: 48,
                    maxExtent: 48,
                    onTap: (int index) => setState(() => _headerIndex = index),
                    currentIndex: _headerIndex),
              ),
            ];
          },
          body: (_headerIndex == 0
              ? const HomeOneDayGatheringScreen()
              : const HomeClubGatheringScreen()),
        ),
      ),
    );
  }
}
