import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/screens/gathering_detail/club_gathering_detail/club_gathering_connected_gathering_contents.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants_colors.dart';
import '../../../controllers/user_controller.dart';
import '../../../models/one_day_gathering/one_day_gathering.dart';
import '../../../services/firebase_club_gathering_service.dart';
import '../../../services/firebase_one_day_gathering_service.dart';
import '../../../utils/local_utils.dart';
import '../components/gathering_button.dart';
import '../components/gathering_sliver_appbar.dart';
import 'club_gathering_basic_contents.dart';

class ClubGatheringDetailScreen extends StatefulWidget {
  final ClubGathering gathering;
  final bool isPreview;
  const ClubGatheringDetailScreen(
      {Key? key, required this.gathering, this.isPreview = false})
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

  List<OneDayGathering> _gatheringList = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(onUpdate);
    initializeGatheringList();
  }

  void onUpdate() async {
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

  void initializeGatheringList() async {
    List<OneDayGathering> gatheringList =
        await FirebaseOneDayGatheringService.getConnectedGathering(
            clubGatheringId: widget.gathering.id);
    setState(() => _gatheringList = gatheringList);
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

  Future<void> previewPressed() async {
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

  Widget getPage() {
    switch (_headerIndex) {
      case 0:
        return ClubGatheringBasicContents(
          gathering: widget.gathering,
        );
      case 1:
        return ClubGatheringConnectedGatheringContents(
          gatheringList: _gatheringList,
        );
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
      body: CustomScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        slivers: [
          GatheringSliverAppbar(
            showAppbarBlack: _showAppbarBlack,
            size: MediaQuery.of(context).size.width,
            gathering: widget.gathering,
            isClubGathering: true,
          ),
          SliverAppBar(
            primary: false,
            toolbarHeight: 48,
            pinned: true,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            elevation: 0,
            title: Container(
              height: 48,
              decoration: BoxDecoration(
                color: kWhiteColor,
                border: Border.symmetric(
                  horizontal: BorderSide(color: kFontGray50Color, width: 1),
                ),
              ),
              child: Row(
                children: [
                  kTabBarButton(title: '정보', index: 0),
                  kTabBarButton(title: '모임', index: 1),
                  kTabBarButton(title: '피드', index: 2),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: getPage()),
        ],
      ),
      bottomNavigationBar: widget.isPreview
          ? GatheringButton(
              title: '소모임 개설하기',
              onTap: () => previewPressed(),
            )
          : GatheringButton(
              title: '소모임 참여하기',
              onTap: () => applyPressed(),
            ),
    );
  }

  Widget kTabBarButton({required String title, required int index}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _headerIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: kWhiteColor,
            border: _headerIndex == index
                ? Border(
                    bottom: BorderSide(
                    color: kMainColor,
                    width: 2,
                  ))
                : null,
          ),
          child: Text(
            title,
            style: TextStyle(
              color:
                  _headerIndex == index ? kFontGray800Color : kFontGray200Color,
              fontSize: 14,
              height: 20 / 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
