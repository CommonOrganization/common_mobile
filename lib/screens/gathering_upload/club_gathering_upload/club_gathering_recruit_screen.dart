import 'package:common/constants/constants_enum.dart';
import 'package:common/screens/gathering_upload/components/gathering_recruit_way_area.dart';
import 'package:flutter/material.dart';
import '../../../models/club_gathering/club_gathering.dart';
import '../../../widgets/common_action_button.dart';

class ClubGatheringRecruitScreen extends StatefulWidget {
  final ClubGathering? gathering;
  final Function nextPressed;
  const ClubGatheringRecruitScreen({
    super.key,
    required this.nextPressed, this.gathering,
  });

  @override
  State<ClubGatheringRecruitScreen> createState() =>
      _ClubGatheringRecruitScreenState();
}

class _ClubGatheringRecruitScreenState
    extends State<ClubGatheringRecruitScreen> {
  final TextEditingController _detailQuestionController =
      TextEditingController();

  RecruitWay _selectedRecruitWay = RecruitWay.firstCome;

  bool get canNextPress =>
      _selectedRecruitWay == RecruitWay.firstCome ||
      (_selectedRecruitWay == RecruitWay.approval &&
          _detailQuestionController.text.isNotEmpty);

  @override
  void initState() {
    super.initState();
    setGatheringInformation();
  }

  void setGatheringInformation() {
    if (widget.gathering == null) return;
    _detailQuestionController.text = widget.gathering!.recruitQuestion;
    _selectedRecruitWay =
        RecruitWayExtenstion.getRecruitWay(widget.gathering!.recruitWay);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GatheringRecruitWayArea(
              selectedRecruitWay: _selectedRecruitWay,
              controller: _detailQuestionController,
              recruitWayPressed: (RecruitWay recruitWay) =>
                  setState(() => _selectedRecruitWay = recruitWay),
              textFieldOnChange: (text) => setState(() {}),
            ),
          ),
        ),
        CommonActionButton(
          value: canNextPress,
          onTap: () {
            if (!canNextPress) return;
            if (_selectedRecruitWay == RecruitWay.firstCome) {
              widget.nextPressed(_selectedRecruitWay, '');
              return;
            }
            widget.nextPressed(
                _selectedRecruitWay, _detailQuestionController.text);
          },
          title: '다음',
        ),
      ],
    );
  }
}
