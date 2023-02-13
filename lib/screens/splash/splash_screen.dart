import 'package:common/constants/constants_colors.dart';
import 'package:common/controllers/user_controller.dart';
import 'package:common/screens/main/main_screen.dart';
import 'package:common/screens/sign/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    playAnimation();
    autoLoginCheck();
  }

  void playAnimation() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    _animation =
        Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(_animationController);

    Future.delayed(const Duration(milliseconds: 600),
        () => _animationController.forward());
  }

  void autoLoginCheck() => Future.delayed(
        const Duration(milliseconds: 2250),
        () async {
          bool autoLoggedIn = await context.read<UserController>().autoLogin();
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  autoLoggedIn ? const MainScreen() : const LoginScreen(),
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      body: Stack(
        children: [
          SlideTransition(
            position: _animation,
            child: Center(
              child: SvgPicture.asset(
                'assets/images/common_text_logo_white.svg',
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              color: kMainColor,
            ),
          ),
        ],
      ),
    );
  }
}
