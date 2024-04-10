import 'package:common/controllers/user_controller.dart';
import 'package:common/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../constants/constants_colors.dart';
import '../../constants/constants_enum.dart';
import '../../constants/constants_value.dart';
import '../../utils/local_utils.dart';
import '../../widgets/common_action_button.dart';

class ProfileEditCategoryScreen extends StatefulWidget {
  const ProfileEditCategoryScreen({super.key});

  @override
  State<ProfileEditCategoryScreen> createState() =>
      _ProfileEditCategoryScreenState();
}

class _ProfileEditCategoryScreenState extends State<ProfileEditCategoryScreen> {
  final List<CommonCategory> _selectedCategoryList = [];

  bool _isInitialized = false;

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
        elevation: 0,
      ),
      body: Consumer<UserController>(builder: (context, controller, child) {
        if (controller.user == null) return Container();
        if (!_isInitialized) {
          _isInitialized = true;
          _selectedCategoryList.addAll(controller.user!.interestCategory
              .map((category) => CommonCategoryExtenstion.getCategory(category))
              .toList());
        }
        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      '무엇을 좋아하세요?',
                      style: TextStyle(
                        color: kFontGray900Color,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '관심 있는 주제를 최대 5개까지 선택해 주세요.',
                      style: TextStyle(
                        color: kFontGray500Color,
                        fontSize: 14,
                        height: 20 / 14,
                      ),
                    ),
                    const SizedBox(height: 36),
                    GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 3 / 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      children: kEachCommonCategoryList.map((commonCategory) {
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
                            setState(() =>
                                _selectedCategoryList.add(commonCategory));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isIncluded ? kSubColor1 : kWhiteColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: isIncluded
                                      ? kMainColor
                                      : kFontGray50Color),
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
                  ],
                ),
              ),
            ),
            CommonActionButton(
              value: _selectedCategoryList.isNotEmpty,
              title: '다음',
              onTap: () async {
                List categoryList = _selectedCategoryList
                    .map((category) => category.name)
                    .toList();
                bool updateSuccess = await UserService.update(
                  id: controller.user!.id,
                  field: 'interestCategory',
                  value: categoryList,
                );
                if (updateSuccess) {
                  await controller.refreshUser();
                  if (!context.mounted) return;
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      }),
    );
  }
}
