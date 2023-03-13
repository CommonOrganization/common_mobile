import 'package:common/constants/constants_colors.dart';
import 'package:common/screens/gathering_upload/components/gathering_upload_next_button.dart';
import 'package:flutter/material.dart';

class OneDayGatheringTitleScreen extends StatefulWidget {
  final Function nextPressed;
  const OneDayGatheringTitleScreen({
    Key? key,
    required this.nextPressed,
  }) : super(key: key);

  @override
  State<OneDayGatheringTitleScreen> createState() =>
      _OneDayGatheringTitleScreenState();
}

class _OneDayGatheringTitleScreenState
    extends State<OneDayGatheringTitleScreen> {
  final TextEditingController _gatheringTitleController =
      TextEditingController();

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
                  SizedBox(height: 12),
                  Text(
                    '하루모임 제목을 작성해볼까요?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kFontGray900Color,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${_gatheringTitleController.text.length}/20',
                        style: TextStyle(
                          fontSize: 14,
                          color: kFontGray500Color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: kFontGray50Color,
                    ),
                    child: TextField(
                      controller: _gatheringTitleController,
                      style: TextStyle(fontSize: 14, color: kFontGray800Color),
                      maxLength: 20,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        counterText: '',
                        hintText: '하루모임을 대표할 수 있는 제목을 적어주세요.',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: kFontGray400Color,
                        ),
                      ),
                      onChanged: (text) => setState(() {}),
                    ),
                  )
                ],
              ),
            ),
          ),
          GatheringUploadNextButton(
            value: _gatheringTitleController.text.isNotEmpty,
            onTap: () {
              if (_gatheringTitleController.text.isEmpty) return;
              widget.nextPressed(_gatheringTitleController.text);
            },
          )
        ],
      ),
    );
  }
}
