import 'package:common/constants/constants_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/constants_colors.dart';
import '../../constants/constants_value.dart';

class CategorySearchScreen extends StatefulWidget {
  final CommonCategory category;
  const CategorySearchScreen({Key? key, required this.category})
      : super(key: key);

  @override
  State<CategorySearchScreen> createState() => _CategorySearchScreenState();
}

class _CategorySearchScreenState extends State<CategorySearchScreen> {
  late CommonCategory _selectedCategory;
  int _categoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
  }

  Widget getScreen() {
    switch (_categoryIndex) {
      case 0:
        return kOneDayGatheringArea();
      case 1:
        return kClubGatheringArea();
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
          SvgPicture.asset(
            'assets/icons/svg/search_26px.svg',
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
              kTabContainer(index: 2, title: '피드'),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 16, bottom: 20),
                    child: Row(
                      children: kAllCommonCategoryList
                          .map((category) => kCategoryButton(category))
                          .toList(),
                    ),
                  ),
                ),
                getScreen(),
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

  Widget kOneDayGatheringArea() {
    return ListView(
      shrinkWrap: true,
      children: [],
    );
  }

  Widget kClubGatheringArea() {
    return ListView(
      shrinkWrap: true,
      children: [],
    );
  }
}
