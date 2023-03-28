import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/screens/gathering_detail/components/gathering_tab_bar.dart';
import 'package:flutter/material.dart';
import '../../../constants/constants_colors.dart';
import '../../../services/firebase_club_gathering_service.dart';
import '../../../utils/local_utils.dart';
import '../components/gathering_button.dart';
import '../components/gathering_sliver_appbar.dart';
import 'club_gathering_basic_contents.dart';

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
        return ClubGatheringBasicContents(gathering: widget.gathering);
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
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: _showAppbarBlack
                      ? const AlwaysScrollableScrollPhysics()
                      : const ClampingScrollPhysics(),
                  children: [getPage()],
                ),
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
}
