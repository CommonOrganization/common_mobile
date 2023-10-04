import 'package:flutter/material.dart';

import '../../../constants/constants_value.dart';

class ClubGatheringConnectedDailyContents extends StatelessWidget {
  final String gatheringId;
  const ClubGatheringConnectedDailyContents({Key? key, required this.gatheringId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: kScreenDefaultHeight,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
         //TODO 여기서 연결된 일상 보여주기
        ],
      ),
    );
  }
}
