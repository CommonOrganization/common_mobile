import 'dart:developer';
import 'package:common/constants/constants_enum.dart';
import 'package:common/controllers/screen_controller.dart';
import 'package:common/screens/search/category_search_screen.dart';
import 'package:common/screens/search/keyword_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../constants/constants_colors.dart';
import '../../constants/constants_value.dart';
import '../../controllers/local_controller.dart';
import '../../services/data_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool _searchWordAutoSave = true;

  Future<void> searchWord(String word) async {
    try {
      if (word.isEmpty) return;
      if (_searchWordAutoSave) {
        await LocalController.addSearchWord(word);
      }
      DataService.addSearchGatheringWord(word: word);
      setState(() => _searchController.clear());

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => KeywordSearchScreen(
            keyword: word,
          ),
        ),
      );
    } catch (e) {
      log('검색 실패 : $e');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          foregroundColor: kFontGray800Color,
          backgroundColor: kWhiteColor,
          leadingWidth: 48,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            behavior: HitTestBehavior.opaque,
            child: Container(
              margin: const EdgeInsets.only(left: 20),
              alignment: Alignment.center,
              child: SvgPicture.asset('assets/icons/svg/arrow_left_28px.svg'),
            ),
          ),
          title: Text(
            '검색',
            style: TextStyle(
              fontSize: 18,
              color: kFontGray800Color,
              height: 28 / 18,
              letterSpacing: -0.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
        ),
        body: Column(
          children: [
            // 검색창 및 검색어
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.only(left: 20, right: 22),
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: kMainColor, width: 2),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
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
                          height: 20 / 14,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: kFontGray800Color,
                        height: 20 / 14,
                      ),
                      onSubmitted: (text) => searchWord(text),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => searchWord(_searchController.text),
                    child: SvgPicture.asset('assets/icons/svg/search_24px.svg'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                physics: const ClampingScrollPhysics(),
                children: [
                  // 최근검색어
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          '최근 검색어 자동저장',
                          style: TextStyle(
                            fontSize: 13,
                            height: 20 / 13,
                            color: kFontGray400Color,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 38,
                          height: 20,
                          child: Switch(
                            value: _searchWordAutoSave,
                            thumbColor: MaterialStateProperty.all(kWhiteColor),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            activeTrackColor: kMainColor,
                            inactiveTrackColor: kFontGray200Color,
                            onChanged: (value) =>
                                setState(() => _searchWordAutoSave = value),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () async {
                            bool clearSearchWord =
                                await LocalController.clearSearchWord();
                            if (!mounted) return;
                            if (clearSearchWord) {
                              context.read<ScreenController>().pageRefresh();
                            }
                          },
                          child: Text(
                            '전체삭제',
                            style: TextStyle(
                              fontSize: 13,
                              height: 20 / 13,
                              letterSpacing: -0.5,
                              color: kFontGray400Color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Consumer<ScreenController>(
                      builder: (context, controller, child) {
                    return FutureBuilder(
                      future: LocalController.getSearchWord(),
                      builder: (context, snapshot) {
                        List<String> wordList = snapshot.data ?? [];
                        if (wordList.isEmpty) return Container();
                        int index = 0;
                        return Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 32),
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: wordList
                                .map((word) => kSearchWordTag(word, index++))
                                .toList(),
                          ),
                        );
                      },
                    );
                  }),
                  // 추천검색어
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          '추천 검색어',
                          style: TextStyle(
                            fontSize: 15,
                            height: 20 / 15,
                            fontWeight: FontWeight.bold,
                            color: kFontGray900Color,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // 최근 검색어 기반 추천시
                        // Text(
                        //   '최근 검색어 기반으로 골라봤어요.',
                        //   style: TextStyle(
                        //     fontSize: 13,
                        //     height: 20 / 13,
                        //     letterSpacing: -0.5,
                        //     color: kFontGray200Color,
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  //TODO 여기서 ChatGPT 혹은 다른 방법을 통해 추천 검색어를 제안해주기
                  FutureBuilder(
                    future: DataService.getSearchGatheringPopularWord(),
                    builder: (context, snapshot) {
                      List? wordList = snapshot.data;
                      if (wordList == null || wordList.isEmpty) {
                        return Container();
                      }
                      int maxSize = wordList.length > 4 ? 4 : wordList.length;
                      wordList = wordList.sublist(0, maxSize);
                      return Container(
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 24),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: wordList
                              .map((word) => kRecommendWordTag(word))
                              .toList(),
                        ),
                      );
                    },
                  ),
                  // TODO 여기서 배너 넣기
                  // Container(
                  //   margin: const EdgeInsets.symmetric(horizontal: 20),
                  //   width: double.infinity,
                  //   height: 120,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(20),
                  //     color: const Color(0xFFD4ECC6),
                  //   ),
                  // ),
                  // const SizedBox(height: 24),

                  // 실시간 인기 검색어
                  Builder(builder: (context) {
                    DateTime dateTime = DateTime.now();
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            '실시간 인기 검색어',
                            style: TextStyle(
                              fontSize: 15,
                              height: 20 / 15,
                              fontWeight: FontWeight.bold,
                              color: kFontGray900Color,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} 기준',
                            style: TextStyle(
                              fontSize: 13,
                              height: 20 / 13,
                              letterSpacing: -0.5,
                              color: kFontGray200Color,
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  FutureBuilder(
                    future: DataService.getSearchGatheringPopularWord(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List? wordList = snapshot.data;
                        if (wordList == null || wordList.isEmpty) {
                          return Container();
                        }
                        return Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 36),
                          width: double.infinity,
                          height: 172,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [0, 1, 2, 3, 4]
                                      .map((index) => kRankingWord(
                                            ranking: index + 1,
                                            word: wordList[index],
                                          ))
                                      .toList(),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [5, 6, 7, 8, 9]
                                      .map((index) => kRankingWord(
                                            ranking: index + 1,
                                            word: wordList[index],
                                          ))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                  // 카테고리별 모임 찾기
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '카테고리별 모임 찾기',
                      style: TextStyle(
                        fontSize: 15,
                        height: 20 / 15,
                        color: kFontGray900Color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: kAllCommonCategoryList
                            .map((category) => kCategoryButton(category))
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget kSearchWordTag(String word, int index) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => searchWord(word),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13.5),
            border: Border.all(color: kFontGray200Color),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                word,
                style: TextStyle(
                  fontSize: 13,
                  height: 17 / 13,
                  letterSpacing: -0.5,
                  color: kFontGray600Color,
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => LocalController.removeSearchWord(index)
                    .then((value) => setState(() {})),
                child: SvgPicture.asset(
                  'assets/icons/svg/close_6px.svg',
                ),
              ),
            ],
          ),
        ),
      );

  Widget kRecommendWordTag(String word) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => searchWord(word),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13.5),
            color: kSubColor1,
          ),
          child: Text(
            word,
            style: TextStyle(
              fontSize: 13,
              color: kSubColor3,
              letterSpacing: -0.5,
              height: 17 / 13,
            ),
          ),
        ),
      );

  Widget kRankingWord({required int ranking, required String word}) => Row(
        children: [
          SizedBox(
            width: 20,
            child: Text(
              '$ranking',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 20 / 16,
                letterSpacing: -0.5,
                color: kSubColor3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => searchWord(word),
            child: Text(
              word,
              style: TextStyle(
                fontSize: 14,
                height: 20 / 14,
                color: kFontGray800Color,
              ),
            ),
          )
        ],
      );

  Widget kCategoryButton(CommonCategory category) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CategorySearchScreen(category: category),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(right: 38),
        child: Column(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Image.asset(
                category.image,
                width: 40,
                height: 40,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              category.title,
              style: TextStyle(
                fontSize: 12,
                height: 20 / 12,
                letterSpacing: -0.5,
                color: kFontGray800Color,
              ),
            )
          ],
        ),
      ),
    );
  }
}
