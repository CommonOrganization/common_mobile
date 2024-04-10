import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/screens/gathering_detail/components/connected_gathering_card.dart';
import 'package:common/services/one_day_gathering_service.dart';
import 'package:flutter/material.dart';
import '../../../constants/constants_value.dart';


class ClubGatheringConnectedGatheringContents extends StatelessWidget {
  final String gatheringId;
  const ClubGatheringConnectedGatheringContents(
      {super.key, required this.gatheringId});

  @override
  Widget build(BuildContext context) {
     return Container(
       constraints: const BoxConstraints(
         minHeight: kScreenDefaultHeight,
       ),
       child: FutureBuilder(
         future: OneDayGatheringService.getConnectedGathering(clubGatheringId: gatheringId),
         builder: (context, snapshot) {
           if(snapshot.hasData){
             List<OneDayGathering>? gatheringList = snapshot.data;
             if(gatheringList==null) return Container();
             return Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 const SizedBox(height: 20),
                 ...gatheringList.map(
                       (gathering) => ConnectedGatheringCard(gathering: gathering),
                 ),
               ],
             );
           }
           return Container();
         }
       ),
     );
  }
}
