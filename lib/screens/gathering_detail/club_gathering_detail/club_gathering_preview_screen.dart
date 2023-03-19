import 'package:common/constants/constants_enum.dart';
import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/screens/gathering_detail/components/gathering_tab_bar.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants_colors.dart';
import '../../../services/firebase_club_gathering_service.dart';
import '../../../utils/format_utils.dart';
import '../../../utils/local_utils.dart';
import '../components/gathering_button.dart';
import '../components/gathering_content_card.dart';
import '../components/gathering_information_card.dart';
import '../components/gathering_member_card.dart';
import '../components/gathering_organizer_card.dart';
import '../components/gathering_sliver_appbar.dart';
import '../components/gathering_status_card.dart';

class ClubGatheringPreviewScreen extends StatefulWidget {
  final ClubGathering gathering;
  const ClubGatheringPreviewScreen({Key? key, required this.gathering})
      : super(key: key);

  @override
  State<ClubGatheringPreviewScreen> createState() =>
      _ClubGatheringPreviewScreenState();
}

class _ClubGatheringPreviewScreenState
    extends State<ClubGatheringPreviewScreen> {
  final ScrollController _scrollController = ScrollController();

  bool _showAppbarBlack = false;
  int _headerIndex = 0;

  final int _size = 300;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(onUpdate);
  }

  void onUpdate() {
    if (_scrollController.offset < _size && _showAppbarBlack) {
      setState(() => _showAppbarBlack = false);
    }
    if (_scrollController.offset > _size && !_showAppbarBlack) {
      setState(() => _showAppbarBlack = true);
    }
  }

  Future<void> uploadPressed() async {
    if (_loading) return;
    _loading = true;
    try {
      bool uploadSuccess = await FirebaseClubGatheringService.uploadGathering(
          gathering: widget.gathering);
      if (!mounted) return;
      if (uploadSuccess) {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } catch (e) {
      showMessage(context, message: '잠시후에 다시 개설해 주세요.');
      _loading = false;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(onUpdate);
    _scrollController.dispose();
    super.dispose();
  }

  Widget getPage() {
    switch (_headerIndex) {
      case 0:
        return informationArea();
      case 1:
      case 2:
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kWhiteColor,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          GatheringSliverAppbar(
            showAppbarBlack: _showAppbarBlack,
            size: MediaQuery.of(context).size.width,
            gathering: widget.gathering,
            isClubGathering: true,
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: GatheringTabBar(
                minExtent: 48,
                maxExtent: 48,
                onTap: (int index) => setState(() => _headerIndex = index),
                currentIndex: _headerIndex),
          ),
        ],
        body: Container(
          decoration: _showAppbarBlack
              ? BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: kFontGray50Color,
                      width: 1,
                    ),
                  ),
                )
              : null,
          child: Column(
            children: [
              Expanded(
                child: getPage(),
              ),
              GatheringButton(
                title: '소모임 개설하기',
                onTap: () => uploadPressed(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget informationArea() => ListView(
        padding: EdgeInsets.zero,
        physics: _showAppbarBlack
            ? const AlwaysScrollableScrollPhysics()
            : const ClampingScrollPhysics(),
        children: [
          const SizedBox(height: 16),
          GatheringOrganizerCard(organizerId: widget.gathering.organizerId),
          const SizedBox(height: 12),
          GatheringContentCard(content: widget.gathering.content),
          const SizedBox(height: 20),
          GatheringInformationCard(
            image: widget.gathering.recruitWay == 'firstCome'
                ? 'assets/icons/svg/clock_gray.svg'
                : 'assets/icons/svg/inbox_gray.svg',
            title: widget.gathering.recruitWay == 'firstCome'
                ? '선착순 하루모임'
                : '승인제 하루모임',
          ),
          const SizedBox(height: 16),
          GatheringInformationCard(
            image: 'assets/icons/svg/profile_gray.svg',
            title: '${widget.gathering.capacity}명',
          ),
          const SizedBox(height: 16),
          GatheringInformationCard(
            image: 'assets/icons/svg/profile_gray.svg',
            title: getCityNamesString(widget.gathering.cityList),
          ),
          const SizedBox(height: 32),
          GatheringStatusCard(
            memberList: widget.gathering.memberList,
            capacity: widget.gathering.capacity,
          ),
          const SizedBox(height: 30),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '멤버소개',
                  style: TextStyle(
                    fontSize: 13,
                    color: kMainColor,
                    height: 17 / 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '우리랑 소모임 함께 해요',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kFontGray800Color,
                    height: 25 / 18,
                  ),
                ),
                const SizedBox(height: 8),
                ...widget.gathering.memberList
                    .map(
                      (memberId) => GatheringMemberCard(
                        memberId: memberId,
                        isOrganizer: memberId == widget.gathering.organizerId,
                      ),
                    )
                    .toList(),
              ],
            ),
          )
        ],
      );
}
