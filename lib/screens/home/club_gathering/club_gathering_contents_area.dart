import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/widgets/club_gathering_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/constants_colors.dart';

class ClubGatheringContentsArea extends StatelessWidget {
  final Future future;
  final String title;
  const ClubGatheringContentsArea(
      {Key? key, required this.future, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ClubGathering> gatheringList =
              snapshot.data as List<ClubGathering>;
          if (gatheringList.isEmpty) return Container();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
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
                    SvgPicture.asset('assets/icons/svg/arrow_more_22px.svg'),
                  ],
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
                          .map((gathering) => Container(
                                margin: const EdgeInsets.only(right: 16),
                                child: ClubGatheringCard(gathering: gathering),
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
        return Container();
      },
    );
  }
}
