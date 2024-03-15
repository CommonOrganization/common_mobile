import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/screens/gathering_detail/components/gathering_member_list.dart';
import 'package:flutter/material.dart';
import '../../../constants/constants_colors.dart';
import '../../../constants/constants_value.dart';
import '../components/gathering_applier_list.dart';
import '../components/gathering_content_card.dart';
import '../components/gathering_information_card.dart';
import '../components/gathering_organizer_card.dart';
import '../components/gathering_status_card.dart';

class ClubGatheringBasicContents extends StatelessWidget {
  final ClubGathering gathering;
  const ClubGatheringBasicContents({Key? key, required this.gathering})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: kScreenDefaultHeight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          GatheringOrganizerCard(organizerId: gathering.organizerId),
          const SizedBox(height: 12),
          GatheringContentCard(content: gathering.content),
          const SizedBox(height: 20),
          GatheringInformationCard(
            image: gathering.recruitWay == 'firstCome'
                ? 'assets/icons/svg/clock_20px.svg'
                : 'assets/icons/svg/inbox_20px.svg',
            title: gathering.recruitWay == 'firstCome' ? '선착순 소모임' : '승인제 소모임',
          ),
          const SizedBox(height: 16),
          GatheringInformationCard(
            image: 'assets/icons/svg/people_20px.svg',
            title: '${gathering.capacity}명',
          ),
          const SizedBox(height: 28),
          GatheringStatusCard(
            capacity: gathering.capacity,
            organizerId: gathering.organizerId,
            gatheringId: gathering.id,
          ),
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 6),
                Container(
                  alignment: Alignment.centerLeft,
                  width: 14,
                  height: 14,
                  child: Text(
                    'ⓘ',
                    style: TextStyle(
                      fontSize: 11,
                      color: kFontGray400Color,
                      height: 16 / 11,
                    ),
                  ),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 11,
                        color: kFontGray400Color,
                        height: 16 / 11,
                      ),
                      children: const [
                        TextSpan(text: '소모임에 대해 궁금한 점이 있다면 '),
                        TextSpan(
                          text: '모임장과 채팅하기',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: '를 통해 물어보세요!'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),
          GatheringMemberList(
            title: '우리랑 소모임 함께 해요',
            gatheringId: gathering.id,
            organizerId: gathering.organizerId,
          ),
          const SizedBox(height: 36),
          GatheringApplierList(
            category: kClubGatheringCategory,
            gatheringId: gathering.id,
            organizerId: gathering.organizerId,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
