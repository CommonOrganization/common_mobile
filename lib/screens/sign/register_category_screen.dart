import 'package:common/constants/constants_colors.dart';
import 'package:common/constants/constants_enum.dart';
import 'package:common/screens/sign/components/register_next_button.dart';
import 'package:common/utils/local_utils.dart';
import 'package:flutter/material.dart';

class RegisterCategoryScreen extends StatefulWidget {
  final Function nextPressed;
  const RegisterCategoryScreen({Key? key, required this.nextPressed}) : super(key: key);

  @override
  State<RegisterCategoryScreen> createState() => _RegisterCategoryScreenState();
}

class _RegisterCategoryScreenState extends State<RegisterCategoryScreen> {
  final List<CommonCategory> _selectedCategoryList = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                Text(
                  '무엇을 좋아하세요?',
                  style: TextStyle(
                    color: kGrey1C1C1EColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '관심 있는 주제를 최대 5개까지 선택해 주세요.',
                  style: TextStyle(
                    color: kGrey8E8E93Color,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 36),
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 3 / 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  children: CommonCategory.values.map((commonCategory) {
                    bool isIncluded =
                        _selectedCategoryList.contains(commonCategory);
                    return GestureDetector(
                      onTap: () {
                        if (isIncluded) {
                          setState(() =>
                              _selectedCategoryList.remove(commonCategory));
                          return;
                        }
                        if (_selectedCategoryList.length >= 5) {
                          showMessage(context,
                              message: '관심 카테고리는 최대 5개까지 선택 가능합니다');
                          return;
                        }
                        setState(
                            () => _selectedCategoryList.add(commonCategory));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:
                              isIncluded ? kMainBackgroundColor : kWhiteColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color:
                                  isIncluded ? kMainColor : kWhiteF4F4F4Color),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              commonCategory.image,
                              width: 40,
                              height: 40,
                            ),
                            Text(
                              commonCategory.title,
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
              ],
            ),
          ),
        ),
        RegisterNextButton(
          value: _selectedCategoryList.isNotEmpty,
          onTap: () {
            if (_selectedCategoryList.isEmpty) return;
            widget.nextPressed(_selectedCategoryList);
          },
        ),
      ],
    );
  }
}
