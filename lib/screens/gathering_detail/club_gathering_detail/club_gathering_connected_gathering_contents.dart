import 'package:common/constants/constants_colors.dart';
import 'package:common/constants/constants_enum.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/screens/gathering_detail/components/connected_gathering_card.dart';
import 'package:common/services/firebase_club_gathering_service.dart';
import 'package:common/services/firebase_one_day_gathering_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../models/club_gathering/club_gathering.dart';
import '../../../utils/date_utils.dart';


class ClubGatheringConnectedGatheringContents extends StatelessWidget {
  final List<OneDayGathering> gatheringList;
  const ClubGatheringConnectedGatheringContents(
      {Key? key, required this.gatheringList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        ...gatheringList.map(
              (gathering) => ConnectedGatheringCard(gathering: gathering),
        )
      ],
    );
  }
}
