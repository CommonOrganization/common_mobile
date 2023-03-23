import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/services/firebase_club_gathering_service.dart';
import 'package:common/widgets/club_gathering_card.dart';
import 'package:flutter/material.dart';

class HomeClubGatheringScreen extends StatelessWidget {
  const HomeClubGatheringScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        FutureBuilder(
          future: FirebaseClubGatheringService.getGathering(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ClubGathering> gatheringList =
                  snapshot.data as List<ClubGathering>;
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
                              child: ClubGatheringCard(gathering: gathering),
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
