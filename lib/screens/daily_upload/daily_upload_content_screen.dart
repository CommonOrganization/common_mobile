import 'package:flutter/material.dart';
import '../../constants/constants_colors.dart';
import '../../widgets/common_action_button.dart';

class DailyUploadContentScreen extends StatefulWidget {
  final Function nextPressed;
  const DailyUploadContentScreen({super.key, required this.nextPressed});

  @override
  State<DailyUploadContentScreen> createState() =>
      _DailyUploadContentScreenState();
}

class _DailyUploadContentScreenState extends State<DailyUploadContentScreen> {
  final TextEditingController _dailyContentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const ClampingScrollPhysics(),
            children: [
              const SizedBox(height: 12),
              Text(
                '데일리를 소개해 볼까요?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kFontGray900Color,
                  height: 1,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '설명',
                style: TextStyle(
                  fontSize: 15,
                  color: kFontGray800Color,
                  fontWeight: FontWeight.bold,
                  height: 20 / 15,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 104),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: kFontGray50Color,
                ),
                child: TextField(
                  controller: _dailyContentController,
                  style: TextStyle(
                    fontSize: 14,
                    color: kFontGray800Color,
                    height: 20 / 14,
                  ),
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    counterText: '',
                    hintText: '오늘의 일상은 어땠는지 모두에게 소개해 보세요.',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: kFontGray400Color,
                      height: 20 / 14,
                    ),
                  ),
                  onChanged: (text) => setState(() {}),
                ),
              )
            ],
          ),
        ),
        CommonActionButton(
          value: _dailyContentController.text.isNotEmpty,
          onTap: () {
            if (_dailyContentController.text.isEmpty) return;
            widget.nextPressed(_dailyContentController.text);
          },
          title: '다음',
        ),
      ],
    );
  }
}
