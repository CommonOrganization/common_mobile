import 'package:common/constants/constants_colors.dart';
import 'package:common/constants/constants_enum.dart';
import 'package:common/controllers/user_controller.dart';
import 'package:common/screens/search/category_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InterestingCategoryContainer extends StatelessWidget {
  final String gatheringCategory;
  const InterestingCategoryContainer(
      {Key? key, required this.gatheringCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, controller, child) {
        if (controller.user == null) return Container();
        int countIndex = 0;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Row(
              children: controller.user!.interestCategory.map((category) {
                CommonCategory commonCategory =
                    CommonCategoryMap.getCategory(category);
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategorySearchScreen(
                        category: commonCategory,
                        gatheringCategory: gatheringCategory,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(9),
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: kSubColor1,
                            ),
                            child: Image.asset(
                              commonCategory.image,
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            commonCategory.title,
                            style: TextStyle(
                              fontSize: 12,
                              height: 20 / 12,
                              letterSpacing: -0.5,
                              color: kFontGray800Color,
                            ),
                          ),
                        ],
                      ),
                      if (countIndex++ < 4) const SizedBox(width: 15),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
