import 'package:common/controllers/screen_controller.dart';
import 'package:common/services/user_service.dart';
import 'package:common/widgets/bottom_sheets/profile_edit_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../constants/constants_colors.dart';
import '../../controllers/user_controller.dart';
import '../../models/user/user.dart';
import '../../widgets/bottom_sheets/user_report_bottom_sheet.dart';
import 'components/profile_user_contents_container.dart';
import 'components/profile_user_information_container.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;
  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  AppBar getAppBar(BuildContext context) {
    bool isMyProfile = userId == context.read<UserController>().user?.id;
    bool canPop = Navigator.of(context).canPop();
    if (isMyProfile) {
      return AppBar(
        foregroundColor: kFontGray800Color,
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        leadingWidth: 48,
        leading: canPop
            ? GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  alignment: Alignment.center,
                  child:
                      SvgPicture.asset('assets/icons/svg/arrow_left_28px.svg'),
                ),
              )
            : null,
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => const ProfileEditBottomSheet(),
            ),
            child: SvgPicture.asset(
              'assets/icons/svg/menu_26px.svg',
            ),
          ),
          const SizedBox(width: 20),
        ],
        elevation: 0,
      );
    }
    return AppBar(
      foregroundColor: kFontGray800Color,
      backgroundColor: kWhiteColor,
      leadingWidth: 48,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.only(left: 20),
          alignment: Alignment.center,
          child: SvgPicture.asset('assets/icons/svg/arrow_left_28px.svg'),
        ),
      ),
      actions: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) =>  UserReportBottomSheet(userId: userId),
          ),
          child: SvgPicture.asset(
            'assets/icons/svg/more_26px.svg',
          ),
        ),
        const SizedBox(width: 20),
      ],
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: getAppBar(context),
      body: Consumer<ScreenController>(builder: (context, controller, child) {
        return FutureBuilder(
            future: UserService.getUser(id: userId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                User? user = snapshot.data;
                if (user == null) return Container();
                bool isMyProfile =
                    user.id == context.read<UserController>().user?.id;
                return SafeArea(
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    children: [
                      ProfileUserInformationContainer(
                        user: user,
                        isMyProfile: isMyProfile,
                      ),
                      ProfileUserContentsContainer(userId: user.id),
                    ],
                  ),
                );
              }
              return Container();
            });
      }),
    );
  }
}
