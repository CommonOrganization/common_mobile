import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/screens/gathering_detail/club_gathering_detail/club_gathering_connected_gathering_contents.dart';
import 'package:common/screens/gathering_detail/components/gathering_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants_colors.dart';
import '../../../controllers/user_controller.dart';
import '../../../services/firebase_club_gathering_service.dart';
import '../../../utils/local_utils.dart';
import '../components/gathering_button.dart';
import '../components/gathering_sliver_appbar.dart';
import 'club_gathering_basic_contents.dart';

class ClubGatheringDetailScreen extends StatefulWidget {
  final ClubGathering gathering;
  const ClubGatheringDetailScreen({Key? key, required this.gathering})
      : super(key: key);

  @override
  State<ClubGatheringDetailScreen> createState() =>
      _ClubGatheringDetailScreenState();
}

class _ClubGatheringDetailScreenState extends State<ClubGatheringDetailScreen> {
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

  Future<void> applyPressed() async {
    String? userId = context.read<UserController>().user?.id;
    if (userId == null) return;
    if (_loading) return;
    _loading = true;
    try {
      bool applySuccess = await FirebaseClubGatheringService.applyGathering(
          id: widget.gathering.id, userId: userId);
      if (!mounted) return;
      if (!applySuccess) {
        showMessage(context, message: '이미 신청중인 모임입니다.');
        return;
      }
      Navigator.pop(context);
    } catch (e) {
      showMessage(context, message: '잠시후에 다시 신청해 주세요.');
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
        return ClubGatheringBasicContents(gathering: widget.gathering);
      case 1:
        return ClubGatheringConnectedGatheringContents(gatheringId: widget.gathering.id);
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
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: _showAppbarBlack
                      ? const AlwaysScrollableScrollPhysics()
                      : const ClampingScrollPhysics(),
                  children: [getPage()],
                ),
              ),
              GatheringButton(
                title: '소모임 참여하기',
                onTap: () => applyPressed(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
