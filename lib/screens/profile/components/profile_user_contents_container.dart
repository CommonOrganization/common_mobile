import 'package:common/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants_colors.dart';
import '../../../models/club_gathering/club_gathering.dart';
import '../../../models/daily/daily.dart';
import '../../../models/one_day_gathering/one_day_gathering.dart';
import '../../../services/club_gathering_service.dart';
import '../../../services/daily_service.dart';
import '../../../services/one_day_gathering_service.dart';
import '../../../widgets/club_gathering_row_card.dart';
import '../../../widgets/daily_card.dart';
import '../../../widgets/one_day_gathering_row_card.dart';

class ProfileUserContentsContainer extends StatefulWidget {
  final String userId;

  const ProfileUserContentsContainer({Key? key, required this.userId})
      : super(key: key);

  @override
  State<ProfileUserContentsContainer> createState() =>
      _ProfileUserContentsContainerState();
}

class _ProfileUserContentsContainerState
    extends State<ProfileUserContentsContainer> {
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
    return ListView(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [
        Row(
          children: [
            kTabContainer(index: 0, title: '하루모임'),
            kTabContainer(index: 1, title: '소모임'),
            kTabContainer(index: 2, title: '데일리'),
          ],
        ),
        getContents(),
      ],
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
    return Consumer<UserController>(builder: (context, controller, child) {
      if (controller.user == null) return Container();
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
    });
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
              children:
                  dailyList.map((daily) => DailyCard(daily: daily)).toList(),
            );
          }
          return Container();
        });
  }
}
