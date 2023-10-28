import 'package:common/controllers/user_controller.dart';
import 'package:common/screens/gathering_detail/components/gathering_member_card.dart';
import 'package:common/services/gathering_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../constants/constants_colors.dart';
import '../../widgets/dialog/gathering_application_form_dialog.dart';

class GatheringApplicantScreen extends StatefulWidget {
  final String category;
  final String organizerId;
  final String gatheringId;
  const GatheringApplicantScreen(
      {Key? key,
      required this.gatheringId,
      required this.category,
      required this.organizerId})
      : super(key: key);

  @override
  State<GatheringApplicantScreen> createState() =>
      _GatheringApplicantScreenState();
}

class _GatheringApplicantScreenState extends State<GatheringApplicantScreen> {
  late bool _isOrganizer;

  @override
  void initState() {
    super.initState();
    _isOrganizer =
        widget.organizerId == context.read<UserController>().user?.id;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        leadingWidth: 48,
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/icons/svg/arrow_left_28px.svg',
            ),
          ),
        ),
        title: Text(
          '승인 대기 멤버',
          style: TextStyle(
            fontSize: 18,
            height: 28 / 18,
            letterSpacing: -0.5,
            color: kFontGray800Color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder(
            future: GatheringService.get(
              category: widget.category,
              id: widget.gatheringId,
              field: 'applicantList',
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List applicantList = snapshot.data;
                return ListView(
                  children: applicantList
                      .map((applicantId) => kApplicantMemberCard(applicantId))
                      .toList(),
                );
              }
              return Container();
            }),
      ),
    );
  }

  Widget kApplicantMemberCard(String applicantId) {
    return Row(
      children: [
        Expanded(
          child: GatheringMemberCard(
            memberId: applicantId,
            isOrganizer: false,
          ),
        ),
        const SizedBox(width: 6),
        if (_isOrganizer)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (!_isOrganizer) return;
              // 여기서는 굳이 await을 통해 다음 작업을 할 필요 없이 then을 통해 함수끝나면 새로고침만 해줘~ 라는 느낌으로 함수를 작업
              showDialog(
                context: context,
                builder: (context) => GatheringApplicationFormDialog(
                  category: widget.category,
                  gatheringId: widget.gatheringId,
                  applicantId: applicantId,
                ),
              ).then((value) => setState(() {}));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2),
              alignment: Alignment.center,
              width: 52,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: kFontGray400Color),
                  color: kWhiteColor),
              child: Text(
                '신청서',
                style: TextStyle(
                  fontSize: 13,
                  height: 16 / 13,
                  color: kFontGray600Color,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
