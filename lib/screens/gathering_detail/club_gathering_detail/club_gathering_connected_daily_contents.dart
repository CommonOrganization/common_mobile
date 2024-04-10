import 'package:common/models/daily/daily.dart';
import 'package:common/services/daily_service.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants_value.dart';
import '../../../widgets/daily_card.dart';

class ClubGatheringConnectedDailyContents extends StatelessWidget {
  final String gatheringId;
  const ClubGatheringConnectedDailyContents(
      {super.key, required this.gatheringId});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: kScreenDefaultHeight,
      ),
      child: FutureBuilder(
          future: DailyService.getClubGatheringConnectedDaily(
              clubGatheringId: gatheringId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Daily>? dailyList = snapshot.data;
              if (dailyList == null) return Container();
              return GridView.count(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const ClampingScrollPhysics(),
                crossAxisCount: 3,
                children:
                    dailyList.map((daily) => DailyCard(daily: daily)).toList(),
              );
            }
            return Container();
          }),
    );
  }
}
