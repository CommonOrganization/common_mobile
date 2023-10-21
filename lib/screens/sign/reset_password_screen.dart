import 'package:common/screens/sign/reset_new_password_screen.dart';
import 'package:common/screens/sign/reset_password_phone_screen.dart';
import 'package:common/utils/local_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants/constants_colors.dart';
import '../../services/user_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  int _pageIndex = 0;
  late String _userPhone;
  late String _userNewPassword;

  Future<void> resetPasswordPressed(String newPassword) async {
    _userNewPassword = newPassword;
    bool updateSuccess = await UserService.updatePassword(
        phone: _userPhone, newPassword: _userNewPassword);
    if (!mounted) return;
    if (updateSuccess) {
      Navigator.pop(context);
      showMessage(context, message: '비밀번호가 변경되었습니다');
      return;
    }
    showMessage(context, message: '가입된 회원정보가 없습니다');
  }

  Widget getScreen() {
    switch (_pageIndex) {
      case 0:
        return ResetPasswordPhoneScreen(
          nextPressed: (String phone) => setState(() {
            _pageIndex++;
            _userPhone = phone;
          }),
        );
      case 1:
        return ResetNewPasswordScreen(
          nextPressed: (String newPassword) =>
              resetPasswordPressed(newPassword),
        );
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
          onTap: () {
            if (_pageIndex == 0) {
              Navigator.pop(context);
              return;
            }
            setState(() => _pageIndex--);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/icons/svg/arrow_left_28px.svg'),
          ),
        ),
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset('assets/icons/svg/close_28px.svg'),
          ),
          const SizedBox(width: 20),
        ],
        elevation: 0,
      ),
      body: getScreen(),
    );
  }
}
