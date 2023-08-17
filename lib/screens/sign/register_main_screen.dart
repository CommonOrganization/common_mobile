import 'dart:developer';
import 'package:common/constants/constants_colors.dart';
import 'package:common/models/user_place/user_place.dart';
import 'package:common/screens/sign/register_category_screen.dart';
import 'package:common/screens/sign/register_information_screen.dart';
import 'package:common/screens/sign/register_phone_screen.dart';
import 'package:common/screens/sign/register_profile_screen.dart';
import 'package:common/screens/sign/register_user_information_screen.dart';
import 'package:common/screens/sign/welcome_screen.dart';
import 'package:common/utils/local_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../constants/constants_enum.dart';
import '../../constants/constants_reg.dart';
import '../../controllers/user_controller.dart';
import '../../models/user/user.dart';
import '../../services/user_service.dart';

class RegisterMainScreen extends StatefulWidget {
  const RegisterMainScreen({Key? key}) : super(key: key);

  @override
  State<RegisterMainScreen> createState() => _RegisterMainScreenState();
}

class _RegisterMainScreenState extends State<RegisterMainScreen> {
  int _pageIndex = 0;
  late String _userPhone;
  late Country _userCountry;
  late String _userName;
  late String _userPassword;
  late String _userGender;
  late DateTime _userBirthday;
  late UserPlace _userPlace;
  late List<CommonCategory> _userCommonCategoryList;

  bool _isLoading = false;

  Future<void> registerPressed(String imageUrl, String information) async {
    try {
      if (_isLoading) return;
      _isLoading = true;
      Map<String, dynamic> userData = {
        'phone': _userPhone,
        'country': _userCountry.name,
        'name': _userName,
        'password': _userPassword,
        'gender': _userGender,
        'birthday': _userBirthday.toString(),
        'userPlace': _userPlace.toJson(),
        'interestCategory':
            _userCommonCategoryList.map((category) => category.name).toList(),
        'profileImage': imageUrl,
        'information': information.replaceAll(kMultiBlankRegExp, '\n\n'),
        'notificationToken': '',
        'likeOneDayGatheringList': [],
        'likeClubGatheringList': [],
        'likePostList': [],
      };
      User? user = await UserService.register(userData: userData);
      if (!mounted) return;
      if (user != null) {
        await context.read<UserController>().setUser(user);
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          ),
          (route) => false,
        );
        return;
      }
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      log('register failed : $e');
    }
  }

  Widget getScreen() {
    switch (_pageIndex) {
      case 0:
        return RegisterPhoneScreen(
          nextPressed: (String phone, Country country) async {
            if (await UserService.duplicate(
                field: 'phone', value: phone)) {
              if (!mounted) return;
              showMessage(context, message: '이미 가입된 번호입니다.');
              return;
            }
            setState(() {
              _pageIndex++;
              _userPhone = phone;
              _userCountry = country;
            });
          },
        );
      case 1:
        return RegisterInformationScreen(
          nextPressed: (String name, String password) => setState(() {
            _pageIndex++;
            _userName = name;
            _userPassword = password;
          }),
        );
      case 2:
        return RegisterUserInformationScreen(
          nextPressed:
              (String gender, DateTime birthday, UserPlace userPlace) =>
                  setState(() {
            _pageIndex++;
            _userGender = gender;
            _userBirthday = birthday;
            _userPlace = userPlace;
          }),
        );
      case 3:
        return RegisterCategoryScreen(
          nextPressed: (List<CommonCategory> commonCategoryList) =>
              setState(() {
            _pageIndex++;
            _userCommonCategoryList = commonCategoryList;
          }),
        );
      case 4:
        return RegisterProfileScreen(
          userName: _userName,
          nextPressed: (String imageUrl, String information) async =>
              await registerPressed(imageUrl, information),
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
          ...[0, 1, 2, 3, 4]
              .map(
                (index) => index == _pageIndex
                    ? Center(
                        child: Container(
                          margin: const EdgeInsets.only(left: 12),
                          alignment: Alignment.center,
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: kMainColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 14,
                              color: kFontGray0Color,
                              fontWeight: FontWeight.bold,
                              height: 20 / 14,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Container(
                          margin: const EdgeInsets.only(left: 12),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: kFontGray100Color,
                          ),
                        ),
                      ),
              )
              .toList(),
          const SizedBox(width: 20),
        ],
        elevation: 0,
      ),
      body: getScreen(),
    );
  }
}
