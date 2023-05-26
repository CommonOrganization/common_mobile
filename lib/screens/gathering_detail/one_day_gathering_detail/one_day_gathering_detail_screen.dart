import 'package:common/controllers/user_controller.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/services/firebase_one_day_gathering_service.dart';
import 'package:common/utils/local_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants_colors.dart';
import '../components/gathering_button.dart';
import '../components/gathering_sliver_appbar.dart';
import 'one_day_gathering_basic_contents.dart';

class OneDayGatheringDetailScreen extends StatefulWidget {
  final OneDayGathering gathering;
  final bool isPreview;
  const OneDayGatheringDetailScreen({
    Key? key,
    required this.gathering,
    this.isPreview = false,
  }) : super(key: key);

  @override
  State<OneDayGatheringDetailScreen> createState() =>
      _OneDayGatheringDetailScreenState();
}

class _OneDayGatheringDetailScreenState
    extends State<OneDayGatheringDetailScreen> {
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

  Future<void> applyPressed() async {
    String? userId = context.read<UserController>().user?.id;
    if (userId == null) return;
    if (_loading) return;
    _loading = true;
    try {
      bool applySuccess = await FirebaseOneDayGatheringService.applyGathering(
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
                  physics: const ClampingScrollPhysics(),
                  children: [
                    OneDayGatheringBasicContents(gathering: widget.gathering),
                  ],
                ),
              ),
              if (widget.isPreview)
                GatheringButton(
                  title: '하루모임 개설하기',
                  onTap: () => previewPressed(),
                )
              else
                GatheringButton(
                  title: '하루모임 참여하기',
                  onTap: () => applyPressed(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
