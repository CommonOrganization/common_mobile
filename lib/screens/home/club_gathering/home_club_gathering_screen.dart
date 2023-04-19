import 'package:common/constants/constants_value.dart';
import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/services/firebase_club_gathering_service.dart';
import 'package:common/widgets/club_gathering_card.dart';
import 'package:flutter/material.dart';

import '../components/gathering_category_container.dart';
import 'club_gathering_contents_area.dart';

class HomeClubGatheringScreen extends StatelessWidget {
  const HomeClubGatheringScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const GatheringCategoryContainer(category: kClubGatheringCategory),
        ClubGatheringContentsArea(
          future: FirebaseClubGatheringService.getGathering(),
          title: '인기 급상승 소모임',
        ),
        ClubGatheringContentsArea(
          future: FirebaseClubGatheringService.getGathering(),
          title: '추천하는 소모임',
        ),
      ],
    );
  }
}
