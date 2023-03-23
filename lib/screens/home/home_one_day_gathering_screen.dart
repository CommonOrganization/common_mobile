import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/services/firebase_one_day_gathering_service.dart';
import 'package:flutter/material.dart';
import '../../widgets/one_day_gathering_card.dart';

class HomeOneDayGatheringScreen extends StatelessWidget {
  const HomeOneDayGatheringScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        FutureBuilder(
          future: FirebaseOneDayGatheringService.getGathering(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<OneDayGathering> gatheringList =
                  snapshot.data as List<OneDayGathering>;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 20),
                      ...gatheringList
                          .map(
                            (gathering) => Container(
                              margin: const EdgeInsets.only(right: 16),
                              child: OneDayGatheringCard(gathering: gathering),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ],
    );
  }
}
