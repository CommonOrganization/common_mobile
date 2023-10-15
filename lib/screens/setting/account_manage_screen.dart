import 'package:common/controllers/user_controller.dart';
import 'package:common/screens/sign/login_screen.dart';
import 'package:common/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../constants/constants_colors.dart';
import '../../widgets/dialog/leave_user_dialog.dart';
import 'components/setting_more_button.dart';

class AccountManageScreen extends StatelessWidget {
  const AccountManageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
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
        centerTitle: true,
        titleSpacing: 0,
        title: Text(
          '계정 관리',
          style: TextStyle(
            fontSize: 18,
            height: 28 / 18,
            letterSpacing: -0.5,
            color: kFontGray800Color,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          SettingMoreButton(
            title: '회원 탈퇴',
            onTap: () async {
              String? userId = context.read<UserController>().user?.id;
              if (userId == null) return;
              bool? leave = await showDialog(
                context: context,
                builder: (context) => const LeaveUserDialog(),
              );
              if (leave ?? false) {
                bool leaveSuccess = await UserService.leave(userId: userId);
                if (leaveSuccess && context.mounted) {
                  await context.read<UserController>().logout();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
