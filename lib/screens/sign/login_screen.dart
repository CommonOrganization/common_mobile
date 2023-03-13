import 'package:common/constants/constants_colors.dart';
import 'package:common/controllers/local_controller.dart';
import 'package:common/controllers/user_controller.dart';
import 'package:common/models/user/user.dart';
import 'package:common/screens/main/main_screen.dart';
import 'package:common/screens/sign/register_main_screen.dart';
import 'package:common/screens/sign/reset_password_screen.dart';
import 'package:common/services/firebase_user_service.dart';
import 'package:common/utils/local_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../widgets/simple_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _keepLogin = true;

  void loginPressed() async {
    if (_phoneController.text.isEmpty || _passwordController.text.isEmpty) {
      showMessage(context, message: '전화번호와 비밀번호를 모두 입력해 주세요');
      return;
    }
    User? user = await FirebaseUserService.login(
        phone: _phoneController.text, password: _passwordController.text);
    if (!mounted) return;
    if (user == null) {
      showMessage(context, message: '입력한 정보를 다시 한번 확인해 주세요');
      return;
    }
    await context.read<UserController>().setUser(user);
    if (_keepLogin) {
      await LocalController.saveUserData(user);
    }
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kWhiteColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '우리지역 사람들과 함께하는 취미생활',
              style: TextStyle(
                fontSize: 14,
                color: kSubColor3,
              ),
            ),
            const SizedBox(height: 16),
            SvgPicture.asset(
              'assets/images/common_text_logo.svg',
              width: 278,
              fit: BoxFit.scaleDown,
            ),
            const SizedBox(height: 50),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: kFontGray50Color,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  hintText: '휴대폰 번호',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: kFontGray400Color,
                  ),
                ),
                style: TextStyle(
                  fontSize: 14,
                  color: kFontGray800Color,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: kFontGray50Color,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  hintText: '패스워드',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: kFontGray400Color,
                  ),
                ),
                style: TextStyle(
                  fontSize: 14,
                  color: kFontGray800Color,
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => setState(() => _keepLogin = !_keepLogin),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomCheckBox(
                      value: _keepLogin,
                      onTap: (value) => setState(() => _keepLogin = value),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '로그인 상태 유지',
                      style: TextStyle(
                        fontSize: 13,
                        color: kFontGray500Color,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 168),
            Column(
              children: [
                GestureDetector(
                  onTap: () => loginPressed(),
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: kMainColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      '로그인',
                      style: TextStyle(
                        fontSize: 16,
                        color: kFontGray0Color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResetPasswordScreen(),
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        width: 120,
                        child: Text(
                          '비밀번호 재설정',
                          style: TextStyle(
                            fontSize: 12,
                            color: kFontGray500Color,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterMainScreen(),
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        width: 120,
                        child: Text(
                          '회원가입',
                          style: TextStyle(
                            fontSize: 12,
                            color: kFontGray500Color,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}