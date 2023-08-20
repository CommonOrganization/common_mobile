import 'package:common/constants/constants_value.dart';
import 'package:common/screens/gathering_detail/components/gathering_member_card.dart';
import 'package:common/services/gathering_service.dart';
import 'package:common/widgets/dialog/gathering_approve_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/constants_colors.dart';

class GatheringApplicantScreen extends StatefulWidget {
  final String category;
  final String gatheringId;
  const GatheringApplicantScreen(
      {Key? key, required this.gatheringId, required this.category})
      : super(key: key);

  @override
  State<GatheringApplicantScreen> createState() =>
      _GatheringApplicantScreenState();
}

class _GatheringApplicantScreenState extends State<GatheringApplicantScreen> {
  String get title =>
      widget.category == kClubGatheringCategory ? '소모임 가입 신청자' : '하루모임 신청자';

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
          title,
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
                field: 'applicantList'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List applicantList = snapshot.data;
                return ListView(
                  children: applicantList
                      .map((applicantId) => Row(
                            children: [
                              Expanded(
                                child: GatheringMemberCard(
                                  memberId: applicantId,
                                  isOrganizer: false,
                                ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (context) => GatheringApproveDialog(
                                    category: widget.category,
                                    gatheringId: widget.gatheringId,
                                    applicantId: applicantId,
                                  ),
                                ).then(
                                  (value) => setState(() {}),
                                ),
                                child: SvgPicture.asset(
                                  'assets/icons/svg/success_26px.svg',
                                ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {},
                                child: SvgPicture.asset(
                                  'assets/icons/svg/error_26px.svg',
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                );
              }
              return Container();
            }),
      ),
    );
  }
}
