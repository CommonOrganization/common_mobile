import 'package:common/constants/constants_value.dart';
import 'package:common/controllers/block_controller.dart';
import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/widgets/club_gathering_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants_colors.dart';
import '../home_contents_sub_screen.dart';

class ClubGatheringContentsArea extends StatelessWidget {
  final Future future;
  final String title;

  const ClubGatheringContentsArea(
      {super.key, required this.future, required this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer<BlockController>(builder: (context, controller, child) {
      return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ClubGathering>? gatheringList = snapshot.data;
            if (gatheringList == null) return Container();

            gatheringList = gatheringList
                .where((gathering) =>
                    !controller.blockedObjectList.contains(gathering.id))
                .where((gathering) => !controller.blockedObjectList
                    .contains(gathering.organizerId))
                .toList();

            if (gatheringList.isEmpty) return Container();
            int gatheringSize =
                gatheringList.length > 5 ? 5 : gatheringList.length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeContentsSubScreen(
                        category: kClubGatheringCategory,
                        future: future,
                        title: title,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 20 / 18,
                              color: kFontGray900Color,
                            ),
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/icons/svg/arrow_more_22px.svg',
                        ),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 20),
                        ...gatheringList
                            .sublist(0, gatheringSize)
                            .map((gathering) => Container(
                                  margin: const EdgeInsets.only(right: 16),
                                  child:
                                      ClubGatheringCard(gathering: gathering),
                                )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            );
          }
          return const SizedBox(height: 300);
        },
      );
    });
  }
}
