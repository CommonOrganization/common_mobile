import 'package:common/controllers/screen_controller.dart';
import 'package:common/controllers/user_controller.dart';
import 'package:common/models/user/user.dart';
import 'package:common/widgets/common_action_button.dart';
import 'package:common/widgets/common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../constants/constants_colors.dart';
import '../../services/user_service.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _informationController = TextEditingController();

  String? _newProfileImage;
  bool _isInitialized = false;

  void imagePressed() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    String? imageUrl = await UserService.uploadProfileImage(image: image);
    if (imageUrl == null) return;
    setState(() => _newProfileImage = imageUrl);
  }

  void updatePressed(User user) async {
    Map<String, dynamic> updateData = {
      'profileImage': _newProfileImage ?? user.profileImage,
      'name': _nameController.text,
      'information': _informationController.text,
    };
    bool updateSuccess =
        await UserService.multiUpdate(id: user.id, data: updateData);
    if (!mounted) return;
    if (updateSuccess) {
      context.read<ScreenController>().pageRefresh();
      bool refreshSuccess = await context.read<UserController>().refreshUser();
      if (!mounted) return;
      if (refreshSuccess) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
            '프로필 편집',
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
        body: Consumer<UserController>(builder: (context, controller, child) {
          if (controller.user == null) return Container();
          User user = controller.user!;
          if (!_isInitialized) {
            _isInitialized = true;
            _nameController.text = user.name;
            _informationController.text = user.information;
          }
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const ClampingScrollPhysics(),
                  children: [
                    kProfileImageArea(user),
                    const SizedBox(height: 20),
                    kTextFieldArea(
                      title: '닉네임',
                      controller: _nameController,
                      hintText: '8자 이내 한글 혹은 영문',
                      maxLength: 8,
                    ),
                    const SizedBox(height: 20),
                    kTextFieldArea(
                      title: '자기소개',
                      controller: _informationController,
                      hintText: '자기소개를 입력하세요.',
                    ),
                  ],
                ),
              ),
              CommonActionButton(
                onTap: () => updatePressed(user),
                value: true,
                title: '완료',
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget kProfileImageArea(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => imagePressed(),
            child: SizedBox(
              width: 90,
              height: 84,
              child: Stack(
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(84),
                      color: kDarkGray20Color,
                      image: DecorationImage(
                        image:
                            NetworkImage(_newProfileImage ?? user.profileImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 2),
                            blurRadius: 5,
                            color: kBlurColor,
                          )
                        ],
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/svg/camera_20px.svg',
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget kTextFieldArea({
    required String title,
    required TextEditingController controller,
    required String hintText,
    int? maxLength,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: kFontGray800Color,
              height: 20 / 14,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: CommonTextField(
            controller: controller,
            maxLength: maxLength,
            hintText: hintText,
            textChanged: (text) => setState(() {}),
          ),
        ),
      ],
    );
  }
}
