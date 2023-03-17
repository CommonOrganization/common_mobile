import 'package:common/constants/constants_enum.dart';
import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/screens/gathering_detail/components/gathering_tab_bar.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants_colors.dart';
import '../../../utils/format_utils.dart';
import '../components/gathering_content_card.dart';
import '../components/gathering_information_card.dart';
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

  @override
  void dispose() {
    _scrollController.removeListener(onUpdate);
    _scrollController.dispose();
    super.dispose();
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
                      color: kWhiteF4F4F4Color,
                      width: 1,
                    ),
                  ),
                )
              : null,
          child: ListView(
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
                        height: 17/13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '우리랑 소모임 함께 해요',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kGrey2C2C2EColor,
                        height: 25/18,
                      ),
                    ),
                    SizedBox(height: 8),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
