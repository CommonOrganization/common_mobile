import 'package:common/models/gathering_place/gathering_place.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/screens/gathering_detail/components/gathering_content_card.dart';
import 'package:common/screens/gathering_detail/components/gathering_place_card.dart';
import 'package:common/services/firebase_gathering_service.dart';
import 'package:common/services/firebase_one_day_gathering_service.dart';
import 'package:common/services/firebase_user_service.dart';
import 'package:common/services/http_service.dart';
import 'package:common/utils/date_utils.dart';
import 'package:common/utils/format_utils.dart';
import 'package:common/utils/local_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/constants_colors.dart';
import '../../../constants/constants_value.dart';
import '../components/gathering_button.dart';
import '../components/gathering_information_card.dart';
import '../components/gathering_organizer_card.dart';
import '../components/gathering_sliver_appbar.dart';
import '../components/gathering_status_card.dart';

class OneDayGatheringPreviewScreen extends StatefulWidget {
  final OneDayGathering gathering;
  const OneDayGatheringPreviewScreen({
    Key? key,
    required this.gathering,
  }) : super(key: key);

  @override
  State<OneDayGatheringPreviewScreen> createState() =>
      _OneDayGatheringPreviewScreenState();
}

class _OneDayGatheringPreviewScreenState
    extends State<OneDayGatheringPreviewScreen> {
  final ScrollController _scrollController = ScrollController();

  bool _showAppbarBlack = false;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    addEventListener();
  }

  void addEventListener() {
    int size = 300;
    _scrollController.addListener(() {
      if (_scrollController.offset < size && _showAppbarBlack) {
        setState(() => _showAppbarBlack = false);
      }
      if (_scrollController.offset > size && !_showAppbarBlack) {
        setState(() => _showAppbarBlack = true);
      }
    });
  }

  Future<void> uploadPressed() async {
    if (_loading) return;
    _loading = true;
    try {
      bool uploadSuccess = await FirebaseOneDayGatheringService.uploadGathering(
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
            isClubGathering: false,
          ),
        ],
        body: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: kFontGray50Color,
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: _showAppbarBlack
                      ? const AlwaysScrollableScrollPhysics()
                      : const ClampingScrollPhysics(),
                  children: [
                    const SizedBox(height: 20),
                    GatheringOrganizerCard(
                        organizerId: widget.gathering.organizerId),
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
                      image: 'assets/icons/svg/calendar_gray.svg',
                      title: getDateDetail(widget.gathering.openingDate),
                    ),
                    const SizedBox(height: 16),
                    GatheringInformationCard(
                      image: 'assets/icons/svg/profile_gray.svg',
                      title: '${widget.gathering.capacity}명',
                    ),
                    if (widget.gathering.isHaveEntryFee)
                      Column(
                        children: [
                          const SizedBox(height: 16),
                          GatheringInformationCard(
                            image: 'assets/icons/svg/wallet_gray.svg',
                            title:
                                '${getMoneyFormat(widget.gathering.entryFee)}원',
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    GatheringPlaceCard(place: widget.gathering.place),
                    const SizedBox(height: 32),
                    GatheringStatusCard(
                      memberList: widget.gathering.memberList,
                      capacity: widget.gathering.capacity,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 6),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 14,
                            height: 14,
                            child: Text(
                              'ⓘ',
                              style: TextStyle(
                                fontSize: 11,
                                color: kFontGray400Color,
                                height: 16 / 11,
                              ),
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 11,
                                  color: kFontGray400Color,
                                  height: 16 / 11,
                                ),
                                children: const [
                                  TextSpan(text: '하루모임에 대해 궁금한 점이 있다면 '),
                                  TextSpan(
                                    text: '모임장과 채팅하기',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(text: '를 통해 물어보세요!'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GatheringButton(
                title: '하루모임 개설하기',
                onTap: () => uploadPressed(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
