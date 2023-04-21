import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/constants_colors.dart';
import '../../../constants/constants_enum.dart';

class GatheringCategorySelectArea extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final bool showMore;
  final CommonCategory? selectedCategory;
  final Function onSelect;
  final Function showMorePressed;
  final Function onChanged;
  const GatheringCategorySelectArea({
    Key? key,
    required this.title,
    required this.controller,
    this.selectedCategory,
    required this.onSelect,
    required this.showMore,
    required this.showMorePressed,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kFontGray900Color,
              height: 1,
            ),
          ),
        ),
        const SizedBox(height: 36),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '카테고리',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: kFontGray800Color,
              height: 20 / 15,
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
                    color: value ? kSubColor1 : kWhiteColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: value ? kMainColor : kFontGray50Color),
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
                          color: kFontGray800Color,
                          letterSpacing: -0.5,
                          height: 20 / 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        GestureDetector(
          onTap: () => showMorePressed(),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            alignment: Alignment.center,
            width: double.infinity,
            height: 38,
            decoration: BoxDecoration(
              color: kFontGray50Color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 15),
                Container(
                  alignment: Alignment.center,
                  width: 50,
                  child: Text(
                    showMore ? '닫기' : '더보기',
                    style: TextStyle(
                      fontSize: 13,
                      color: kFontGray600Color,
                      height: 17 / 13,
                    ),
                  ),
                ),
                RotatedBox(
                  quarterTurns: showMore ? 90 : 0,
                  child: SvgPicture.asset(
                    'assets/icons/svg/arrow_down_16px.svg',
                    colorFilter: ColorFilter.mode(
                      kFontGray600Color,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: kFontGray50Color,
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                '세부 카테고리',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: kFontGray800Color,
                  height: 20 / 15,
                ),
              ),
              const Spacer(),
              Text(
                '${controller.text.length}/8',
                style: TextStyle(
                  fontSize: 14,
                  color: kFontGray500Color,
                  height: 20 / 14,
                ),
              )
            ],
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
            color: kFontGray50Color,
          ),
          child: TextField(
            controller: controller,
            maxLength: 8,
            style: TextStyle(
              fontSize: 14,
              color: kFontGray800Color,
              height: 20 / 14,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
              counterText: '',
              hintText: '세부 카테고리를 입력해주세요.(선택)',
              hintStyle: TextStyle(
                fontSize: 14,
                color: kFontGray400Color,
                height: 20 / 14,
              ),
            ),
            onChanged: (text) => onChanged(text),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
