import 'package:common/constants/constants_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<OneDayGathering> gatheringList =
              snapshot.data as List<OneDayGathering>;
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
                                child:
                                    OneDayGatheringCard(gathering: gathering),
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
