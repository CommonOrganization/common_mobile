import 'package:common/constants/constants_url.dart';
import 'package:common/services/firebase_user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/constants_colors.dart';

class RegisterProfileScreen extends StatefulWidget {
  final String userName;
  final Function nextPressed;
  const RegisterProfileScreen({
    Key? key,
    required this.userName,
    required this.nextPressed,
  }) : super(key: key);

  @override
  State<RegisterProfileScreen> createState() => _RegisterProfileScreenState();
}

class _RegisterProfileScreenState extends State<RegisterProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _informationController = TextEditingController();

  late String _imageUrl;

  @override
  void initState() {
    super.initState();
    _imageUrl = DateTime.now().second % 2 == 0
        ? kProfileRedImageUrl
        : kProfileYellowImageUrl;
  }

  void imagePressed() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    String? imageUrl =
        await FirebaseUserService.uploadProfileImage(image: image);
    if (imageUrl == null) return;
    setState(() => _imageUrl = imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  Text(
                    '프로필 설정',
                    style: TextStyle(
                      color: kGrey1C1C1EColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '프로필은 언제든 변경할 수 있어요.',
                    style: TextStyle(
                      color: kGrey8E8E93Color,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 36),
                  GestureDetector(
                    onTap: () => imagePressed(),
                    child: Center(
                      child: Stack(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 104,
                            height: 104,
                            decoration: BoxDecoration(
                              color: kWhiteColor,
                              borderRadius: BorderRadius.circular(55),
                              boxShadow: [
                                BoxShadow(
                                  color: kWhiteD9D9D9Color,
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(55),
                              //여기서 이미지 전환만 진행해주면 될듯
                              child: Image.network(
                                _imageUrl,
                                fit: BoxFit.cover,
                                width: 104,
                                height: 104,
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
                                    color: kWhiteD9D9D9Color,
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/svg/camera.svg',
                                width: 20,
                                height: 20,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      widget.userName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kGrey363639Color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: kWhiteC6C6C6Color,
                    ))),
                    child: TextField(
                      controller: _informationController,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        counterText: '',
                        hintText: '자기소개를 입력하세요.',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: kWhiteAEAEB2Color,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: kGrey363639Color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
          GestureDetector(
            // onTap: () =>print(_imageUrl),
            onTap: () =>
                widget.nextPressed(_imageUrl, _informationController.text),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              color: kMainColor,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 18,
                      color: kWhiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
