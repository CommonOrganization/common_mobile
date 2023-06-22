import 'package:common/constants/constants_colors.dart';
import 'package:common/constants/constants_enum.dart';
import 'package:common/controllers/user_controller.dart';
import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/screens/gathering_upload/components/gathering_upload_next_button.dart';
import 'package:common/services/firebase_club_gathering_service.dart';
import 'package:common/services/firebase_one_day_gathering_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class OneDayGatheringTypeScreen extends StatefulWidget {
  final Function nextPressed;
  const OneDayGatheringTypeScreen({Key? key, required this.nextPressed})
      : super(key: key);

  @override
  State<OneDayGatheringTypeScreen> createState() =>
      _OneDayGatheringTypeScreenState();
}

class _OneDayGatheringTypeScreenState extends State<OneDayGatheringTypeScreen> {
  GatheringType _selectedGatheringType = GatheringType.oneDay;
  String? _connectedClubGatheringId = '';
  bool _showAllThePeople = true;

  List<ClubGathering> clubGatheringList = [];

  bool get canNextPress =>
      _selectedGatheringType == GatheringType.oneDay ||
      (_selectedGatheringType == GatheringType.clubOneDay &&
          _connectedClubGatheringId != null);

  @override
  void initState() {
    super.initState();
    initializeClubGatheringList();
  }

  void initializeClubGatheringList() async {
    if (context.read<UserController>().user == null) return;
    List<ClubGathering> gatheringList = await FirebaseClubGatheringService
        .getGatheringListWhichUserIsParticipating(
            userId: context.read<UserController>().user!.id);
    if (gatheringList.isNotEmpty) {
      setState(() {
        _connectedClubGatheringId = gatheringList.first.id;
        clubGatheringList = gatheringList;
      });
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
                  '어떤 하루모임을 열어볼까요?',
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
                  '\'하루모임\'은 원데이로 만나 활동을 하는 모임이에요.\n장기간 함께 활동하는 모임을 원하실 경우 \'소모임\'으로 열어주세요!',
                  style: TextStyle(
                    fontSize: 13,
                    color: kFontGray500Color,
                    height: 20 / 13,
                  ),
                ),
              ),
              const SizedBox(height: 36),
              kGatheringTypeCard(GatheringType.oneDay),
              const SizedBox(height: 16),
              kGatheringTypeCard(GatheringType.clubOneDay),
              const SizedBox(height: 24),
              if (_selectedGatheringType == GatheringType.clubOneDay)
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            '전체 공개 여부',
                            style: TextStyle(
                              fontSize: 15,
                              color: kFontGray800Color,
                              fontWeight: FontWeight.bold,
                              height: 20 / 15,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 38,
                            height: 20,
                            child: Switch(
                              value: _showAllThePeople,
                              thumbColor:
                                  MaterialStateProperty.all(kWhiteColor),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              activeTrackColor: kMainColor,
                              inactiveTrackColor: kFontGray200Color,
                              onChanged: (value) =>
                                  setState(() => _showAllThePeople = value),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        '설정 시 모든 사람들이 하루모임에 참여할 수 있어요.\n설정하지 않으면 선택한 클럽 멤버들만 하루모임에 참여할 수 있어요.',
                        style: TextStyle(
                          fontSize: 11,
                          color: kFontGray500Color,
                          height: 16 / 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
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
                ),
            ],
          ),
        ),
        GatheringUploadNextButton(
          value: canNextPress,
          onTap: () {
            if(!canNextPress) return;
            widget.nextPressed(
              _selectedGatheringType,
              _connectedClubGatheringId,
              _showAllThePeople,
            );
          },
          title: '다음',
        ),
      ],
    );
  }

  Widget kGatheringTypeCard(GatheringType gatheringType) {
    return GestureDetector(
      onTap: () {
        String? newConnectedClubGatheringId;
        if (gatheringType == GatheringType.oneDay) {
          newConnectedClubGatheringId = null;
        }
        if (gatheringType == GatheringType.clubOneDay) {
          newConnectedClubGatheringId =
              clubGatheringList.isNotEmpty ? clubGatheringList.first.id : null;
        }
        setState(() {
          _selectedGatheringType = gatheringType;
          _showAllThePeople = true;
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
          color: _selectedGatheringType == gatheringType
              ? kMainColor
              : kFontGray50Color,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              _selectedGatheringType == gatheringType
                  ? gatheringType.selectedIcon
                  : gatheringType.unselectedIcon,
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
                    gatheringType.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _selectedGatheringType == gatheringType
                          ? kWhiteColor
                          : kFontGray600Color,
                      height: 20 / 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    gatheringType.content,
                    style: TextStyle(
                      fontSize: 13,
                      color: _selectedGatheringType == gatheringType
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
                    future:
                        FirebaseOneDayGatheringService.getConnectedGathering(
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
