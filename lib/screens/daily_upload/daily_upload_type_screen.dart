import 'package:common/constants/constants_enum.dart';
import 'package:common/controllers/user_controller.dart';
import 'package:common/screens/daily_upload/components/daily_upload_next_button.dart';
import 'package:common/services/club_gathering_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../constants/constants_colors.dart';
import '../../models/club_gathering/club_gathering.dart';
import '../../models/one_day_gathering/one_day_gathering.dart';
import '../../services/one_day_gathering_service.dart';

class DailyUploadTypeScreen extends StatefulWidget {
  final Function nextPressed;
  const DailyUploadTypeScreen({
    Key? key,
    required this.nextPressed,
  }) : super(key: key);

  @override
  State<DailyUploadTypeScreen> createState() => _DailyUploadTypeScreenState();
}

class _DailyUploadTypeScreenState extends State<DailyUploadTypeScreen> {

  List<ClubGathering> clubGatheringList = [];

  DailyType _selectedDailyType = DailyType.own;
  String? _connectedClubGatheringId;

  bool get canNextPress =>
      _selectedDailyType == DailyType.own ||
      (_selectedDailyType == DailyType.gathering &&
          _connectedClubGatheringId != null);

  @override
  void initState() {
    super.initState();
    initializeClubGatheringList();
  }

  void initializeClubGatheringList() async {
    if (context.read<UserController>().user == null) return;
    List<ClubGathering> gatheringList =
    await ClubGatheringService.getGatheringListWhichUserIsParticipating(
        userId: context.read<UserController>().user!.id);
    if (gatheringList.isNotEmpty) {
      setState(() => clubGatheringList = gatheringList);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '어떤 데일리인가요?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kFontGray900Color,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '\'나만의 데일리\'는 나만의 일상을 기록해요.\n멤버들과 함께한 일상은 \'모임 데일리\'를 선택해 주세요.',
                  style: TextStyle(
                    fontSize: 13,
                    color: kFontGray500Color,
                    height: 20 / 13,
                  ),
                ),
              ),
              const SizedBox(height: 36),
              kDailyTypeCard(DailyType.own),
              const SizedBox(height: 16),
              kDailyTypeCard(DailyType.gathering),
              const SizedBox(height: 24),
              if (_selectedDailyType == DailyType.gathering)
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: kFontGray50Color,
                    ),
                    Column(
                      children: clubGatheringList
                          .map((clubGathering) =>
                          kClubGatheringCard(clubGathering))
                          .toList(),
                    ),
                  ],
                )
            ],
          ),
        ),
        DailyUploadNextButton(
          value: canNextPress,
          onTap: () {
            if (!canNextPress) return;
            widget.nextPressed(_selectedDailyType,_connectedClubGatheringId);
          },
          title: '다음',
        ),
      ],
    );
  }

  Widget kDailyTypeCard(DailyType dailyType) {
    return GestureDetector(
      onTap: () {
        String? newConnectedClubGatheringId;
        if (dailyType == DailyType.own) {
          newConnectedClubGatheringId = null;
        }
        if (dailyType == DailyType.gathering) {
          newConnectedClubGatheringId =
          clubGatheringList.isNotEmpty ? clubGatheringList.first.id : null;
        }
        setState(() {
          _selectedDailyType = dailyType;
          _connectedClubGatheringId = newConnectedClubGatheringId;
        });

      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        height: 82,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color:
              _selectedDailyType == dailyType ? kMainColor : kFontGray50Color,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              _selectedDailyType == dailyType
                  ? dailyType.selectedIcon
                  : dailyType.unselectedIcon,
              width: 22,
              height: 22,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    dailyType.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _selectedDailyType == dailyType
                          ? kWhiteColor
                          : kFontGray600Color,
                      height: 20 / 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dailyType.content,
                    style: TextStyle(
                      fontSize: 13,
                      color: _selectedDailyType == dailyType
                          ? kWhiteColor
                          : kFontGray400Color,
                      height: 18 / 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget kClubGatheringCard(ClubGathering clubGathering) {
    return GestureDetector(
      onTap: () => setState(() => _connectedClubGatheringId = clubGathering.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
            color: kWhiteColor,
            border: Border(
                bottom: BorderSide(
              color: kFontGray50Color,
            ))),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kDarkGray20Color,
                image: DecorationImage(
                  image: NetworkImage(
                    clubGathering.mainImage,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clubGathering.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kFontGray600Color,
                      height: 20 / 14,
                      letterSpacing: -0.5,
                    ),
                  ),
                  FutureBuilder(
                    future: OneDayGatheringService.getConnectedGathering(
                        clubGatheringId: clubGathering.id),
                    builder: (context, snapshot) {
                      int gatheringCount = snapshot.hasData
                          ? (snapshot.data as List<OneDayGathering>).length
                          : 0;
                      return Text(
                        '$gatheringCount개의 하루모임 운영 중',
                        style: TextStyle(
                          fontSize: 12,
                          color: kFontGray400Color,
                          height: 20 / 12,
                          letterSpacing: -0.5,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(4),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _connectedClubGatheringId == clubGathering.id
                      ? kMainColor
                      : kFontGray200Color,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: 12,
                height: 12,
                decoration: _connectedClubGatheringId == clubGathering.id
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: kMainColor,
                      )
                    : null,
              ),
            )
          ],
        ),
      ),
    );
  }
}
