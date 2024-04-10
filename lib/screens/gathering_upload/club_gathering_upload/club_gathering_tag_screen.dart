import 'package:common/utils/local_utils.dart';
import 'package:flutter/material.dart';
import '../../../models/club_gathering/club_gathering.dart';
import '../../../widgets/common_action_button.dart';
import '../components/gathering_tag_area.dart';

class ClubGatheringTagScreen extends StatefulWidget {
  final ClubGathering? gathering;
  final Function previewPressed;
  const ClubGatheringTagScreen({
    super.key,
    required this.previewPressed, this.gathering,
  });

  @override
  State<ClubGatheringTagScreen> createState() => _ClubGatheringTagScreenState();
}

class _ClubGatheringTagScreenState extends State<ClubGatheringTagScreen> {
  final TextEditingController _tagController = TextEditingController();

  final List _tagList = [];

  @override
  void initState() {
    super.initState();
    setGatheringInformation();
  }

  void setGatheringInformation() {
    if (widget.gathering == null) return;
    _tagList.addAll(widget.gathering!.tagList);
  }

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
        CommonActionButton(
          onTap: () => widget.previewPressed(_tagList),
          value: true,
          title: '미리보기',
        ),
      ],
    );
  }
}
