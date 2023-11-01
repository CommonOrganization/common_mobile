import 'package:common/constants/constants_colors.dart';
import 'package:common/constants/constants_value.dart';
import 'package:common/controllers/block_controller.dart';
import 'package:common/screens/home/home_contents_sub_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../models/one_day_gathering/one_day_gathering.dart';
import '../../../widgets/one_day_gathering_card.dart';

class OneDayGatheringContentsArea extends StatelessWidget {
  final Future future;
  final String title;
  const OneDayGatheringContentsArea(
      {Key? key, required this.future, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BlockController>(
      builder: (context, controller, child) {
        return FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<OneDayGathering>? gatheringList = snapshot.data;
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
                          category: kOneDayGatheringCategory,
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
                                    child: OneDayGatheringCard(
                                        gathering: gathering),
                                  ))
                              .toList(),
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
      },
    );
  }
}
