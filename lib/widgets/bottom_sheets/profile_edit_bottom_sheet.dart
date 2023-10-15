import 'package:common/controllers/user_controller.dart';
import 'package:common/screens/profile/profile_edit_category_screen.dart';
import 'package:common/services/user_service.dart';
import 'package:common/widgets/bottom_sheets/select_location_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/constants_colors.dart';
import '../../models/user/user.dart';
import '../../models/user_place/user_place.dart';
import '../../screens/setting/setting_screen.dart';
import 'bottom_sheet_custom_button.dart';

class ProfileEditBottomSheet extends StatelessWidget {
  const ProfileEditBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    BottomSheetCustomButton(
                      title: '설정 및 개인정보',
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingScreen(),
                          ),
                        );
                      },
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: kDarkGray20Color,
                    ),
                    BottomSheetCustomButton(
                      title: '내 지역 변경하기',
                      onPressed: () async {
                        User? user = context.read<UserController>().user;
                        if (user == null) return;
                        UserPlace? selectedUserPlace =
                            await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) =>
                              const SelectLocationBottomSheet(),
                        );
                        if (selectedUserPlace == null) return;
                        bool updateSuccess = await UserService.update(
                          id: user.id,
                          field: 'userPlace',
                          value: selectedUserPlace.toJson(),
                        );
                        if (!updateSuccess) return;
                        if (context.mounted) {
                          await context.read<UserController>().refreshUser();
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        }
                      },
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: kDarkGray20Color,
                    ),
                    BottomSheetCustomButton(
                      title: '내 관심 카테고리 변경하기',
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ProfileEditCategoryScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            SafeArea(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    '취소',
                    style: TextStyle(
                      fontSize: 16,
                      color: kMainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
