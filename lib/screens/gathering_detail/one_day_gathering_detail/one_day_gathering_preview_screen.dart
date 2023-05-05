import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/services/firebase_one_day_gathering_service.dart';
import 'package:common/utils/local_utils.dart';
import 'package:flutter/material.dart';
import '../../../constants/constants_colors.dart';
import '../components/gathering_button.dart';
import '../components/gathering_sliver_appbar.dart';
import 'one_day_gathering_basic_contents.dart';

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
                  physics: const ClampingScrollPhysics(),
                  children: [
                    OneDayGatheringBasicContents(gathering: widget.gathering)
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
