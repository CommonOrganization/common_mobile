import 'package:flutter/material.dart';

import '../../../constants/constants_colors.dart';

class GatheringTagArea extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final List<String> tagList;
  final Function submitPressed;
  final Function removePressed;
  const GatheringTagArea({Key? key, required this.title, required this.controller, required this.tagList, required this.submitPressed, required this.removePressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: ListView(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kGrey1C1C1EColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '한글과 영어로 최대 8글자까지 입력할 수 있어요.',
            style: TextStyle(
              fontSize: 14,
              color: kGrey8E8E93Color,
            ),
          ),
          const SizedBox(height: 36),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              border: Border.all(color: kMainColor, width: 2),
              borderRadius: BorderRadius.circular(52),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style:
                    TextStyle(fontSize: 13, color: kGrey363639Color),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      counterText: '',
                      hintText: '모임과 관련된 태그를 입력해주세요.',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: kWhiteAEAEB2Color,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: ()=>submitPressed(),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 26,
                    decoration: BoxDecoration(
                      color: kMainColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      '등록',
                      style: TextStyle(
                        fontSize: 13,
                        color: kWhiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),
          Row(
            children: [
              Text(
                '예시',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: kGrey2C2C2EColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(관심사, 지역, 연령 등)',
                style: TextStyle(
                  fontSize: 13,
                  color: kWhiteAEAEB2Color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['배드민턴', '등산', '서울', '2030']
                .map((tag) => kShowTag(tag))
                .toList(),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text(
                '등록한 태그',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: kGrey2C2C2EColor,
                ),
              ),
              const Spacer(),
              Text(
                '최대 5개',
                style: TextStyle(
                  fontSize: 14,
                  color: kGrey636366Color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tagList.map((tag) => kEditTag(tag)).toList(),
          ),
        ],
      ),
    );
  }

  Widget kShowTag(String tag) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: kMainBackgroundColor,
          ),
          child: Text(
            '#$tag',
            style: TextStyle(
              fontSize: 11,
              color: kFontMainColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget kEditTag(String tag) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: kMainBackgroundColor,
          ),
          child: Row(
            children: [
              Text(
                '#$tag',
                style: TextStyle(
                  fontSize: 11,
                  color: kFontMainColor,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => removePressed(tag),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: kMainBackgroundColor,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 8,
                    color: kFontMainColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
