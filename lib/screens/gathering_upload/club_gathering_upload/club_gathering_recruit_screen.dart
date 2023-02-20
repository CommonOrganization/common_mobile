import 'package:common/constants/constants_enum.dart';
import 'package:common/screens/gathering_upload/components/gathering_recruit_way_area.dart';
import 'package:common/screens/gathering_upload/components/gathering_upload_next_button.dart';
import 'package:flutter/material.dart';

class ClubGatheringRecruitScreen extends StatefulWidget {
  final Function nextPressed;
  const ClubGatheringRecruitScreen({
    Key? key,
    required this.nextPressed,
  }) : super(key: key);

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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 18),
            child: GatheringRecruitWayArea(
              selectedRecruitWay: _selectedRecruitWay,
              controller: _detailQuestionController,
              recruitWayPressed: (RecruitWay recruitWay) =>
                  setState(() => _selectedRecruitWay = recruitWay),
              textFieldOnChange: (text) => setState(() {}),
            ),
          ),
        ),
        GatheringUploadNextButton(
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
        ),
      ],
    );
  }
}
