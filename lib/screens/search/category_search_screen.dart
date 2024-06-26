import 'package:common/constants/constants_enum.dart';
import 'package:common/controllers/block_controller.dart';
import 'package:common/controllers/user_controller.dart';
import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/screens/search/search_screen.dart';
import 'package:common/services/daily_service.dart';
import 'package:common/widgets/club_gathering_row_card.dart';
import 'package:common/widgets/one_day_gathering_row_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../constants/constants_colors.dart';
import '../../constants/constants_value.dart';
import '../../models/daily/daily.dart';
import '../../services/club_gathering_service.dart';
import '../../services/one_day_gathering_service.dart';
import '../../widgets/daily_card.dart';

class CategorySearchScreen extends StatefulWidget {
  final CommonCategory category;
  final String? gatheringCategory;

  const CategorySearchScreen({
    super.key,
    required this.category,
    this.gatheringCategory,
  });

  @override
  State<CategorySearchScreen> createState() => _CategorySearchScreenState();
}

class _CategorySearchScreenState extends State<CategorySearchScreen> {
  late CommonCategory _selectedCategory;
  late List<CommonCategory> _categoryList;
  int _categoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
    // 선택된 취미 카테고리가 가장 앞으로 나올 수 있도록
    _categoryList = [
      if (widget.category != CommonCategory.all) CommonCategory.all,
      widget.category,
      ...kEachCommonCategoryList.where((element) => element != widget.category)
    ];
    // 소모임, 피드를 통해 넘어올경우 해당 인덱스로 수정
    if (widget.gatheringCategory != null) {
      if (widget.gatheringCategory == kClubGatheringCategory) {
        _categoryIndex = 1;
      }
    }
  }

  Widget getScreen({required String city, required String userId}) {
    switch (_categoryIndex) {
      case 0:
        return kOneDayGatheringArea(city: city, userId: userId);
      case 1:
        return kClubGatheringArea(city: city, userId: userId);
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
        surfaceTintColor: kWhiteColor,
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
        title: Text(
          '카테고리',
          style: TextStyle(
            fontSize: 18,
            height: 28 / 18,
            letterSpacing: -0.5,
            color: kFontGray800Color,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchScreen(),
              ),
            ),
            child: SvgPicture.asset(
              'assets/icons/svg/search_26px.svg',
            ),
          ),
          const SizedBox(width: 20),
        ],
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
          Expanded(
            child: ListView(
              physics: const ClampingScrollPhysics(),
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 16, bottom: 20),
                    child: Row(
                      children: _categoryList
                          .map((category) => kCategoryButton(category))
                          .toList(),
                    ),
                  ),
                ),
                Consumer<UserController>(builder: (context, controller, child) {
                  if (controller.user == null) return Container();
                  String city = controller.user!.userPlace['city'];
                  String userId = controller.user!.id;
                  return getScreen(city: city, userId: userId);
                }),
              ],
            ),
          ),
        ],
      ),
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

  Widget kCategoryButton(CommonCategory category) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _selectedCategory = category),
      child: Container(
        margin: const EdgeInsets.only(right: 24),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: _selectedCategory == category ? kSubColor1 : null,
              ),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Image.asset(
                  category.image,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              category.title,
              style: TextStyle(
                fontSize: 13,
                height: 20 / 13,
                letterSpacing: -0.5,
                color: _selectedCategory == category
                    ? kFontGray800Color
                    : kFontGray200Color,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget kOneDayGatheringArea({required String city, required String userId}) {
    return Consumer<BlockController>(builder: (context, controller, child) {
      return ListView(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        children: [
          FutureBuilder(
            future: OneDayGatheringService.getNewGatheringWithCategory(
                city: city, category: _selectedCategory.name, userId: userId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<OneDayGathering>? gatheringList = snapshot.data;
                if (gatheringList == null) return Container();
                gatheringList = gatheringList
                    .where((gathering) =>
                        !controller.blockedObjectList.contains(gathering.id))
                    .where((gathering) => !controller.blockedObjectList
                        .contains(gathering.organizerId))
                    .toList();
                if (gatheringList.isEmpty) return Container();

                return ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'NEW 하루모임',
                        style: TextStyle(
                          fontSize: 18,
                          height: 25 / 18,
                          color: kFontGray800Color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...(gatheringList.length > 3
                            ? gatheringList.sublist(0, 3)
                            : gatheringList)
                        .map((gathering) => OneDayGatheringRowCard(
                            gathering: gathering, userId: userId)),
                    const SizedBox(height: 24),
                  ],
                );
              }
              return Container();
            },
          ),
          FutureBuilder(
            future: OneDayGatheringService.getAllGatheringWithCategory(
                city: city, category: _selectedCategory.name, userId: userId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<OneDayGathering> gatheringList =
                    snapshot.data as List<OneDayGathering>;
                if (gatheringList.isEmpty) return Container();
                return ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        '전체 하루모임',
                        style: TextStyle(
                          fontSize: 18,
                          height: 25 / 18,
                          color: kFontGray800Color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...gatheringList.map((gathering) => OneDayGatheringRowCard(
                        gathering: gathering, userId: userId)),
                    const SizedBox(height: 24),
                  ],
                );
              }
              return Container();
            },
          ),
        ],
      );
    });
  }

  Widget kClubGatheringArea({required String city, required String userId}) {
    return Consumer<BlockController>(builder: (context, controller, child) {
      return ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          FutureBuilder(
            future: ClubGatheringService.searchGatheringWithCategory(
                city: city, category: _selectedCategory.name),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<ClubGathering>? gatheringList = snapshot.data;
                if (gatheringList == null) return Container();
                gatheringList = gatheringList
                    .where((gathering) =>
                        !controller.blockedObjectList.contains(gathering.id))
                    .where((gathering) => !controller.blockedObjectList
                        .contains(gathering.organizerId))
                    .toList();
                if (gatheringList.isEmpty) return Container();
                return ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'NEW 소모임',
                        style: TextStyle(
                          fontSize: 18,
                          height: 25 / 18,
                          color: kFontGray800Color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...(gatheringList.length > 3
                            ? gatheringList.sublist(0, 3)
                            : gatheringList)
                        .map(
                      (gathering) => ClubGatheringRowCard(
                          gathering: gathering, userId: userId),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              }
              return Container();
            },
          ),
          FutureBuilder(
            future: ClubGatheringService.getAllGatheringWithCategory(
                city: city, category: _selectedCategory.name),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<ClubGathering> gatheringList =
                    snapshot.data as List<ClubGathering>;
                if (gatheringList.isEmpty) return Container();
                return ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        '전체 소모임',
                        style: TextStyle(
                          fontSize: 18,
                          height: 25 / 18,
                          color: kFontGray800Color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...gatheringList.map((gathering) => ClubGatheringRowCard(
                        gathering: gathering, userId: userId)),
                    const SizedBox(height: 24),
                  ],
                );
              }
              return Container();
            },
          ),
        ],
      );
    });
  }

  Widget kDailyArea() {
    return Consumer<BlockController>(builder: (context, controller, child) {
      return FutureBuilder(
        future: DailyService.searchDailyWithCategory(
            category: _selectedCategory.name),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Daily>? dailyList = snapshot.data;
            if (dailyList == null) return Container();
            dailyList = dailyList
                .where(
                    (daily) => !controller.blockedObjectList.contains(daily.id))
                .where((daily) =>
                    !controller.blockedObjectList.contains(daily.organizerId))
                .toList();
            if (dailyList.isEmpty) return Container();

            return GridView.count(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 3,
              children:
                  dailyList.map((daily) => DailyCard(daily: daily)).toList(),
            );
          }
          return Container();
        },
      );
    });
  }
}
