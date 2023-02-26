import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/screens/gathering_detail/components/gathering_tab_bar.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants_colors.dart';
import '../components/gathering_sliver_appbar.dart';

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
              gathering: widget.gathering),
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
            ],
          ),
        ),
      ),
    );
  }
}
