import 'package:common/controllers/user_controller.dart';
import 'package:common/services/like_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../constants/constants_colors.dart';
import '../../models/club_gathering/club_gathering.dart';
import '../../models/daily/daily.dart';
import '../../models/one_day_gathering/one_day_gathering.dart';
import '../../services/club_gathering_service.dart';
import '../../services/daily_service.dart';
import '../../services/one_day_gathering_service.dart';
import '../../widgets/club_gathering_row_card.dart';
import '../../widgets/daily_card.dart';
import '../../widgets/one_day_gathering_row_card.dart';

class FavoriteContentsScreen extends StatefulWidget {
  const FavoriteContentsScreen({super.key});

  @override
  State<FavoriteContentsScreen> createState() => _FavoriteContentsScreenState();
}

class _FavoriteContentsScreenState extends State<FavoriteContentsScreen> {
  int _index = 0;

  Widget getContents({required List objectIdList, required String userId}) {
    switch (_index) {
      case 0:
        return kOneDayGatheringContents(
            objectIdList: objectIdList, userId: userId);
      case 1:
        return kClubGatheringContents(
            objectIdList: objectIdList, userId: userId);
      case 2:
        return kDailyContents(objectIdList: objectIdList);
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
        leadingWidth: 48,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/icons/svg/arrow_left_28px.svg'),
          ),
        ),
        centerTitle: true,
        titleSpacing: 0,
        title: Text(
          '좋아요 표시한 콘텐츠',
          style: TextStyle(
            fontSize: 18,
            height: 28 / 18,
            letterSpacing: -0.5,
            color: kFontGray800Color,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Row(
            children: [
              kTabContainer(index: 0, title: '하루모임'),
              kTabContainer(index: 1, title: '소모임'),
              kTabContainer(index: 2, title: '데일리'),
            ],
          ),
          Consumer<UserController>(builder: (context, controller, child) {
            if (controller.user == null) return Container();
            return Expanded(
              child: FutureBuilder(
                future:
                    LikeService.getLikeObjectList(userId: controller.user!.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List? objectIdList = snapshot.data;
                    if (objectIdList == null) return Container();
                    return getContents(
                      objectIdList: objectIdList,
                      userId: controller.user!.id,
                    );
                  }
                  return Container();
                },
              ),
            );
          }),
        ],
      ),
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

  Widget kOneDayGatheringContents(
      {required List objectIdList, required String userId}) {
    return FutureBuilder(
      future: OneDayGatheringService.getLikeGatheringWithObjectList(
          objectIdList: objectIdList),
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
                      userId: userId,
                    ))
                .toList(),
          );
        }
        return Container();
      },
    );
  }

  Widget kClubGatheringContents(
      {required List objectIdList, required String userId}) {
    return FutureBuilder(
      future: ClubGatheringService.getLikeGatheringWithObjectList(
          objectIdList: objectIdList),
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
                      userId: userId,
                    ))
                .toList(),
          );
        }
        return Container();
      },
    );
  }

  Widget kDailyContents({required List objectIdList}) {
    return FutureBuilder(
        future: DailyService.getLikeGatheringWithObjectList(
            objectIdList: objectIdList),
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
