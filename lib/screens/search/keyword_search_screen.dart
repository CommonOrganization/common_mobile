import 'package:common/controllers/user_controller.dart';
import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/services/firebase_club_gathering_service.dart';
import 'package:common/services/firebase_one_day_gathering_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../constants/constants_colors.dart';
import '../../widgets/club_gathering_row_card.dart';
import '../../widgets/one_day_gathering_row_card.dart';

class KeywordSearchScreen extends StatefulWidget {
  final String keyword;
  const KeywordSearchScreen({Key? key, required this.keyword})
      : super(key: key);

  @override
  State<KeywordSearchScreen> createState() => _KeywordSearchScreenState();
}

class _KeywordSearchScreenState extends State<KeywordSearchScreen> {
  final TextEditingController _searchWordController = TextEditingController();

  late String _searchWord;
  int _categoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _searchWord = widget.keyword;
    _searchWordController.text = widget.keyword;
  }

  Widget _getScreen() {
    switch (_categoryIndex) {
      case 0:
        return kOneDayGatheringArea();
      case 1:
        return kClubGatheringArea();
      //TODO 피드 개발시 넣기
      case 2:
        return Container();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        foregroundColor: kFontGray800Color,
        backgroundColor: kWhiteColor,
        leadingWidth: 48,
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/icons/svg/arrow_left_28px.svg'),
          ),
        ),
        centerTitle: true,
        titleSpacing: 0,
        title: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(left: 12, right: 20),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: kDarkGray20Color,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/svg/search_20px.svg',
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _searchWordController,
                  style: TextStyle(
                    fontSize: 14,
                    color: kFontGray600Color,
                    height: 24 / 14,
                    letterSpacing: -0.5,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    counterText: '',
                    hintText: '지역, 모임명, 키워드를 입력하세요.',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: kFontGray600Color,
                      height: 24 / 14,
                      letterSpacing: -0.5,
                    ),
                  ),
                  onSubmitted: (text) => setState(() => _searchWord = text),
                ),
              ),
              const SizedBox(width: 10),
              SvgPicture.asset('assets/icons/svg/delete_20px.svg'),
            ],
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Row(
            children: [
              kTabContainer(index: 0, title: '하루모임'),
              kTabContainer(index: 1, title: '소모임'),
              kTabContainer(index: 2, title: '피드'),
            ],
          ),
          _getScreen(),
        ],
      ),
    );
  }

  Widget kOneDayGatheringArea() {
    return FutureBuilder(
      future: FirebaseOneDayGatheringService.searchGatheringWithKeyword(
          keyword: _searchWord),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<OneDayGathering> gatheringList =
              snapshot.data as List<OneDayGathering>;

          String userId = context.read<UserController>().user!.id;
          return Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 30),
              physics: const ClampingScrollPhysics(),
              children: gatheringList
                  .map((gathering) => OneDayGatheringRowCard(
                        gathering: gathering,
                        userId: userId,
                      ))
                  .toList(),
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget kClubGatheringArea() {
    return FutureBuilder(
      future: FirebaseClubGatheringService.searchGatheringWithKeyword(
          keyword: _searchWord),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ClubGathering> gatheringList =
          snapshot.data as List<ClubGathering>;

          String userId = context.read<UserController>().user!.id;
          return Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 30),
              physics: const ClampingScrollPhysics(),
              children: gatheringList
                  .map((gathering) => ClubGatheringRowCard(
                gathering: gathering,
                userId: userId,
              ))
                  .toList(),
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget kTabContainer({required int index, required String title}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _categoryIndex = index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.center,
          height: 48,
          decoration: BoxDecoration(
            border: Border(
              bottom: _categoryIndex == index
                  ? BorderSide(
                      color: kMainColor,
                      width: 2,
                    )
                  : BorderSide(
                      color: kFontGray50Color,
                      width: 1,
                    ),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 14,
                height: 20 / 14,
                color: _categoryIndex == index
                    ? kFontGray800Color
                    : kFontGray200Color,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
