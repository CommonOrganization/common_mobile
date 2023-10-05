import 'package:common/controllers/user_controller.dart';
import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/models/daily/daily.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/services/daily_service.dart';
import 'package:common/widgets/daily_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../constants/constants_colors.dart';
import '../../services/club_gathering_service.dart';
import '../../services/one_day_gathering_service.dart';
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

  Widget _getScreen(String city) {
    switch (_categoryIndex) {
      case 0:
        return kOneDayGatheringArea(city);
      case 1:
        return kClubGatheringArea(city);
      case 2:
        return kDailyArea();
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
                    hintText: '제목, 내용, 키워드를 입력하세요.',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: kFontGray400Color,
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
              kTabContainer(index: 2, title: '데일리'),
            ],
          ),
          Consumer<UserController>(builder: (context, controller, child) {
            if (controller.user == null) return Container();
            String userCity = controller.user!.userPlace['city'];
            return _getScreen(userCity);
          }),
        ],
      ),
    );
  }

  Widget kOneDayGatheringArea(String city) {
    return FutureBuilder(
      future: OneDayGatheringService.searchGatheringWithKeyword(
        keyword: _searchWord,
        city: city,
      ),
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

  Widget kClubGatheringArea(String city) {
    return FutureBuilder(
      future: ClubGatheringService.searchGatheringWithKeyword(
        keyword: _searchWord,
        city: city,
      ),
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

  Widget kDailyArea() {
    return FutureBuilder(
      future: DailyService.searchDailyWithKeyword(
        keyword: _searchWord,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Daily>? dailyList = snapshot.data;
          if (dailyList == null) return Container();
          return Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              physics: const ClampingScrollPhysics(),
              children:
                  dailyList.map((daily) => DailyCard(daily: daily)).toList(),
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
