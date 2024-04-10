import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants/constants_colors.dart';
import '../../constants/constants_value.dart';
import '../../utils/local_utils.dart';
import '../../widgets/common_action_button.dart';

class DailyUploadTagScreen extends StatefulWidget {
  final Function previewPressed;
  const DailyUploadTagScreen({super.key, required this.previewPressed});

  @override
  State<DailyUploadTagScreen> createState() => _DailyUploadTagScreenState();
}

class _DailyUploadTagScreenState extends State<DailyUploadTagScreen> {
  final TextEditingController _tagController = TextEditingController();

  final List _tagList = [];

  void submitPressed() {
    if (_tagList.length >= 5) {
      showMessage(context, message: '태그는 최대 5개까지 등록 가능합니다');
      return;
    }
    if (_tagController.text.isEmpty) {
      showMessage(context, message: '태그를 입력해 주세요');
      return;
    }
    setState(() {
      _tagList.add(_tagController.text);
      _tagController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 12),
              Text(
                '데일리를 나타내는 태그를 추가해 볼까요?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kFontGray900Color,
                  height: 1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '한글과 영어로 최대 8글자까지 입력할 수 있어요.',
                style: TextStyle(
                  fontSize: 14,
                  color: kFontGray500Color,
                  height: 20 / 14,
                ),
              ),
              const SizedBox(height: 36),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  border: Border.all(color: kMainColor, width: 2),
                  borderRadius: BorderRadius.circular(52),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _tagController,
                        maxLength: 8,
                        style: TextStyle(
                          fontSize: 14,
                          color: kFontGray800Color,
                          height: 20 / 14,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isDense: true,
                          counterText: '',
                          hintText: '모임과 관련된 태그를 입력해 주세요.',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: kFontGray400Color,
                            height: 20 / 14,
                          ),
                        ),
                        onSubmitted: (text) => submitPressed(),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => submitPressed(),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        height: 26,
                        decoration: BoxDecoration(
                          color: kMainColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          '등록',
                          style: TextStyle(
                            fontSize: 13,
                            color: kFontGray0Color,
                            height: 16 / 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              Row(
                children: [
                  Text(
                    '예시',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kFontGray800Color,
                      height: 20 / 15,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(관심사, 지역, 연령 등)',
                    style: TextStyle(
                      fontSize: 14,
                      color: kFontGray400Color,
                      height: 20 / 14,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: kExampleTagList.map((tag) => kShowTag(tag)).toList(),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    '등록한 태그',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kFontGray800Color,
                      height: 20 / 15,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '최대 5개',
                    style: TextStyle(
                      fontSize: 14,
                      color: kFontGray500Color,
                      height: 20 / 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tagList.map((tag) => kEditTag(tag)).toList(),
              ),
            ],
          ),
        ),
        CommonActionButton(
          value: true,
          onTap: () => widget.previewPressed(_tagList),
          title: '미리보기',
        ),
      ],
    );
  }

  Widget kShowTag(String tag) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: kSubColor1,
          ),
          child: Text(
            tag,
            style: TextStyle(
              fontSize: 13,
              color: kSubColor3,
              letterSpacing: -0.5,
              height: 16 / 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget kEditTag(String tag) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: kSubColor1,
          ),
          child: Row(
            children: [
              Text(
                tag,
                style: TextStyle(
                  fontSize: 13,
                  color: kSubColor3,
                  letterSpacing: -0.5,
                  height: 16 / 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => setState(() => _tagList.remove(tag)),
                child: SvgPicture.asset('assets/icons/svg/delete_6px.svg'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
