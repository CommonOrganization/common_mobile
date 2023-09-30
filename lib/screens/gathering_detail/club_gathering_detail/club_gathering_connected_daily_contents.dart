import 'package:flutter/material.dart';

import '../../../constants/constants_value.dart';

class ClubGatheringConnectedDailyContents extends StatelessWidget {
  const ClubGatheringConnectedDailyContents({Key? key}) : super(key: key);

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
         //TODO 여기서 연결된 일상 보여주기
        ],
      ),
    );
  }
}
