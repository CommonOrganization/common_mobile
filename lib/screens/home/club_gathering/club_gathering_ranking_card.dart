import 'package:common/constants/constants_colors.dart';
import 'package:common/constants/constants_enum.dart';
import 'package:common/constants/constants_value.dart';
import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/screens/gathering_detail/club_gathering_detail/club_gathering_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utils/format_utils.dart';
import '../components/gathering_favorite_button.dart';

class ClubGatheringRankingCard extends StatefulWidget {
  final ClubGathering gathering;
  final int rank;
  final int gatheringSize;
  final String userId;
  const ClubGatheringRankingCard(
      {Key? key,
      required this.gathering,
      required this.rank,
      required this.gatheringSize,
      required this.userId})
      : super(key: key);

  @override
  State<ClubGatheringRankingCard> createState() =>
      _ClubGatheringRankingCardState();
}

class _ClubGatheringRankingCardState extends State<ClubGatheringRankingCard> {
  bool get showBorder => widget.rank != widget.gatheringSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ClubGatheringDetailScreen(gathering: widget.gathering),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 104,
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 30),
                child: Row(
                  children: [
                    Text(
                      '${widget.rank}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kFontGray800Color,
                        height: 30 / 20,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: kDarkGray20Color,
                          image: DecorationImage(
                            image: NetworkImage(widget.gathering.mainImage),
                            fit: BoxFit.cover,
                          )),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.gathering.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              height: 21 / 16,
                              letterSpacing: -0.5,
                              color: kFontGray900Color,
                            ),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                  'assets/icons/svg/location_15px.svg'),
                              const SizedBox(width: 4),
                              Text(
                                getCityNamesString(widget.gathering.cityList),
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 16 / 12,
                                  letterSpacing: -0.5,
                                  color: kFontGray500Color,
                                ),
                              ),
                              const Spacer(),
                              GatheringFavoriteButton(
                                category: kClubGatheringCategory,
                                userId: widget.userId,
                                gatheringId: widget.gathering.id,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              SvgPicture.asset(
                                  'assets/icons/svg/people_15px.svg'),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.gathering.capacity}명',
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 16 / 12,
                                  letterSpacing: -0.5,
                                  color: kFontGray500Color,
                                ),
                              ),
                              const SizedBox(width: 8),
                              SvgPicture.asset(
                                  'assets/icons/svg/clock_15px.svg'),
                              const SizedBox(width: 4),
                              Builder(builder: (context) {
                                RecruitWay recruitWay =
                                    RecruitWayMap.getRecruitWay(
                                        widget.gathering.recruitWay);
                                return Text(
                                  recruitWay.title,
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 16 / 12,
                                    letterSpacing: -0.5,
                                    color: kFontGray500Color,
                                  ),
                                );
                              })
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (showBorder)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 7),
                width: double.infinity,
                height: 1,
                color: kFontGray50Color,
              )
          ],
        ),
      ),
    );
  }
}
