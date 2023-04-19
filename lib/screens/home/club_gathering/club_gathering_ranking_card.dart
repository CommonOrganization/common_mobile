import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:flutter/material.dart';

class ClubGatheringRankingCard extends StatefulWidget {
  final ClubGathering gathering;
  const ClubGatheringRankingCard({Key? key, required this.gathering})
      : super(key: key);

  @override
  State<ClubGatheringRankingCard> createState() =>
      _ClubGatheringRankingCardState();
}

class _ClubGatheringRankingCardState extends State<ClubGatheringRankingCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 104,
      child: Row(
        children: [],
      ),
    );
  }
}
