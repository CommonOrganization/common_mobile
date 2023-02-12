import 'package:flutter/material.dart';

import '../../../constants/constants_colors.dart';
import '../../../constants/constants_enum.dart';

class GatheringCategorySelectArea extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final bool showMore;
  final CommonCategory? selectedCategory;
  final Function onSelect;
  final Function showMorePressed;
  const GatheringCategorySelectArea({
    Key? key,
    required this.title,
    required this.controller,
    this.selectedCategory,
    required this.onSelect,
    required this.showMore,
    required this.showMorePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kGrey1C1C1EColor,
            ),
          ),
        ),
        const SizedBox(height: 36),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '카테고리',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: kGrey2C2C2EColor,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              crossAxisCount: 3,
              childAspectRatio: 3 / 2,
            ),
            children: (showMore
                    ? CommonCategory.values
                    : CommonCategory.values.sublist(0, 9))
                .map((category) {
              bool value = selectedCategory == category;
              return GestureDetector(
                onTap: () => onSelect(category),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: value ? kMainBackgroundColor : kWhiteColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: value ? kMainColor : kWhiteF4F4F4Color),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        category.image,
                        width: 40,
                        height: 40,
                      ),
                      Text(
                        category.title,
                        style: TextStyle(
                          fontSize: 13,
                          color: kGrey363639Color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        if (!showMore)
          GestureDetector(
            onTap: () => showMorePressed(),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
              alignment: Alignment.center,
              width: double.infinity,
              height: 38,
              decoration: BoxDecoration(
                color: kWhiteF6F6F6Color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '더보기',
                    style: TextStyle(
                      fontSize: 12,
                      color: kGrey48484AColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.expand_more,
                    size: 20,
                    color: kGrey48484AColor,
                  ),
                ],
              ),
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 24),
          width: double.infinity,
          height: 1,
          color: kWhiteF4F4F4Color,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '세부 카테고리',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: kGrey2C2C2EColor,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: kWhiteF4F4F4Color,
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(fontSize: 13, color: kGrey363639Color),
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
              counterText: '',
              hintText: '세부 카테고리를 입력해주세요.(선택)',
              hintStyle: TextStyle(
                fontSize: 13,
                color: kWhiteAEAEB2Color,
              ),
            ),
          ),
        )
      ],
    );
  }
}
