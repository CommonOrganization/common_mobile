import 'dart:io';

import 'package:common/constants/constants_colors.dart';
import 'package:common/controllers/user_controller.dart';
import 'package:common/screens/main/main_screen.dart';
import 'package:common/screens/sign/login_screen.dart';
import 'package:common/services/data_service.dart';
import 'package:common/widgets/dialog/update_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

  Future<bool> appVersionCheck(BuildContext context) async {
    PackageInfo? packageInfo = await PackageInfo.fromPlatform();
    String packageVersion = packageInfo.version;
    bool? canAppUse;
    if (Platform.isAndroid) {
      canAppUse = await DataService.canAppUse('android', packageVersion);
    }
    if (Platform.isIOS) {
      canAppUse = await DataService.canAppUse('ios', packageVersion);
    }
    if (canAppUse == null) return false;
    if (!context.mounted) return false;
    if (!canAppUse) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const UpdateDialog(),
      );
    }
    return true;
  }

  void autoLoginCheck() async {
    bool versionCheckSuccess = await appVersionCheck(context);
    if (!versionCheckSuccess) return;
    Future.delayed(
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
  }

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
