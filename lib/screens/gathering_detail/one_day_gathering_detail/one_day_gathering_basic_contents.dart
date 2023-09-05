import 'package:common/screens/gathering_detail/components/gathering_member_list.dart';
import 'package:flutter/material.dart';
import '../../../constants/constants_colors.dart';
import '../../../constants/constants_value.dart';
import '../../../models/one_day_gathering/one_day_gathering.dart';
import '../../../utils/date_utils.dart';
import '../../../utils/format_utils.dart';
import '../components/gathering_applicant_list.dart';
import '../components/gathering_content_card.dart';
import '../components/gathering_information_card.dart';
import '../components/gathering_organizer_card.dart';
import '../components/gathering_place_card.dart';
import '../components/gathering_status_card.dart';

class OneDayGatheringBasicContents extends StatelessWidget {
  final OneDayGathering gathering;
  const OneDayGatheringBasicContents({Key? key, required this.gathering})
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
          Container(
            width: double.infinity,
            height: 1,
            color: kFontGray50Color,
          ),
          const SizedBox(height: 20),
          GatheringOrganizerCard(organizerId: gathering.organizerId),
          const SizedBox(height: 12),
          GatheringContentCard(content: gathering.content),
          const SizedBox(height: 20),
          GatheringInformationCard(
            image: gathering.recruitWay == 'firstCome'
                ? 'assets/icons/svg/clock_20px.svg'
                : 'assets/icons/svg/inbox_20px.svg',
            title:
                gathering.recruitWay == 'firstCome' ? '선착순 하루모임' : '승인제 하루모임',
          ),
          const SizedBox(height: 16),
          GatheringInformationCard(
            image: 'assets/icons/svg/calendar_20px.svg',
            title: getDateDetail(gathering.openingDate),
          ),
          const SizedBox(height: 16),
          GatheringInformationCard(
            image: 'assets/icons/svg/people_20px.svg',
            title: '${gathering.capacity}명',
          ),
          if (gathering.isHaveEntryFee)
            Column(
              children: [
                const SizedBox(height: 16),
                GatheringInformationCard(
                  image: 'assets/icons/svg/wallet_20px.svg',
                  title: '${getMoneyFormat(gathering.entryFee)}원',
                ),
              ],
            ),
          const SizedBox(height: 16),
          GatheringPlaceCard(place: gathering.place),
          const SizedBox(height: 32),
          GatheringStatusCard(
            memberList: gathering.memberList,
            capacity: gathering.capacity,
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
                        TextSpan(text: '하루모임에 대해 궁금한 점이 있다면 '),
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
            title: '우리랑 하루모임 함께 해요',
            memberList: gathering.memberList,
            organizerId: gathering.organizerId,
          ),
          const SizedBox(height: 36),
          GatheringApplicantList(
            category: kOneDayGatheringCategory,
            gatheringId: gathering.id,
            applicantList: gathering.applicantList,
            organizerId: gathering.organizerId,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
