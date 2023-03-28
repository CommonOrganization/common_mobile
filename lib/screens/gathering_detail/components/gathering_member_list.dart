import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/constants_colors.dart';
import 'gathering_member_card.dart';

class GatheringMemberList extends StatefulWidget {
  final String title;
  final String organizerId;
  final List memberList;
  const GatheringMemberList({
    Key? key,
    required this.title,
    required this.memberList,
    required this.organizerId,
  }) : super(key: key);

  @override
  State<GatheringMemberList> createState() => _GatheringMemberListState();
}

class _GatheringMemberListState extends State<GatheringMemberList> {
  bool _showMore = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '멤버소개',
            style: TextStyle(
              fontSize: 13,
              color: kMainColor,
              height: 17 / 13,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kFontGray800Color,
              height: 25 / 18,
            ),
          ),
          const SizedBox(height: 8),
          ...(widget.memberList.length > 5 && !_showMore
                  ? widget.memberList.sublist(0, 5)
                  : widget.memberList)
              .map(
                (memberId) => GatheringMemberCard(
                  memberId: memberId,
                  isOrganizer: memberId == widget.organizerId,
                ),
              )
              .toList(),
          if (widget.memberList.length > 5 && !_showMore)
            GestureDetector(
              onTap: () => setState(() => _showMore = !_showMore),
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 12),
                width: double.infinity,
                height: 38,
                decoration: BoxDecoration(
                  color: kFontGray50Color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 15),
                    Text(
                      '더보기',
                      style: TextStyle(
                        fontSize: 13,
                        height: 17 / 13,
                        color: kFontGray600Color,
                      ),
                    ),
                    const SizedBox(width: 15),
                    SvgPicture.asset(
                      'assets/icons/svg/arrow_down_16px.svg',
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
