import 'package:common/controllers/user_controller.dart';
import 'package:common/models/gathering/gathering.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/screens/gathering_detail/one_day_gathering_detail/one_day_gathering_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants_colors.dart';
import '../../../constants/constants_enum.dart';
import '../../../constants/constants_value.dart';
import '../../../services/firebase_gathering_service.dart';

class OneDayGatheringCalendarCard extends StatefulWidget {
  final int count;
  final OneDayGathering gathering;
  const OneDayGatheringCalendarCard(
      {Key? key, required this.count, required this.gathering})
      : super(key: key);

  @override
  State<OneDayGatheringCalendarCard> createState() =>
      _OneDayGatheringCalendarCardState();
}

class _OneDayGatheringCalendarCardState
    extends State<OneDayGatheringCalendarCard> {
  late String _userId;

  @override
  void initState() {
    super.initState();
    _userId = context.read<UserController>().user!.id;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OneDayGatheringDetailScreen(gathering: widget.gathering),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: widget.count < 2 ? 12 : 0),
        width: double.infinity,
        height: 106,
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: kFontGray50Color, width: 0.5),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 2),
              blurRadius: 5,
              color: kBlackColor.withOpacity(0.08),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 18,
                      right: 16,
                    ),
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: kDarkGray20Color,
                      image: DecorationImage(
                        image: NetworkImage(widget.gathering.mainImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Builder(
                        builder: (context) {
                          CommonCategory category =
                              CommonCategoryMap.getCategory(
                                  widget.gathering.category);
                          return Row(
                            children: [
                              SizedBox(
                                width: 22,
                                height: 22,
                                child: Image.asset(category.miniImage),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                category.title,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: kFontGray600Color,
                                  height: 17 / 12,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.gathering.title,
                        style: TextStyle(
                            fontSize: 16,
                            height: 22 / 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                            color: kFontGray900Color),
                      ),
                      const SizedBox(height: 6),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            customIconTextArea(
                              icon: 'assets/icons/svg/location_18px.svg',
                              title:
                                  '${widget.gathering.place['county']} ${widget.gathering.place['dong']}',
                            ),
                            const SizedBox(width: 12),
                            customIconTextArea(
                              icon: 'assets/icons/svg/people_18px.svg',
                              title: '${widget.gathering.capacity}명',
                            ),
                            const SizedBox(width: 12),
                            Builder(builder: (context) {
                              DateTime openingDate =
                                  DateTime.parse(widget.gathering.openingDate);
                              return customIconTextArea(
                                icon: 'assets/icons/svg/calendar_18px.svg',
                                title:
                                    '${openingDate.month}월 ${openingDate.day}일',
                              );
                            }),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: FutureBuilder(
                  future: FirebaseGatheringService.get(
                      category: kOneDayGatheringCategory,
                      id: widget.gathering.id,
                      field: 'favoriteList'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List favoriteList = snapshot.data as List;
                      bool value = favoriteList.contains(_userId);
                      return GestureDetector(
                        onTap: () async {
                          if (value) {
                            favoriteList.remove(_userId);
                          } else {
                            favoriteList.add(_userId);
                          }
                          FirebaseGatheringService.update(
                            category: kOneDayGatheringCategory,
                            id: widget.gathering.id,
                            field: 'favoriteList',
                            value: favoriteList,
                          ).then((value) => setState(() {}));
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          color: kWhiteColor,
                          child: SvgPicture.asset(
                            'assets/icons/svg/favorite_${value ? 'active' : 'inactive'}_20px.svg',
                          ),
                        ),
                      );
                    }

                    return Container(
                      width: 20,
                      height: 20,
                      color: kWhiteColor,
                      child: SvgPicture.asset(
                        'assets/icons/svg/favorite_inactive_20px.svg',
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget customIconTextArea({required String icon, required String title}) {
    return Row(
      children: [
        SvgPicture.asset(icon),
        const SizedBox(width: 3),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            height: 17 / 13,
            letterSpacing: -0.5,
            color: kFontGray500Color,
          ),
        )
      ],
    );
  }
}
