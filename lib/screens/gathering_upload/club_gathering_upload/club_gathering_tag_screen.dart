import 'package:common/utils/local_utils.dart';
import 'package:flutter/material.dart';
import '../components/gathering_tag_area.dart';
import '../components/gathering_upload_preview_button.dart';

class ClubGatheringTagScreen extends StatefulWidget {
  final Function previewPressed;
  const ClubGatheringTagScreen({
    Key? key,
    required this.previewPressed,
  }) : super(key: key);

  @override
  State<ClubGatheringTagScreen> createState() => _ClubGatheringTagScreenState();
}

class _ClubGatheringTagScreenState extends State<ClubGatheringTagScreen> {
  final TextEditingController _tagController = TextEditingController();

  final List<String> _tagList = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GatheringTagArea(
            title: '소모임을 나타내는 태그를 추가해 볼까요?',
            controller: _tagController,
            tagList: _tagList,
            submitPressed: () {
              if (_tagList.length >= 5) {
                showMessage(context, message: '태그는 최대 5개까지 등록 가능합니다');
                return;
              }
              if(_tagController.text.isEmpty){
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
        GatheringUploadPreviewButton(
          onTap: () =>widget.previewPressed(_tagList)
        ),
      ],
    );
  }
}