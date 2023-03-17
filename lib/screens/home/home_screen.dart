import 'package:common/screens/gathering_upload/club_gathering_upload/club_gathering_upload_main_screen.dart';
import 'package:common/screens/gathering_upload/one_day_gathering_upload/one_day_gathering_upload_main_screen.dart';
import 'package:common/screens/home/components/gathering_header.dart';
import 'package:common/screens/home/home_club_gathering_screen.dart';
import 'package:common/screens/home/home_one_day_gathering_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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

                  SvgPicture.asset(
                    'assets/icons/svg/search_26px.svg',
                  ),
                  SvgPicture.asset(
                    'assets/icons/svg/menu_26px.svg',
                  ),
                  const SizedBox(width: 18),
                  SvgPicture.asset(
                    'assets/icons/svg/notification_26px.svg',
                    width: 28,
                    height: 28,
                  ),
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
          body: _headerIndex == 0
              ? const HomeOneDayGatheringScreen()
              : const HomeClubGatheringScreen(),
        ),
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: kMainColor,
        activeBackgroundColor: kWhiteColor,
        activeForegroundColor: kMainColor,
        overlayOpacity: 0.7,
        overlayColor: kBlackColor,
        childMargin: const EdgeInsets.symmetric(horizontal: 0),
        spaceBetweenChildren: 6,
        children: [
          kSpeedDialChild(
            title: '소모임 등록하기',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ClubGatheringUploadMainScreen(),
              ),
            ),
          ),
          kSpeedDialChild(
            title: '하루모임 등록하기',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OneDayGatheringUploadMainScreen(),
              ),
            ),
          ),
        ],
        activeChild: SvgPicture.asset(
          'assets/icons/svg/close.svg',
        ),
        child: SvgPicture.asset(
          'assets/icons/svg/add.svg',
          width: 42,height: 42,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  SpeedDialChild kSpeedDialChild(
          {required String title, required Function onTap}) =>
      SpeedDialChild(
        onTap: () => onTap(),
        child: SvgPicture.asset(
          'assets/icons/svg/add.svg',
          width: 30,
          height: 30,
          fit: BoxFit.cover,
        ),
        backgroundColor: kMainColor,
        label: title,
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: kWhiteColor,
        ),
        labelBackgroundColor: Colors.transparent,
        labelShadow: [],
        elevation: 0,
      );
}
