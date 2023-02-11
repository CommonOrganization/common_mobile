import 'package:common/constants/constants_enum.dart';
import 'package:common/screens/gathering_upload/components/gathering_upload_next_button.dart';
import 'package:flutter/material.dart';

class OneDayGatheringRecruitScreen extends StatefulWidget {
  const OneDayGatheringRecruitScreen({Key? key}) : super(key: key);

  @override
  State<OneDayGatheringRecruitScreen> createState() =>
      _OneDayGatheringRecruitScreenState();
}

class _OneDayGatheringRecruitScreenState
    extends State<OneDayGatheringRecruitScreen> {
  final TextEditingController _detailQuestionController =
      TextEditingController();

  RecruitWay _selectedRecruitWay = RecruitWay.firstCome;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [],
          ),
        ),
        GatheringUploadNextButton(
          value: true,
          onTap: () {},
        ),
      ],
    );
  }
}
