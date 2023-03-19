import 'package:common/screens/gathering_upload/components/gathering_upload_next_button.dart';
import 'package:common/utils/local_utils.dart';
import 'package:flutter/material.dart';
import '../components/gathering_tag_area.dart';

class OneDayGatheringTagScreen extends StatefulWidget {
  final Function previewPressed;
  const OneDayGatheringTagScreen({
    Key? key,
    required this.previewPressed,
  }) : super(key: key);

  @override
  State<OneDayGatheringTagScreen> createState() =>
      _OneDayGatheringTagScreenState();
}

class _OneDayGatheringTagScreenState extends State<OneDayGatheringTagScreen> {
  final TextEditingController _tagController = TextEditingController();

  final List<String> _tagList = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GatheringTagArea(
            title: '하루모임을 나타내는 태그를 추가해 볼까요?',
            controller: _tagController,
            tagList: _tagList,
            submitPressed: () {
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
            },
            removePressed: (String tag) => setState(() => _tagList.remove(tag)),
          ),
        ),
        GatheringUploadNextButton(
          onTap: () => widget.previewPressed(_tagList),
          value: true,
          title: '미리보기',
        ),
      ],
    );
  }
}
