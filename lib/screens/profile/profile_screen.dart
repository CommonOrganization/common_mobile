import 'package:common/controllers/screen_controller.dart';
import 'package:common/controllers/user_controller.dart';
import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/screens/profile/profile_edit_screen.dart';
import 'package:common/services/club_gathering_service.dart';
import 'package:common/services/one_day_gathering_service.dart';
import 'package:common/services/user_service.dart';
import 'package:common/widgets/bottom_sheets/profile_edit_bottom_sheet.dart';
import 'package:common/widgets/club_gathering_row_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../constants/constants_colors.dart';
import '../../models/daily/daily.dart';
import '../../models/gathering/gathering.dart';
import '../../models/user/user.dart';
import '../../services/daily_service.dart';
import '../../widgets/daily_card.dart';
import '../../widgets/one_day_gathering_row_card.dart';

class ProfileScreen extends StatefulWidget {
  final bool isMyProfile;
  final String userId;
  const ProfileScreen({
    Key? key,
    required this.userId,
    this.isMyProfile = false,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _index = 0;

  Widget getContents() {
    switch (_index) {
      case 0:
        return kOneDayGatheringContents();
      case 1:
        return kClubGatheringContents();
      case 2:
        return kDailyContents();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        foregroundColor: kFontGray800Color,
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => const ProfileEditBottomSheet(),
              );
            },
            child: SvgPicture.asset(
              'assets/icons/svg/menu_26px.svg',
            ),
          ),
          const SizedBox(width: 20),
        ],
        elevation: 0,
      ),
      body: Consumer<ScreenController>(builder: (context, controller, child) {
        return FutureBuilder(
            future: UserService.getUser(id: widget.userId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                User? user = snapshot.data;
                if (user == null) return Container();
                return SafeArea(
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            const SizedBox(width: 20),
                            SizedBox(
                              width: 90,
                              height: 84,
                              child: Stack(
                                children: [
                                  Container(
                                    width: 84,
                                    height: 84,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(84),
                                      color: kDarkGray20Color,
                                      image: DecorationImage(
                                        image: NetworkImage(user.profileImage),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ProfileEditScreen()),
                                      ),
                                      behavior: HitTestBehavior.opaque,
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: kWhiteColor,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: const Offset(0, 2),
                                              blurRadius: 5,
                                              color: kBlurColor,
                                            )
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.edit,
                                          color: kFontGray400Color,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 20 / 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Builder(builder: (context) {
                              String? userId =
                                  context.read<UserController>().user?.id;
                              if (userId == widget.userId) {
                                return Container(height: 42);
                              }
                              return Container(
                                height: 42,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 11),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  color: kSubColor1,
                                ),
                                child: Text(
                                  '채팅하기',
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 20 / 14,
                                    color: kMainColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          user.information,
                          style: TextStyle(
                            fontSize: 12,
                            height: 16 / 12,
                            color: kFontGray400Color,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          kTabContainer(index: 0, title: '하루모임'),
                          kTabContainer(index: 1, title: '소모임'),
                          kTabContainer(index: 2, title: '데일리'),
                        ],
                      ),
                      getContents(),
                    ],
                  ),
                );
              }
              return Container();
            });
      }),
    );
  }

  Widget kTabContainer({required int index, required String title}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _index = index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.center,
          height: 48,
          decoration: BoxDecoration(
            border: Border(
              bottom: _index == index
                  ? BorderSide(
                      color: kMainColor,
                      width: 2,
                    )
                  : BorderSide(
                      color: kFontGray50Color,
                      width: 1,
                    ),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              height: 20 / 14,
              color: _index == index ? kFontGray800Color : kFontGray200Color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget kOneDayGatheringContents() {
    return FutureBuilder(
      future:
          OneDayGatheringService.getAllGatheringListWhichUserIsParticipating(
              userId: widget.userId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<OneDayGathering>? gatheringList = snapshot.data;
          if (gatheringList == null || gatheringList.isEmpty) {
            return Container();
          }
          return ListView(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 10),
            children: gatheringList
                .map((gathering) => OneDayGatheringRowCard(
                      gathering: gathering,
                      userId: widget.userId,
                    ))
                .toList(),
          );
        }
        return Container();
      },
    );
  }

  Widget kClubGatheringContents() {
    return FutureBuilder(
      future: ClubGatheringService.getGatheringListWhichUserIsParticipating(
          userId: widget.userId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ClubGathering>? gatheringList = snapshot.data;
          if (gatheringList == null || gatheringList.isEmpty) {
            return Container();
          }
          return ListView(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 10),
            children: gatheringList
                .map((gathering) => ClubGatheringRowCard(
                      gathering: gathering,
                      userId: widget.userId,
                    ))
                .toList(),
          );
        }
        return Container();
      },
    );
  }

  Widget kDailyContents() {
    return FutureBuilder(
        future: DailyService.getUserDaily(userId: widget.userId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Daily>? dailyList = snapshot.data;
            if (dailyList == null || dailyList.isEmpty) return Container();
            return GridView.count(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 3,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children:
                  dailyList.map((daily) => DailyCard(daily: daily)).toList(),
            );
          }
          return Container();
        });
  }
}
